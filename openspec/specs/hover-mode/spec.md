## ADDED Requirements

### Requirement: User can enable hover mode

The tuner interface SHALL provide a toggle to enable "hover mode" which keeps the tuner visible above other windows.

#### Scenario: Enabling hover mode

- **WHEN** the user enables hover mode via the toggle
- **THEN** the tuner window stays visible even when focus moves to other applications
- **AND** the tuner floats above other windows

### Requirement: Hover mode window is draggable

When hover mode is enabled, the tuner window SHALL be repositionable on screen.

#### Scenario: Dragging hover window

- **WHEN** hover mode is enabled
- **AND** the user drags the window
- **THEN** the window moves to the new position
- **AND** the position is remembered for future hover mode sessions

### Requirement: Hover mode can be disabled

The user SHALL be able to disable hover mode to return to standard popover behavior.

#### Scenario: Disabling hover mode

- **WHEN** hover mode is enabled
- **AND** the user disables hover mode via the toggle
- **THEN** the floating window closes
- **AND** the tuner returns to standard menubar popover behavior

### Requirement: Hover mode preference persists

The hover mode setting SHALL persist across app restarts.

#### Scenario: Persistence across restart

- **WHEN** hover mode is enabled
- **AND** the user quits and relaunches the app
- **THEN** hover mode remains enabled
- **AND** the tuner opens in hover mode on next launch

### Requirement: Close button in hover mode

When in hover mode, the window SHALL provide a way to close it without disabling hover mode.

#### Scenario: Closing hover window

- **WHEN** hover mode is enabled
- **AND** the user clicks the close button or presses Escape
- **THEN** the hover window closes
- **AND** hover mode remains enabled for next time
- **AND** the menubar icon can be clicked to reopen the hover window
