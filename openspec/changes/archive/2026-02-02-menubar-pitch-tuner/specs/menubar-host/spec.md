## ADDED Requirements

### Requirement: App presents as menubar utility

The app SHALL display an icon in the macOS menubar and SHALL NOT show a dock icon or standard application window.

#### Scenario: App launches into menubar

- **WHEN** the user launches PitchPup
- **THEN** a tuner icon appears in the menubar
- **AND** no dock icon is visible
- **AND** no application window opens automatically

### Requirement: Left-click opens tuner popover

The menubar icon SHALL open a popover window containing the tuner interface when left-clicked.

#### Scenario: Opening the tuner

- **WHEN** the user left-clicks the menubar icon
- **THEN** a popover window appears below the icon
- **AND** the tuner interface is displayed inside the popover

#### Scenario: Closing the tuner by clicking icon again

- **WHEN** the tuner popover is open
- **AND** the user left-clicks the menubar icon
- **THEN** the popover closes

### Requirement: Popover dismisses on focus loss by default

When hover mode is disabled, the popover SHALL close when the user clicks outside of it.

#### Scenario: Click outside closes popover

- **WHEN** the tuner popover is open
- **AND** hover mode is OFF
- **AND** the user clicks outside the popover
- **THEN** the popover closes

### Requirement: Menubar icon indicates active state

The menubar icon SHALL visually indicate whether pitch detection is currently active.

#### Scenario: Icon shows inactive state

- **WHEN** pitch detection is OFF
- **THEN** the menubar icon displays in a muted/inactive style

#### Scenario: Icon shows active state

- **WHEN** pitch detection is ON
- **THEN** the menubar icon displays in an active/highlighted style
