## ADDED Requirements

### Requirement: Detect fundamental frequency from audio

The app SHALL analyze the audio input stream and detect the fundamental frequency (pitch) in real-time.

#### Scenario: Detecting a clear pitch

- **WHEN** audio capture is active
- **AND** the input contains a clear tonal sound (instrument, voice)
- **THEN** the detected frequency is displayed in Hz
- **AND** the display updates in real-time as the pitch changes

#### Scenario: No pitch detected

- **WHEN** audio capture is active
- **AND** the input contains no clear pitch (silence, noise, or percussive sounds)
- **THEN** the visualization indicates no pitch is detected

### Requirement: Map frequency to musical note

The app SHALL map the detected frequency to the nearest musical note in twelve-tone equal temperament.

#### Scenario: Displaying detected note

- **WHEN** a frequency is detected
- **THEN** the corresponding note name is displayed (e.g., "A", "C#", "Bb")
- **AND** the octave number is available (e.g., "A4" = 440 Hz)

### Requirement: Calculate cents deviation from note

The app SHALL calculate how many cents sharp or flat the detected pitch is from the nearest note.

#### Scenario: Pitch is sharp

- **WHEN** the detected frequency is higher than the nearest note
- **THEN** the deviation is displayed as a positive cents value (e.g., +15)

#### Scenario: Pitch is flat

- **WHEN** the detected frequency is lower than the nearest note
- **THEN** the deviation is displayed as a negative cents value (e.g., -23)

#### Scenario: Pitch is in tune

- **WHEN** the detected frequency is within ±5 cents of the nearest note
- **THEN** the visualization indicates the pitch is "in tune"

### Requirement: Use A4 = 440 Hz as reference

The app SHALL use A4 = 440 Hz as the standard reference pitch for note calculations.

#### Scenario: A4 reference frequency

- **WHEN** the detected frequency is 440 Hz
- **THEN** the note is displayed as "A" (or "A4")
- **AND** the cents deviation is 0

### Requirement: Smooth pitch display to reduce jitter

The app SHALL apply smoothing to the pitch display to prevent rapid fluctuations from minor variations.

#### Scenario: Stable display during sustained note

- **WHEN** a musician holds a relatively steady note
- **AND** minor pitch variations occur (natural vibrato, slight drift)
- **THEN** the displayed note remains stable
- **AND** the cents indicator shows smoothed movement rather than erratic jumping
