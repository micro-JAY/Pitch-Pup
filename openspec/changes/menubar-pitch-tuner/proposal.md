## Why

**Target: macOS 14 (Sonoma) and above**

Musicians, vocalists, and sound enthusiasts need quick access to a pitch analyzer without launching a full DAW or dedicated app. A lightweight menubar utility provides instant access for tuning instruments, checking vocal pitch while practicing along to music, or analyzing any sound's frequency—all without disrupting workflow.

## What Changes

- Transform the app from a standard window application to a menubar-resident utility
- Add real-time audio input capture and pitch detection using macOS audio APIs
- Implement two switchable visualization modes:
  - **Arc view**: Minimal display showing pitch deviation arc, note name, and frequency
  - **Waveform view**: Detailed scrolling waveform with note ladder and additional controls
- Add audio input device selection
- Add "hover mode" toggle (stay on top vs. dismiss on click-out)
- Add on/off switch to start/stop audio analysis

## Capabilities

### New Capabilities

- `menubar-host`: Menubar icon and popover presentation, left-click to show/hide tuner interface
- `audio-capture`: Real-time audio input from selectable system audio devices with start/stop control
- `pitch-detection`: Analyze audio stream to detect fundamental frequency and map to musical notes
- `arc-visualization`: Minimal tuner view with curved deviation arc (-50 to +50 cents), ball indicator, note name, and Hz display
- `waveform-visualization`: Detailed view with scrolling waveform, frequency display, note ladder, Auto/Hz toggle, and reference pitch setting
- `view-switcher`: Right-click on visualization to toggle between arc and waveform views
- `hover-mode`: Toggle to keep popover floating above other windows or dismiss on focus loss

### Modified Capabilities

<!-- None - this is a new application -->

## Impact

- **PitchPupApp.swift**: Replace WindowGroup with menubar-based app lifecycle (MenuBarExtra)
- **ContentView.swift**: Replace placeholder with tuner interface hosting both visualization modes
- **New files needed**: Audio engine, pitch detection algorithm, visualization views, preferences/state management
- **Info.plist**: Configure as agent app (LSUIElement) to hide dock icon
- **Entitlements**: Request microphone access permission
