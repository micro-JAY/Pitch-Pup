//
//  ArcTunerView.swift
//  PitchPup
//

import SwiftUI

struct ArcTunerView: View {
    @Environment(TunerState.self) private var tunerState

    // Animation state
    @State private var animatedCents: Double = 0

    // Theme colors
    private let accentColor = Color(red: 0.4, green: 0.9, blue: 0.7) // Green/teal
    private let backgroundColor = Color(red: 0.08, green: 0.08, blue: 0.1)
    private let inTuneColor = Color(red: 0.4, green: 1.0, blue: 0.6)

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let centerX = width / 2
            let arcRadius = width * 0.42
            let arcCenterY = height * 0.45

            ZStack {
                // Background
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Arc visualization area
                    ZStack {
                        // The deviation arc
                        ArcShape(startAngle: -160, endAngle: -20)
                            .stroke(
                                tunerState.hasValidPitch ? accentColor.opacity(0.4) : accentColor.opacity(0.2),
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .frame(width: arcRadius * 2, height: arcRadius)
                            .position(x: centerX, y: arcCenterY)

                        // Center marker (0)
                        Text("0")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(accentColor.opacity(0.8))
                            .position(x: centerX, y: arcCenterY - arcRadius - 12)

                        // Left marker (-50)
                        Text("-50")
                            .font(.system(size: 10, weight: .regular, design: .monospaced))
                            .foregroundColor(accentColor.opacity(0.6))
                            .position(x: centerX - arcRadius * 0.85, y: arcCenterY + 8)

                        // Right marker (+50)
                        Text("+50")
                            .font(.system(size: 10, weight: .regular, design: .monospaced))
                            .foregroundColor(accentColor.opacity(0.6))
                            .position(x: centerX + arcRadius * 0.85, y: arcCenterY + 8)

                        // Ball indicator
                        if tunerState.hasValidPitch {
                            BallIndicator(
                                cents: animatedCents,
                                arcRadius: arcRadius,
                                isInTune: tunerState.isInTune,
                                accentColor: accentColor,
                                inTuneColor: inTuneColor
                            )
                            .position(x: centerX, y: arcCenterY)
                        }
                    }
                    .frame(height: height * 0.55)

                    // Note and frequency display
                    VStack(spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 16) {
                            // Note name
                            Text(tunerState.displayNote)
                                .font(.system(size: 48, weight: .medium, design: .rounded))
                                .foregroundColor(tunerState.isInTune ? inTuneColor : accentColor)

                            // Frequency
                            Text(tunerState.displayFrequency)
                                .font(.system(size: 24, weight: .light, design: .monospaced))
                                .foregroundColor(accentColor.opacity(0.8))
                        }
                    }
                    .frame(height: height * 0.35)

                    Spacer()
                }
            }
        }
        .onChange(of: tunerState.cents) { _, newValue in
            withAnimation(.easeOut(duration: 0.1)) {
                animatedCents = newValue
            }
        }
    }
}

// MARK: - Arc Shape

struct ArcShape: Shape {
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = rect.width / 2

        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )

        return path
    }
}

// MARK: - Ball Indicator

struct BallIndicator: View {
    let cents: Double
    let arcRadius: Double
    let isInTune: Bool
    let accentColor: Color
    let inTuneColor: Color

    var body: some View {
        // Map cents (-50 to +50) to angle (-160 to -20 degrees)
        let normalizedCents = max(-50, min(50, cents))
        let angle = -160 + (normalizedCents + 50) * (140.0 / 100.0)
        let radians = angle * .pi / 180

        let x = cos(radians) * arcRadius
        let y = sin(radians) * arcRadius

        Circle()
            .fill(isInTune ? inTuneColor : accentColor)
            .frame(width: 20, height: 20)
            .shadow(color: (isInTune ? inTuneColor : accentColor).opacity(0.6), radius: 8)
            .offset(x: x, y: y)
    }
}

#Preview {
    let state = TunerState()
    state.frequency = 294.0
    state.noteName = "D"
    state.octave = 4
    state.cents = -12
    state.amplitude = 0.5

    return ArcTunerView()
        .environment(state)
        .frame(width: 280, height: 200)
}
