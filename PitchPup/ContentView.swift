//
//  ContentView.swift
//  PitchPup
//

import SwiftUI

struct ContentView: View {
    @Environment(TunerState.self) private var tunerState

    var body: some View {
        Group {
            if tunerState.microphonePermissionDenied {
                PermissionDeniedView()
                    .frame(width: 320, height: 240)
            } else {
                TunerView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(TunerState())
}
