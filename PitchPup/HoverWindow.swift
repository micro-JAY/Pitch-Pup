//
//  HoverWindow.swift
//  PitchPup
//

import SwiftUI
import AppKit

class HoverPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .nonactivatingPanel, .utilityWindow],
            backing: .buffered,
            defer: false
        )

        // Configure as floating panel
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isMovableByWindowBackground = true
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        backgroundColor = NSColor(red: 0.08, green: 0.08, blue: 0.1, alpha: 1.0)

        // Make it non-activating so it doesn't steal focus
        hidesOnDeactivate = false
    }

    override func keyDown(with event: NSEvent) {
        // Close on Escape
        if event.keyCode == 53 { // Escape key
            close()
        } else {
            super.keyDown(with: event)
        }
    }
}

@MainActor
class HoverWindowController: NSWindowController {
    private var tunerState: TunerState?
    private var savedPosition: NSPoint?
    private var isClosingProgrammatically = false

    convenience init(tunerState: TunerState) {
        let panel = HoverPanel(contentRect: NSRect(x: 0, y: 0, width: 320, height: 260))
        self.init(window: panel)
        self.tunerState = tunerState

        // Restore saved position or center
        if let savedX = UserDefaults.standard.object(forKey: "hoverWindowX") as? CGFloat,
           let savedY = UserDefaults.standard.object(forKey: "hoverWindowY") as? CGFloat {
            panel.setFrameOrigin(NSPoint(x: savedX, y: savedY))
        } else {
            panel.center()
        }

        // Set up SwiftUI content (mark as hover window so it shows full tuner)
        let contentView = ContentView(isHoverWindow: true)
            .environment(tunerState)

        panel.contentView = NSHostingView(rootView: contentView)

        // Observe window movement to save position
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidMove),
            name: NSWindow.didMoveNotification,
            object: panel
        )

        // Observe close to update state
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowWillClose),
            name: NSWindow.willCloseNotification,
            object: panel
        )
    }

    @objc private func windowDidMove(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        UserDefaults.standard.set(window.frame.origin.x, forKey: "hoverWindowX")
        UserDefaults.standard.set(window.frame.origin.y, forKey: "hoverWindowY")
    }

    @objc private func windowWillClose(_ notification: Notification) {
        // Only update state if user closed the window manually (not programmatically)
        if !isClosingProgrammatically {
            tunerState?.hoverModeEnabled = false
        }
        isClosingProgrammatically = false
    }

    func show() {
        window?.makeKeyAndOrderFront(nil)
    }

    func hide() {
        isClosingProgrammatically = true
        window?.close()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
