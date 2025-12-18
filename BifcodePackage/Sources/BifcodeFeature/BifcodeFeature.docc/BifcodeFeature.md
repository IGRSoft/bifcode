# ``BifcodeFeature``

A macOS application framework for generating beautiful code comparison images with customizable "Do's" and "Don'ts" indicators.

## Overview

BifcodeFeature provides a complete code comparison image generator for macOS. It enables developers to create side-by-side or stacked code panels with syntax highlighting, customizable indicators, and professional export capabilities.

### Key Features

- **Syntax Highlighting**: Support for 19+ programming languages via CodeEditSourceEditor
- **Multiple Themes**: 7 professional editor themes including Atom One Dark, Dracula, and Monokai
- **Flexible Layouts**: Horizontal (side-by-side) or vertical (stacked) panel arrangements
- **Customizable Indicators**: Icons, labels, positions, and sizes for Do/Don't badges
- **High-Quality Export**: 2x Retina PNG export with proper shadow rendering
- **Persistent Settings**: All user preferences automatically saved via `@AppStorage`

### Architecture

The framework follows MVVM architecture with Swift 6 strict concurrency:

```
┌─────────────────────────────────────────────────┐
│                  ContentView                     │
│  ┌─────────────────┐  ┌─────────────────────┐  │
│  │   ToolBarView   │  │    PanelsView       │  │
│  └─────────────────┘  │  ┌───────────────┐  │  │
│                       │  │ CodeEditorView│  │  │
│                       │  └───────────────┘  │  │
│                       └─────────────────────┘  │
└─────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────┐
│              AppViewModel                        │
│  ┌────────────┐    ┌────────────┐              │
│  │  doPanel   │    │ dontPanel  │              │
│  │ (CodePanel)│    │ (CodePanel)│              │
│  └────────────┘    └────────────┘              │
└─────────────────────────────────────────────────┘
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:Architecture>
- ``ContentView``

### View Models

- ``AppViewModel``
- ``CodePanel``
- ``PanelType``

### Views

- ``CodeEditorView``
- ``ToolBarView``
- ``IndicatorBadgeView``

### Settings and Configuration

- ``IndicatorPosition``
- ``IndicatorStyle``
- ``IndicatorIcon``
- ``WindowLayout``
- ``EditorThemeOption``

### Export

- ``ExportError``

### Services

- ``BookmarkManager``

### Extensions

- ``Swift/Color``
