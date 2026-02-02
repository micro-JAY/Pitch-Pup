//
//  AudioEngine.swift
//  PitchPup
//

import AVFoundation
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import CoreAudio

@MainActor
final class AudioCaptureEngine {
    private var engine: AudioKit.AudioEngine?
    private var pitchTap: PitchTap?
    private var mic: AudioKit.AudioEngine.InputNode?
    private var mixer: Mixer?
    private var silentOutput: Fader?

    private weak var tunerState: TunerState?

    private let pitchProcessor = PitchProcessor()
    private var smoothedFrequency: Double = 0.0
    private let smoothingFactor: Double = 0.3

    var isRunning: Bool {
        engine?.avEngine.isRunning ?? false
    }

    private var wasRunningBeforePause: Bool = false

    func pause() {
        wasRunningBeforePause = isRunning
        if isRunning {
            pitchTap?.stop()
            engine?.pause()
        }
    }

    func resume() async throws {
        if wasRunningBeforePause && !isRunning {
            try engine?.start()
            pitchTap?.start()
        }
    }

    init(tunerState: TunerState) {
        self.tunerState = tunerState
    }

    /// Switch to a different audio input device
    func switchDevice(to deviceUID: String) async throws {
        let wasRunning = isRunning
        if wasRunning {
            stop()
        }

        // Update tuner state
        tunerState?.selectedDeviceID = deviceUID

        // Restart if we were running
        if wasRunning {
            try await start()
        }
    }

    func start() async throws {
        guard let tunerState else { return }

        // Check permission first
        let granted = await requestMicrophonePermission()
        tunerState.microphonePermissionGranted = granted
        tunerState.microphonePermissionDenied = !granted

        guard granted else { return }

        // Set the input device before creating the AudioKit engine
        if let selectedUID = tunerState.selectedDeviceID {
            setInputDevice(uid: selectedUID)
        }

        // Set up the audio engine
        engine = AudioKit.AudioEngine()

        guard let engine else { return }

        // Get microphone input
        mic = engine.input

        guard let mic else {
            throw AudioEngineError.noInputAvailable
        }

        // Create a mixer to route audio (required for PitchTap)
        mixer = Mixer(mic)

        guard let mixer else { return }

        // Set up pitch detection tap on the mixer (at full volume for analysis)
        pitchTap = PitchTap(mixer, bufferSize: 2048) { [weak self] frequencies, amplitudes in
            Task { @MainActor in
                self?.handlePitchUpdate(frequencies: frequencies, amplitudes: amplitudes)
            }
        }

        // Create a silent fader (gain=0) so we don't hear mic playback
        silentOutput = Fader(mixer, gain: 0)

        // Connect silent fader to engine output
        engine.output = silentOutput

        // Start the engine
        try engine.start()

        // Start the pitch tap
        pitchTap?.start()

        tunerState.isOn = true
    }

    /// Set the system default input device to the specified device UID
    private func setInputDevice(uid: String) {
        // Find the AudioDeviceID for the given UID
        var propertySize: UInt32 = 0
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        // Get the size of the device list
        AudioObjectGetPropertyDataSize(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            &propertySize
        )

        let deviceCount = Int(propertySize) / MemoryLayout<AudioDeviceID>.size
        var deviceIDs = [AudioDeviceID](repeating: 0, count: deviceCount)

        // Get all device IDs
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            &propertySize,
            &deviceIDs
        )

        // Find the device with matching UID
        for deviceID in deviceIDs {
            var uidAddress = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyDeviceUID,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain
            )

            var uidSize = UInt32(MemoryLayout<CFString>.size)
            var deviceUID: CFString?

            let status = withUnsafeMutablePointer(to: &deviceUID) { ptr in
                AudioObjectGetPropertyData(deviceID, &uidAddress, 0, nil, &uidSize, ptr)
            }

