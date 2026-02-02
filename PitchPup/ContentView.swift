//
//  ContentView.swift
//  PitchPup
//

import SwiftUI

struct ContentView: View {
    @Environment(TunerState.self) private var tunerState
    var isHoverWindow: Bool = false

    var body: some View {
        Group {
            if tunerState.microphonePermissionDenied {
                PermissionDeniedView()
                    .frame(width: 320, height: 240)
            } else if tunerState.hoverModeEnabled && !isHoverWindow {
                // Show placeholder when hover mode is on (popover context)
                HoverModeActiveView()
            } else {
                TunerView()
            }
        }
    }
}

// Shown in popover when hover window is active
struct HoverModeActiveView: View {
    @Environment(TunerState.self) private var tunerState
    private let backgroundColor = Color(red: 0.08, green: 0.08, blue: 0.1)
    private let controlColor = Color(red: 0.4, green: 0.9, blue: 0.7)

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "pin.fill")
                .font(.system(size: 32))
                .foregroundColor(controlColor)

            Text("Tuner is floating")
                .font(.headline)
                .foregroundColor(.white)

            Text("Click the pin button in the floating window to return here.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Disable Hover Mode") {
                tunerState.hoverModeEnabled = false
            }
            .buttonStyle(.borderedProminent)
            .tint(controlColor)
        }
        .frame(width: 280, height: 180)
        .background(backgroundColor)
    }
}

#Preview {
    ContentView()
        .environment(TunerState())
}
