## ADDED Requirements

### Requirement: Display pitch deviation arc

The arc view SHALL display a curved arc representing the pitch deviation range from -50 to +50 cents.

#### Scenario: Arc layout

- **WHEN** the arc view is displayed
- **THEN** a curved arc spans the width of the view
- **AND** the center (0) is marked at the top of the arc
- **AND** -50 is marked at the left end
- **AND** +50 is marked at the right end

### Requirement: Ball indicator shows current deviation

A circular ball indicator SHALL move along the arc to show the current cents deviation.

#### Scenario: Pitch is flat

- **WHEN** the detected pitch is 25 cents flat
- **THEN** the ball is positioned on the left side of the arc, between center and -50

#### Scenario: Pitch is in tune

- **WHEN** the detected pitch is within ±5 cents
- **THEN** the ball is positioned at or near the center of the arc
- **AND** the ball or surrounding area indicates "in tune" status (e.g., color change)

#### Scenario: Pitch is sharp

- **WHEN** the detected pitch is 25 cents sharp
- **THEN** the ball is positioned on the right side of the arc, between center and +50

### Requirement: Display note name prominently

The arc view SHALL display the detected note name in a large, readable font below the arc.

#### Scenario: Note display

- **WHEN** a pitch is detected
- **THEN** the note name (e.g., "D", "F#") is displayed prominently
- **AND** the note updates as the detected pitch changes

### Requirement: Display frequency in Hz

The arc view SHALL display the detected frequency in Hz alongside the note name.

#### Scenario: Frequency display

- **WHEN** a pitch is detected (e.g., 294.0 Hz)
- **THEN** the frequency is displayed as "294.0 Hz" near the note name

### Requirement: Dark background with accent color

The arc view SHALL use a dark background with a green/teal accent color for the arc and indicators.

#### Scenario: Visual styling

- **WHEN** the arc view is displayed
- **THEN** the background is dark (near black)
- **AND** the arc, ball, and text use a green/teal accent color
