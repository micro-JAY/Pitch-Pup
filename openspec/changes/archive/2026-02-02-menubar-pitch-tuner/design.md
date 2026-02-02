## Context

PitchPup is a new macOS 14+ menubar utility for real-time pitch detection. The app starts as a fresh SwiftUI template with basic `WindowGroup` scaffolding. We need to transform it into a menubar-resident app with audio processing capabilities.

The target users are musicians tuning instruments, vocalists practicing pitch, and anyone curious about sound frequencies. The app must be lightweight, always accessible, and non-intrusive.

## Goals / Non-Goals

**Goals:**
- Provide instant pitch detection from the menubar with minimal friction
- Support two visualization modes for different use cases (quick glance vs detailed analysis)
- Allow selection of audio input device for flexibility (built-in mic, audio interface, etc.)
- Keep the app lightweight and battery-efficient when not actively analyzing

**Non-Goals:**
- Recording or saving audio (this is real-time analysis only)
- MIDI output or integration with DAWs
- Multiple simultaneous note detection (polyphonic analysis)
- Custom tuning systems beyond standard A=440Hz reference (v1)

## Decisions

### Decision 1: Use AudioKit for Pitch Detection

**Choice:** Integrate AudioKit's `PitchTap` for frequency detection rather than implementing raw FFT/autocorrelation.

**Rationale:**
- AudioKit provides battle-tested pitch detection optimized for musical applications
- `PitchTap` exposes frequency and amplitude with minimal setup
- Handles edge cases (noise floor, octave errors) that raw implementations struggle with
- Active community and macOS-native Swift support

**Alternatives Considered:**
- Raw AVAudioEngine + vDSP FFT: More control but significantly more work, easy to get wrong
- Accelerate framework autocorrelation: Lower-level, would need to handle all edge cases manually

### Decision 2: Use SwiftUI MenuBarExtra with .window Style

**Choice:** Use `MenuBarExtra` with `.menuBarExtraStyle(.window)` for the popover interface.

**Rationale:**
- Native macOS 13+ API, fully supported in macOS 14
- `.window` style gives us a proper view hierarchy (not menu items)
- Handles popover positioning, dismissal, and keyboard shortcuts automatically
- SwiftUI views work directly inside the window

**Alternatives Considered:**
- AppKit NSStatusItem + NSPopover: More flexible but requires bridging, more boilerplate
- Custom NSWindow: Overkill for this use case, harder to get positioning right

### Decision 3: State Management with @Observable

**Choice:** Use Swift 5.9 `@Observable` macro for shared state (macOS 14+).

**Rationale:**
- Cleaner than `ObservableObject` + `@Published`
- Native Swift concurrency integration
- Simpler dependency injection via environment

**Architecture:**
```
┌─────────────────────────────────────────────────────────┐
│                    PitchPupApp                          │
│  ┌─────────────────────────────────────────────────┐   │
│  │              MenuBarExtra (.window)              │   │
│  │  ┌─────────────────────────────────────────┐    │   │
│  │  │            TunerView                     │    │   │
│  │  │  ┌─────────┐  ┌──────────────────────┐  │    │   │
│  │  │  │ Controls │  │ Visualization        │  │    │   │
│  │  │  │ - On/Off │  │ (Arc or Waveform)    │  │    │   │
│  │  │  │ - Input  │  │                      │  │    │   │
│  │  │  │ - Hover  │  │ Right-click toggles  │  │    │   │
│  │  │  └─────────┘  └──────────────────────┘  │    │   │
│  │  └─────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────┐
│                   AudioEngine                           │
│  ┌──────────────┐    ┌──────────────┐                  │
│  │ AVAudioEngine │───▶│  PitchTap    │                  │
│  │   inputNode   │    │ (AudioKit)   │                  │
│  └──────────────┘    └──────┬───────┘                  │
│                             │                          │
│                    frequency, amplitude                │
│                             ▼                          │
│                   ┌─────────────────┐                  │
│                   │   TunerState    │                  │
│                   │  @Observable    │                  │
│                   └─────────────────┘                  │
└─────────────────────────────────────────────────────────┘
```

### Decision 4: Visualization Toggle via Right-Click Gesture

**Choice:** Use `.contextMenu` or `onTapGesture` with right-click detection to toggle views.

**Rationale:**
- Non-intrusive—doesn't add UI chrome
- Discoverable through standard macOS conventions
- Keeps the visualization area clean

### Decision 5: Hover Mode via NSPanel

**Choice:** When hover mode is enabled, present content in a floating `NSPanel` with `.nonactivatingPanel` behavior instead of the MenuBarExtra popover.

**Rationale:**
- MenuBarExtra's built-in popover dismisses on focus loss (by design)
- NSPanel with proper style mask can float above other windows
- Can still be closed manually or via menubar icon

**Implementation:**
- Default: Standard MenuBarExtra behavior (dismisses on click-out)
- Hover mode ON: Detach to floating NSPanel, MenuBarExtra becomes toggle

## Risks / Trade-offs

**Risk: AudioKit adds dependency weight**
→ Mitigation: AudioKit is modular; we only need `AudioKit` core, not `AudioKitUI` or other packages. Total added size is reasonable (~2-3MB).

**Risk: Microphone permission UX**
→ Mitigation: Request permission on first "start" action, not app launch. Show clear explanation. Handle denial gracefully with instructions.

**Risk: MenuBarExtra popover size constraints**
→ Mitigation: Design visualizations to work well at fixed compact size (~280x200 for arc, ~320x240 for waveform). Test on various display sizes.

**Risk: CPU usage during continuous analysis**
→ Mitigation: Use reasonable buffer sizes (1024-2048 samples), stop analysis when app is off or popover hidden. AudioKit's PitchTap is already optimized.

**Risk: Hover mode complexity with NSPanel**
→ Mitigation: Keep as optional feature. Default behavior uses standard MenuBarExtra. Hover mode is additive.

## Open Questions

1. **Waveform history length**: How many seconds of waveform to display? (Suggest: 2-3 seconds rolling)
2. **Note detection smoothing**: How aggressive should smoothing be to prevent jitter? (Suggest: 50-100ms window)
3. **Reference pitch setting**: Should we support adjustable A4 reference in v1? (Images show 440 Hz reference UI)
