# Getting Started with BifcodeFeature

Learn how to use BifcodeFeature to create professional code comparison images.

## Overview

BifcodeFeature is a SwiftUI-based framework for macOS that generates beautiful code comparison images. This guide walks you through the basic usage and customization options.

### Prerequisites

- macOS 15.0+ (Sequoia)
- Xcode 16.0+
- Swift 6.0+

### Basic Usage

The simplest way to use BifcodeFeature is to present `ContentView` in your app:

```swift
import SwiftUI
import BifcodeFeature

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
    }
}
```

### The User Interface

The main interface consists of three sections:

1. **Toolbar** - Configure code style, indicators, and export
2. **Don't Panel** - The "Don't" code example (left/top)
3. **Do Panel** - The "Do" code example (right/bottom)

### Code Style Settings

| Setting | Description | Range |
|---------|-------------|-------|
| Language | Programming language for syntax highlighting | 19 languages |
| Theme | Color scheme for the editor | 7 themes |
| Layout | Panel arrangement | Horizontal/Vertical |
| Font Size | Code font size | 10-24pt |

### Indicator Settings

| Setting | Description | Range |
|---------|-------------|-------|
| Style | Icon only, text only, or both | 3 options |
| Position | Badge placement | Top-right/Bottom-right |
| Size | Badge size | 32-80px |
| Icons | SF Symbols for Do/Don't | 5 each |
| Labels | Custom text labels | 10 chars max |

### Export

Click the export button (upload icon) to save your comparison as a PNG image:

1. The image is exported at 2x resolution for Retina displays
2. Transparent background with drop shadows
3. Saved to Desktop by default, or your chosen folder
4. Filename format: `bifcode-[timestamp].png`

### Choosing a Save Location

To change where exports are saved:

1. Click "Choose" below the export button
2. Select your preferred folder
3. The app will remember this location across launches

> Note: The app uses security-scoped bookmarks to maintain folder access in sandboxed environments.

## See Also

- <doc:Architecture>
- ``ContentView``
- ``AppViewModel``
