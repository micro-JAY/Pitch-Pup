## ADDED Requirements

### Requirement: Right-click toggles visualization mode

The user SHALL be able to switch between arc view and waveform view by right-clicking on the visualization area.

#### Scenario: Switch from arc to waveform

- **WHEN** the arc view is displayed
- **AND** the user right-clicks on the visualization
- **THEN** the view switches to waveform visualization

#### Scenario: Switch from waveform to arc

- **WHEN** the waveform view is displayed
- **AND** the user right-clicks on the visualization
- **THEN** the view switches to arc visualization

### Requirement: View preference persists

The selected visualization mode SHALL persist across app restarts.

#### Scenario: Persistence across restart

- **WHEN** the user selects waveform view
- **AND** the user quits and relaunches the app
- **THEN** the waveform view is displayed by default

### Requirement: Smooth transition between views

The view switch SHALL animate smoothly rather than abruptly replacing content.

#### Scenario: Animated transition

- **WHEN** the user right-clicks to switch views
- **THEN** the transition animates (fade, slide, or crossfade)
- **AND** the transition completes quickly (under 300ms)
