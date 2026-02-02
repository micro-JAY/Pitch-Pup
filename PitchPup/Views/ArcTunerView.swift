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

    // Formatted cents display
    private var centsDisplayString: String {
        guard tunerState.hasValidPitch else { return "-- ct" }
        let cents = Int(round(tunerState.cents))
        if cents == 0 {
            return "0 ct"
        } else if cents > 0 {
            return "+\(cents) ct"
        } else {
            return "\(cents) ct"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Arc visualization using Canvas for precise positioning
                    ArcCanvas(
                        cents: animatedCents,
                        hasValidPitch: tunerState.hasValidPitch,
                        isInTune: tunerState.isInTune,
                        accentColor: accentColor,
                        inTuneColor: inTuneColor
                    )
                    .frame(height: height * 0.48)

                    // Note, cents, and frequency display - centered
                    VStack(spacing: 4) {
                        Text(tunerState.displayNote)
                            .font(.system(size: 42, weight: .medium, design: .rounded))
                            .foregroundColor(tunerState.isInTune ? inTuneColor : accentColor)

                        Text(centsDisplayString)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(tunerState.isInTune ? inTuneColor.opacity(0.9) : accentColor.opacity(0.8))

                        Text(tunerState.displayFrequency)
                            .font(.system(size: 12, weight: .light, design: .monospaced))
                            .foregroundColor(accentColor.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: height * 0.42)

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

// MARK: - Arc Canvas

struct ArcCanvas: View {
    let cents: Double
    let hasValidPitch: Bool
    let isInTune: Bool
    let accentColor: Color
    let inTuneColor: Color

    // Arc configuration
    private let startAngle: Double = -150  // -50 cents (left)
    private let endAngle: Double = -30     // +50 cents (right)
    // -90° is top center (0 cents)

    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            let centerX = width / 2
            let arcRadius = width * 0.35

            // Arc center is below the visible canvas - arc curves upward into view
            let arcCenterY = height * 1.5

            // Draw the arc
            var arcPath = Path()
            arcPath.addArc(
                center: CGPoint(x: centerX, y: arcCenterY),
                radius: arcRadius,
                startAngle: .degrees(startAngle),
                endAngle: .degrees(endAngle),
                clockwise: false
            )
            context.stroke(
                arcPath,
                with: .color(hasValidPitch ? accentColor.opacity(0.5) : accentColor.opacity(0.25)),
                lineWidth: 2
            )

            // Calculate arc tip positions for labels
            let leftAngleRad = startAngle * .pi / 180
            let leftTipX = centerX + cos(leftAngleRad) * arcRadius
            let leftTipY = arcCenterY + sin(leftAngleRad) * arcRadius

            let rightAngleRad = endAngle * .pi / 180
            let rightTipX = centerX + cos(rightAngleRad) * arcRadius
            let rightTipY = arcCenterY + sin(rightAngleRad) * arcRadius

            // Draw -50 label (left of left tip)
            let leftLabel = Text("-50")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .foregroundColor(accentColor.opacity(0.6))
            context.draw(
                context.resolve(leftLabel),
                at: CGPoint(x: leftTipX - 18, y: leftTipY),
                anchor: .center
            )

            // Draw +50 label (right of right tip)
            let rightLabel = Text("+50")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .foregroundColor(accentColor.opacity(0.6))
            context.draw(
                context.resolve(rightLabel),
                at: CGPoint(x: rightTipX + 18, y: rightTipY),
                anchor: .center
            )

            // Draw ball indicator if pitch is valid
            if hasValidPitch {
                let normalizedCents = max(-50, min(50, cents))
                let angleRange = endAngle - startAngle  // 120 degrees
                let ballAngle = startAngle + (normalizedCents + 50) * (angleRange / 100.0)
                let ballRadians = ballAngle * .pi / 180

                let ballX = centerX + cos(ballRadians) * arcRadius
                let ballY = arcCenterY + sin(ballRadians) * arcRadius

                let ballColor = isInTune ? inTuneColor : accentColor

                // Draw glow
                let glowPath = Path(ellipseIn: CGRect(x: ballX - 12, y: ballY - 12, width: 24, height: 24))
                context.fill(glowPath, with: .color(ballColor.opacity(0.3)))

                // Draw ball
                let ballPath = Path(ellipseIn: CGRect(x: ballX - 8, y: ballY - 8, width: 16, height: 16))
                context.fill(ballPath, with: .color(ballColor))
            }
        }
    }
}

#Preview {
    let state = TunerState()
    state.frequency = 294.0
    state.noteName = "D"
    state.octave = 4
    state.cents = -25
    state.amplitude = 0.5

    return ArcTunerView()
        .environment(state)
        .frame(width: 320, height: 240)
}
