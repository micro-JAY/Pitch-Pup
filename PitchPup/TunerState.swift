//
//  TunerState.swift
//  PitchPup
//

import SwiftUI
import AVFoundation

enum VisualizationMode: String, CaseIterable {
    case arc
    case waveform
}

struct AudioInputDevice: Identifiable, Hashable {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

@Observable
final class TunerState {
    // Audio capture state
    var isOn: Bool = false
    var selectedDeviceID: String? = nil
    var availableDevices: [AudioInputDevice] = []

    // Pitch detection results
    var frequency: Double = 0.0
    var amplitude: Double = 0.0
    var noteName: String = "--"
    var octave: Int = 4
    var cents: Double = 0.0
    var isInTune: Bool = false

    // Waveform data for visualization
    var waveformSamples: [Float] = []

    // UI preferences
    var viewMode: VisualizationMode = .arc
    var hoverModeEnabled: Bool = false

    // Permission state
    var microphonePermissionGranted: Bool = false
    var microphonePermissionDenied: Bool = false

    // Computed property for display
    var hasValidPitch: Bool {
        frequency > 20 && frequency < 20000 && amplitude > 0.01
    }

    var displayFrequency: String {
        guard hasValidPitch else { return "-- Hz" }
        return String(format: "%.1f Hz", frequency)
    }

    var displayNote: String {
        guard hasValidPitch else { return "--" }
        return noteName
    }

    var displayNoteWithOctave: String {
        guard hasValidPitch else { return "--" }
        return "\(noteName)\(octave)"
    }
}
