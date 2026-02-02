## ADDED Requirements

### Requirement: User can start and stop audio capture

The tuner interface SHALL provide an on/off control to start and stop audio analysis.

#### Scenario: Starting audio capture

- **WHEN** the user toggles the on/off switch to ON
- **THEN** the app begins capturing audio from the selected input device
- **AND** pitch detection begins processing the audio stream

#### Scenario: Stopping audio capture

- **WHEN** the user toggles the on/off switch to OFF
- **THEN** the app stops capturing audio
- **AND** pitch detection stops
- **AND** the visualization shows no pitch data

### Requirement: User can select audio input device

The tuner interface SHALL allow the user to select which audio input device to use.

#### Scenario: Viewing available input devices

- **WHEN** the user opens the input device selector
- **THEN** a list of available audio input devices is displayed
- **AND** the currently selected device is indicated

#### Scenario: Changing input device

- **WHEN** the user selects a different input device
- **THEN** audio capture switches to the newly selected device
- **AND** the device selection persists across app restarts

### Requirement: App requests microphone permission

The app SHALL request microphone access permission before capturing audio.

#### Scenario: First-time permission request

- **WHEN** the user attempts to start audio capture for the first time
- **AND** microphone permission has not been granted
- **THEN** the system displays a microphone permission dialog

#### Scenario: Permission denied handling

- **WHEN** the user has denied microphone permission
- **AND** the user attempts to start audio capture
- **THEN** the app displays a message explaining that microphone access is required
- **AND** provides guidance to enable it in System Settings

### Requirement: Audio capture stops when popover is hidden

To conserve resources, audio capture SHALL pause when the tuner is not visible (unless hover mode is enabled).

#### Scenario: Popover closes while capturing

- **WHEN** audio capture is active
- **AND** the popover closes (hover mode OFF)
- **THEN** audio capture pauses

#### Scenario: Popover reopens after pausing

- **WHEN** audio capture was paused due to popover closing
- **AND** the user opens the popover again
- **THEN** audio capture resumes automatically