            if status == noErr, let deviceUID = deviceUID as String?, deviceUID == uid {
                // Check if this device has input channels
                var inputAddress = AudioObjectPropertyAddress(
                    mSelector: kAudioDevicePropertyStreamConfiguration,
                    mScope: kAudioDevicePropertyScopeInput,
                    mElement: kAudioObjectPropertyElementMain
                )

                var inputSize: UInt32 = 0
                AudioObjectGetPropertyDataSize(deviceID, &inputAddress, 0, nil, &inputSize)

                if inputSize > 0 {
                    // Set as default input device
                    var defaultAddress = AudioObjectPropertyAddress(
                        mSelector: kAudioHardwarePropertyDefaultInputDevice,
                        mScope: kAudioObjectPropertyScopeGlobal,
                        mElement: kAudioObjectPropertyElementMain
                    )

                    var mutableDeviceID = deviceID
                    AudioObjectSetPropertyData(
                        AudioObjectID(kAudioObjectSystemObject),
                        &defaultAddress,
                        0,
                        nil,
                        UInt32(MemoryLayout<AudioDeviceID>.size),
                        &mutableDeviceID
                    )
                }
                break
            }
        }
    }

    func stop() {
        pitchTap?.stop()
        engine?.stop()

        pitchTap = nil
        silentOutput = nil
        mixer = nil
        mic = nil
        engine = nil

        tunerState?.isOn = false
        tunerState?.frequency = 0
        tunerState?.amplitude = 0
        tunerState?.noteName = "--"
        tunerState?.cents = 0
        tunerState?.isInTune = false
    }

    private func handlePitchUpdate(frequencies: [Float], amplitudes: [Float]) {
        guard let tunerState else { return }

        let frequency = Double(frequencies[0])
        let amplitude = Double(amplitudes[0])

        // Apply smoothing to reduce jitter
        if frequency > 20 && frequency < 20000 && amplitude > 0.01 {
            smoothedFrequency = smoothedFrequency * (1 - smoothingFactor) + frequency * smoothingFactor
        } else {
            smoothedFrequency = 0
        }

        tunerState.frequency = smoothedFrequency
        tunerState.amplitude = amplitude

        // Process pitch to get note info
        if smoothedFrequency > 0 {
            let result = pitchProcessor.process(frequency: smoothedFrequency)
            tunerState.noteName = result.noteName
            tunerState.octave = result.octave
            tunerState.cents = result.cents
            tunerState.isInTune = abs(result.cents) <= 5
        } else {
            tunerState.noteName = "--"
            tunerState.octave = 4
            tunerState.cents = 0
            tunerState.isInTune = false
        }
    }

    // MARK: - Microphone Permission

    private func requestMicrophonePermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)

        switch status {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .audio)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    // MARK: - Device Enumeration

    func refreshDevices() {
        guard let tunerState else { return }

        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.microphone, .external],
            mediaType: .audio,
            position: .unspecified
        )

        tunerState.availableDevices = discoverySession.devices.map { device in
            AudioInputDevice(id: device.uniqueID, name: device.localizedName)
        }

        // Set default device if none selected
        if tunerState.selectedDeviceID == nil, let first = tunerState.availableDevices.first {
            tunerState.selectedDeviceID = first.id
        }

        // Check if currently selected device is still available
        if let selectedID = tunerState.selectedDeviceID,
           !tunerState.availableDevices.contains(where: { $0.id == selectedID }) {
            // Device was disconnected, select first available
            tunerState.selectedDeviceID = tunerState.availableDevices.first?.id

            // If we were running, we need to restart with new device
            if isRunning {
                stop()
                Task {
                    try? await start()
                }
            }
        }
    }

    func startDeviceObservation() {
        // Observe device connection changes
        NotificationCenter.default.addObserver(
            forName: AVCaptureDevice.wasConnectedNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshDevices()
        }

        NotificationCenter.default.addObserver(
            forName: AVCaptureDevice.wasDisconnectedNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshDevices()
        }
    }
}

enum AudioEngineError: Error, LocalizedError {
    case noInputAvailable
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .noInputAvailable:
            return "No audio input device available"
        case .permissionDenied:
            return "Microphone access denied"
        }
    }
}
