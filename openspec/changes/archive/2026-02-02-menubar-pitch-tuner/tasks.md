## 1. Project Setup

- [x] 1.1 Add AudioKit package dependency via Swift Package Manager
- [x] 1.2 Configure Info.plist: set LSUIElement=YES to hide dock icon
- [x] 1.3 Add microphone usage description to Info.plist (NSMicrophoneUsageDescription)
- [x] 1.4 Add microphone entitlement to entitlements file

## 2. App Architecture

- [x] 2.1 Create TunerState @Observable class (isOn, selectedDevice, frequency, note, cents, hoverMode, viewMode)
- [x] 2.2 Convert PitchPupApp from WindowGroup to MenuBarExtra with .window style
- [x] 2.3 Create menubar icon assets (active and inactive states)

## 3. Audio Engine

- [x] 3.1 Create AudioEngine class wrapping AVAudioEngine and AudioKit PitchTap
- [x] 3.2 Implement start/stop audio capture methods
- [x] 3.3 Implement audio input device enumeration and selection
- [x] 3.4 Wire PitchTap output to TunerState (frequency, amplitude)
- [x] 3.5 Handle microphone permission request and denial states

## 4. Pitch Processing

- [x] 4.1 Create PitchProcessor utility: frequency → (note name, octave, cents deviation)
- [x] 4.2 Implement smoothing algorithm to reduce pitch display jitter
- [x] 4.3 Add "in tune" detection threshold (±5 cents)

## 5. Arc Visualization

- [x] 5.1 Create ArcTunerView with curved deviation arc (-50 to +50 cents)
- [x] 5.2 Add animated ball indicator that moves along the arc
- [x] 5.3 Display note name (large text) and frequency (Hz) below arc
- [x] 5.4 Implement "in tune" visual feedback (color change when centered)
- [x] 5.5 Apply dark theme with green/teal accent colors matching reference image

## 6. Waveform Visualization

- [x] 6.1 Create WaveformTunerView with scrolling waveform canvas
- [x] 6.2 Implement rolling waveform buffer (2-3 seconds history)
- [x] 6.3 Add frequency display overlay on waveform
- [x] 6.4 Create note ladder component (vertical list showing nearby notes)
- [x] 6.5 Add Auto/Hz toggle control
- [x] 6.6 Apply dark theme with green waveform and gold note highlight

## 7. Main Tuner Interface

- [x] 7.1 Create TunerView composing controls + visualization area
- [x] 7.2 Add on/off toggle switch for audio capture
- [x] 7.3 Add audio input device picker dropdown
- [x] 7.4 Add hover mode toggle
- [x] 7.5 Implement right-click gesture on visualization to toggle view mode
- [x] 7.6 Add smooth transition animation between arc and waveform views

## 8. Hover Mode

- [x] 8.1 Create HoverWindow (NSPanel subclass) for floating mode
- [x] 8.2 Implement logic to detach content to HoverWindow when hover mode enabled
- [x] 8.3 Make hover window draggable and remember position
- [x] 8.4 Add close button/Escape handler for hover window

## 9. Persistence

- [x] 9.1 Persist selected audio input device in UserDefaults
- [x] 9.2 Persist view mode preference (arc vs waveform)
- [x] 9.3 Persist hover mode preference
- [x] 9.4 Persist hover window position

## 10. Polish & Edge Cases

- [x] 10.1 Pause audio capture when popover closes (non-hover mode)
- [x] 10.2 Resume audio capture when popover reopens
- [x] 10.3 Handle audio device disconnection gracefully
- [x] 10.4 Show appropriate UI when no pitch detected (silence/noise)
- [x] 10.5 Update menubar icon to reflect active/inactive state

## 11. Bug Fixes (from testing)

- [x] 11.1 Fix audio input device selection not switching devices (added Core Audio device switching)
- [x] 11.2 Fix hover mode not keeping window above others (wired up AppDelegate + HoverWindowController)
- [x] 11.3 Add cents display below the arc visualization
- [x] 11.4 Add settings menu with view mode toggle and quit button
- [x] 11.5 Remove right-click context menu from visualization (moved to settings menu)

## 12. Bug Fixes Round 2 (from testing)

- [x] 12.1 Remove audio input device selector (use system default only)
- [x] 12.2 Fix hover mode toggle - disabling pin should close hover window
- [x] 12.3 Fix view mode switching - ensure seamless transition while running
- [x] 12.4 Change cent symbol from "¢" to "ct"
- [x] 12.5 Fix arc labels: -50ct and +50ct at arc tips, 0ct at top center peak
- [x] 12.6 Fix ball indicator to follow the arc path correctly
- [x] 12.7 Mute audio output (user hearing themselves through mic)

## 13. Bug Fixes Round 3 (from testing)

- [x] 13.1 Fix audio not being analyzed (use Fader with gain=0 after PitchTap, import AudioKitEX)
- [x] 13.2 Fix hover mode window duplication (show placeholder in popover when hover mode active)
- [x] 13.3 Remove "0" label from arc
- [x] 13.4 Rewrite arc using Canvas for precise positioning (ball + labels at arc tips)
- [x] 13.5 Center note/cents/Hz display vertically

## 14. Verification (Re-test after fixes)

- [x] 14.1 Test pitch detection with default microphone
- [x] 14.2 Verify pitch accuracy with tuning fork or known frequency
- [x] 14.3 Test hover mode toggle on/off works correctly (no duplication)
- [x] 14.4 Test view mode switching while tuner is active
- [x] 14.5 Verify arc indicator follows arc path correctly
- [x] 14.6 Confirm no audio playback through speakers
- [x] 14.7 Verify -50/+50 labels are at arc tips

> All verification tests passed.
