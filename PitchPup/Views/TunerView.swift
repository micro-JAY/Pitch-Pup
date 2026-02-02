//
//  TunerView.swift
//  PitchPup
//

import SwiftUI

struct TunerView: View {
    @Environment(TunerState.self) private var tunerState
    @State private var audioEngine: AudioCaptureEngine?

    // Theme colors
    private let backgroundColor = Color(red: 0.08, green: 0.08, blue: 0.1)
    private let controlColor = Color(red: 0.4, green: 0.9, blue: 0.7)

    var body: some View {
        VStack(spacing: 0) {
            // Control bar at top
            controlBar
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(backgroundColor.opacity(0.95))

            Divider()
                .background(controlColor.opacity(0.2))

            // Visualization area
            visualizationView
        }
        .frame(width: 320, height: tunerState.viewMode == .arc ? 240 : 260)
        .background(backgroundColor)
        .onAppear {
            audioEngine = AudioCaptureEngine(tunerState: tunerState)
        }
    }

    // MARK: - Control Bar

    private var controlBar: some View {
        HStack(spacing: 12) {
            // On/Off toggle
            Toggle(isOn: Binding(
                get: { tunerState.isOn },
                set: { newValue in
                    Task {
                        if newValue {
                            try? await audioEngine?.start()
                        } else {
                            audioEngine?.stop()
                        }
                    }
                }
            )) {
                Image(systemName: tunerState.isOn ? "mic.fill" : "mic.slash")
                    .foregroundColor(tunerState.isOn ? controlColor : .secondary)
            }
            .toggleStyle(.switch)
            .tint(controlColor)

            Spacer()

            // Hover mode toggle
            Button {
                tunerState.hoverModeEnabled.toggle()
            } label: {
                Image(systemName: tunerState.hoverModeEnabled ? "pin.fill" : "pin")
                    .foregroundColor(tunerState.hoverModeEnabled ? controlColor : .secondary)
            }
            .buttonStyle(.plain)
            .help("Keep window on top")

            // Settings menu (view mode + quit)
            Menu {
                // View mode toggle
                Button {
                    toggleViewMode()
                } label: {
                    Label(
                        tunerState.viewMode == .arc ? "Waveform View" : "Arc View",
                        systemImage: tunerState.viewMode == .arc ? "waveform" : "dial.medium"
                    )
                }

                Divider()

                // Quit button
                Button("Quit PitchPup") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(.secondary)
            }
            .menuStyle(.borderlessButton)
            .frame(width: 20)
        }
    }

    // MARK: - Visualization

    @ViewBuilder
    private var visualizationView: some View {
        ZStack {
            if tunerState.viewMode == .arc {
                ArcTunerView()
                    .transition(.opacity)
            } else {
                WaveformTunerView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: tunerState.viewMode)
    }

    private func toggleViewMode() {
        tunerState.viewMode = tunerState.viewMode == .arc ? .waveform : .arc
    }
}

// MARK: - Permission Denied View

struct PermissionDeniedView: View {
    private let controlColor = Color(red: 0.4, green: 0.9, blue: 0.7)

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "mic.slash.circle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("Microphone Access Required")
                .font(.headline)

            Text("PitchPup needs microphone access to detect pitch. Enable it in System Settings → Privacy & Security → Microphone.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Open System Settings") {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") {
                    NSWorkspace.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(controlColor)
        }
        .padding()
    }
}

#Preview {
    let state = TunerState()
    state.frequency = 440.0
    state.noteName = "A"
    state.octave = 4
    state.cents = 0
    state.amplitude = 0.3

    return TunerView()
        .environment(state)
}
