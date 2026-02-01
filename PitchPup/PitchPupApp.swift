//
//  PitchPupApp.swift
//  PitchPup
//

import SwiftUI

@main
struct PitchPupApp: App {
    @State private var tunerState = TunerState()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(tunerState)
        } label: {
            Image(systemName: tunerState.isOn ? "tuningfork" : "tuningfork")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(tunerState.isOn ? .green : .secondary)
        }
        .menuBarExtraStyle(.window)
    }
}
