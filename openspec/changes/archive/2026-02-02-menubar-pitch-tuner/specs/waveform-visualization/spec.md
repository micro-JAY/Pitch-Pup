## ADDED Requirements

### Requirement: Display scrolling waveform

The waveform view SHALL display a horizontally scrolling waveform visualization of the audio input.

#### Scenario: Waveform animation

- **WHEN** audio capture is active
- **THEN** the waveform scrolls from right to left
- **AND** new audio data appears on the right side
- **AND** the waveform shows approximately 2-3 seconds of history

### Requirement: Display frequency readout

The waveform view SHALL display the current detected frequency in Hz.

#### Scenario: Frequency display in waveform view

- **WHEN** a pitch is detected
- **THEN** the frequency is displayed (e.g., "294.4 Hz") within the visualization area

### Requirement: Display note ladder

The waveform view SHALL display a vertical note ladder on the right side showing nearby notes.

#### Scenario: Note ladder display

- **WHEN** a pitch is detected (e.g., D4)
- **THEN** the note ladder shows the detected note highlighted (D)
- **AND** adjacent notes are visible above and below (D#, C#)
- **AND** the ladder indicates which note is currently closest

### Requirement: Provide Auto/Hz display toggle

The waveform view SHALL provide a toggle to switch between automatic note detection and fixed Hz display mode.

#### Scenario: Auto mode

- **WHEN** Auto mode is selected
- **THEN** the note ladder follows the detected pitch automatically
- **AND** the display centers on the current note

#### Scenario: Hz mode

- **WHEN** Hz mode is selected
- **THEN** the display shows raw frequency without note snapping
- **AND** the note ladder may be hidden or show a frequency scale

### Requirement: Display reference pitch indicator

The waveform view SHALL display the current reference pitch setting (e.g., "Reference 440 Hz").

#### Scenario: Reference pitch display

- **WHEN** the waveform view is displayed
- **THEN** the reference pitch is shown (e.g., "Reference 440 Hz")

### Requirement: Dark background with accent colors

The waveform view SHALL use a dark background with green waveform and gold/yellow accent for the note ladder highlight.

#### Scenario: Visual styling

- **WHEN** the waveform view is displayed
- **THEN** the background is dark
- **AND** the waveform line is green/teal
- **AND** the currently detected note in the ladder is highlighted in gold/yellow
