//
//  AppDelegate.swift
//  PitchPup
//

import AppKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var hoverWindowController: HoverWindowController?
    weak var tunerState: TunerState?

    func showHoverWindow() {
        guard let tunerState else { return }

        if hoverWindowController == nil {
            hoverWindowController = HoverWindowController(tunerState: tunerState)
        }
        hoverWindowController?.show()
    }

    func hideHoverWindow() {
        hoverWindowController?.hide()
    }
}
