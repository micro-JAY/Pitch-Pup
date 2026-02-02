//
//  PitchPupApp.swift
//  PitchPup
//

import SwiftUI

@main
struct PitchPupApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
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
                .onAppear {
                    // Wire up the app delegate with tuner state
                    appDelegate.tunerState = tunerState
                }
                .onDisappear {
                    tunerState.savePreferences()
                }
                .onChange(of: tunerState.hoverModeEnabled) { _, enabled in
                    if enabled {
                        appDelegate.showHoverWindow()
                    } else {
                        appDelegate.hideHoverWindow()
                    }
                }
        } label: {
            Image(systemName: tunerState.isOn ? "tuningfork" : "tuningfork")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(tunerState.isOn ? .green : .secondary)
        }
        .menuBarExtraStyle(.window)
    }
}
