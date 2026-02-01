//
//  WaveformTunerView.swift
//  PitchPup
//

import SwiftUI
import Combine

struct WaveformTunerView: View {
    @Environment(TunerState.self) private var tunerState

    @State private var waveformBuffer: [Float] = Array(repeating: 0, count: 200)
    @State private var displayMode: DisplayMode = .auto

    enum DisplayMode: String, CaseIterable {
        case auto = "Auto"
        case hz = "Hz"
    }

    // Theme colors
    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.12)
    private let waveformColor = Color(red: 0.4, green: 0.9, blue: 0.7)
    private let highlightColor = Color(red: 0.95, green: 0.8, blue: 0.3) // Gold/yellow
    private let dimColor = Color(red: 0.3, green: 0.35, blue: 0.3)

    private let pitchProcessor = PitchProcessor()

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                backgroundColor.ignoresSafeArea()

                HStack(spacing: 0) {
                    // Waveform area
                    ZStack(alignment: .bottomLeading) {
                        // Waveform canvas
                        WaveformCanvas(samples: waveformBuffer, color: waveformColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        // Center line
                        Rectangle()
                            .fill(waveformColor.opacity(0.3))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .position(x: (width - 60) / 2, y: height / 2)

                        // Frequency overlay
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(tunerState.displayFrequency)
                                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                                    .foregroundColor(waveformColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(backgroundColor.opacity(0.8))
                                    .cornerRadius(4)
                                Spacer()
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .frame(width: width - 60)

                    // Note ladder
                    NoteLadder(
                        currentMidiNote: currentMidiNote,
                        highlightColor: highlightColor,
                        dimColor: dimColor,
                        pitchProcessor: pitchProcessor
                    )
                    .frame(width: 60)
                }

                // Bottom controls
                VStack {
                    Spacer()
                    HStack {
                        // Display mode toggle
                        HStack(spacing: 2) {
                            ForEach(DisplayMode.allCases, id: \.self) { mode in
                                Button {
                                    displayMode = mode
                                } label: {
                                    Text(mode.rawValue)
                                        .font(.system(size: 10, weight: .medium))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(displayMode == mode ? waveformColor.opacity(0.3) : Color.clear)
                                        .foregroundColor(displayMode == mode ? waveformColor : dimColor)
                                        .cornerRadius(3)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(3)
                        .background(backgroundColor.opacity(0.8))
                        .cornerRadius(5)

                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
        }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { _ in
            updateWaveform()
        }
    }

    private var currentMidiNote: Int {
        guard tunerState.hasValidPitch else { return 69 } // Default to A4
        let result = pitchProcessor.process(frequency: tunerState.frequency)
        return result.midiNote
    }

    private func updateWaveform() {
        // Simulate waveform data based on amplitude
        // In a real implementation, this would come from audio buffer
        let amplitude = Float(tunerState.amplitude)
        let hasSignal = tunerState.hasValidPitch

        waveformBuffer.removeFirst()

        if hasSignal && amplitude > 0.01 {
            // Generate a point influenced by frequency for visual effect
            let frequency = tunerState.frequency
            let phase = Double(waveformBuffer.count) * 0.1 * (frequency / 440.0)
            let value = Float(sin(phase)) * amplitude * 0.8 + Float.random(in: -0.05...0.05)
            waveformBuffer.append(value)
        } else {
            // Noise floor when no signal
            waveformBuffer.append(Float.random(in: -0.02...0.02))
        }
    }
}

// MARK: - Waveform Canvas

struct WaveformCanvas: View {
    let samples: [Float]
    let color: Color

    var body: some View {
        Canvas { context, size in
            let midY = size.height / 2
            let stepX = size.width / CGFloat(samples.count - 1)
            let amplitudeScale = size.height * 0.4

            var path = Path()
            path.move(to: CGPoint(x: 0, y: midY))

            for (index, sample) in samples.enumerated() {
                let x = CGFloat(index) * stepX
                let y = midY - CGFloat(sample) * amplitudeScale
                path.addLine(to: CGPoint(x: x, y: y))
            }

            context.stroke(path, with: .color(color), lineWidth: 1.5)
        }
    }
}

// MARK: - Note Ladder

struct NoteLadder: View {
    let currentMidiNote: Int
    let highlightColor: Color
    let dimColor: Color
    let pitchProcessor: PitchProcessor

    var body: some View {
        VStack(spacing: 0) {
            ForEach(nearbyNotes.reversed(), id: \.midiNote) { note in
                let isCurrentNote = note.midiNote == currentMidiNote

                HStack {
                    Spacer()
                    Text(note.noteName)
                        .font(.system(size: isCurrentNote ? 16 : 12, weight: isCurrentNote ? .bold : .regular, design: .monospaced))
                        .foregroundColor(isCurrentNote ? highlightColor : dimColor)
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .background(isCurrentNote ? highlightColor.opacity(0.2) : Color.clear)
            }
        }
        .padding(.vertical, 8)
    }

    private var nearbyNotes: [(noteName: String, midiNote: Int, frequency: Double)] {
        pitchProcessor.nearbyNotes(forMidiNote: currentMidiNote, range: 2)
    }
}

#Preview {
    let state = TunerState()
    state.frequency = 294.4
    state.noteName = "D"
    state.octave = 4
    state.cents = 5
    state.amplitude = 0.3

    return WaveformTunerView()
        .environment(state)
        .frame(width: 320, height: 200)
}
