//
//  Persistence.swift
//  PitchPup
//

import Foundation

enum UserDefaultsKeys {
    static let selectedDeviceID = "selectedAudioDeviceID"
    static let viewMode = "visualizationMode"
    static let hoverModeEnabled = "hoverModeEnabled"
    static let hoverWindowX = "hoverWindowX"
    static let hoverWindowY = "hoverWindowY"
}

extension TunerState {
    func loadPreferences() {
        // Load selected device
        if let deviceID = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedDeviceID) {
            selectedDeviceID = deviceID
        }

        // Load view mode
        if let modeString = UserDefaults.standard.string(forKey: UserDefaultsKeys.viewMode),
           let mode = VisualizationMode(rawValue: modeString) {
            viewMode = mode
        }

        // Load hover mode
        hoverModeEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hoverModeEnabled)
    }

    func savePreferences() {
        // Save selected device
        if let deviceID = selectedDeviceID {
            UserDefaults.standard.set(deviceID, forKey: UserDefaultsKeys.selectedDeviceID)
        }

        // Save view mode
        UserDefaults.standard.set(viewMode.rawValue, forKey: UserDefaultsKeys.viewMode)

        // Save hover mode
        UserDefaults.standard.set(hoverModeEnabled, forKey: UserDefaultsKeys.hoverModeEnabled)
    }
}
