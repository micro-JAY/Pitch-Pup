//
//  PitchPupApp.swift
//  PitchPup
//

import SwiftUI

@main
struct PitchPupApp: App {
    @State private var tunerState: TunerState

    init() {
        let state = TunerState()
        state.loadPreferences()
        _tunerState = State(initialValue: state)
    }

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environment(tunerState)
                .onDisappear {
                    tunerState.savePreferences()
                }
        } label: {
            Image(systemName: tunerState.isOn ? "tuningfork" : "tuningfork")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(tunerState.isOn ? .green : .secondary)
        }
        .menuBarExtraStyle(.window)
    }
}
