# PitchPup

A lightweight macOS menubar pitch tuner for musicians. Real-time pitch detection with visual feedback — always one click away.

## What It Does

PitchPup lives in your menubar and listens to your microphone to detect the pitch of whatever you're playing or singing. It shows you the detected note, how many cents sharp or flat you are, and gives you a visual indicator to help you dial it in.

No need to launch a DAW or open a separate app — just click the tuning fork icon and start tuning.

## Features

- **Menubar-resident** — click the tuning fork icon to open
- **Real-time pitch detection** via AudioKit's PitchTap (A4 = 440 Hz reference)
- **Two visualization modes:**
  - **Arc view** — semicircular gauge showing cents deviation (-50 to +50) with an animated ball indicator
  - **Waveform view** — scrolling waveform display with a note ladder
- **Hover mode** — pin the tuner as a floating window that stays above all other apps
- **In-tune indicator** — visual feedback when you're within ±5 cents
- **Silent operation** — analyzes audio without playing anything back through speakers

## Requirements

- macOS 14+ (Sonoma)
- Microphone access permission

## Dependencies

- [AudioKit](https://github.com/AudioKit/AudioKit) — audio engine and pitch detection
- AudioKitEX — Fader for silent output routing
- SoundpipeAudioKit — PitchTap for frequency analysis

## Project Structure

```
PitchPup/
├── PitchPupApp.swift          # App entry, MenuBarExtra setup
├── AppDelegate.swift          # Manages hover window lifecycle
├── ContentView.swift          # Routes to tuner or hover-mode placeholder
├── TunerState.swift           # Shared observable state
├── AudioEngine.swift          # AudioKit pitch detection engine
├── PitchProcessor.swift       # Frequency → note name/octave/cents conversion
├── Persistence.swift          # UserDefaults preferences
├── HoverWindow.swift          # NSPanel for always-on-top floating mode
└── Views/
    ├── TunerView.swift        # Main tuner interface with controls
    ├── ArcTunerView.swift     # Arc/gauge visualization
    └── WaveformTunerView.swift # Waveform + note ladder visualization
```
