# Architecture Overview

Understand the design patterns and structure of BifcodeFeature.

## Overview

BifcodeFeature follows the Model-View-ViewModel (MVVM) architecture with Swift 6 strict concurrency throughout. This document explains the key architectural decisions and component relationships.

### Design Principles

1. **Strict Concurrency**: All shared types conform to `Sendable`
2. **Main Actor Isolation**: UI-related code is isolated to `@MainActor`
3. **Observable Pattern**: State management uses `@Observable` (not `ObservableObject`)
4. **Persistence via @AppStorage**: User preferences automatically sync to UserDefaults

### Component Hierarchy

```
BifcodeApp (@main)
    └── ContentView
        ├── ToolBarView
        │   ├── Language Picker
        │   ├── Theme Picker
        │   ├── Layout Toggle
        │   ├── Indicator Settings
        │   └── Export Button
        └── Panels
            ├── CodeEditorView (Don't)
            │   ├── Title Bar
            │   ├── SourceEditor
            │   └── IndicatorBadgeView
            └── CodeEditorView (Do)
                ├── Title Bar
                ├── SourceEditor
                └── IndicatorBadgeView
```

### State Management

#### AppViewModel

The central state container managing code panels and export functionality:

```swift
@MainActor
@Observable
public final class AppViewModel {
    public let doPanel: CodePanel
    public let dontPanel: CodePanel

    public var saveLocation: URL { ... }
    public func saveImage(_ image: NSImage) async throws
}
```

#### CodePanel

Observable model representing a single code editor:

```swift
@MainActor
@Observable
public final class CodePanel: Identifiable {
    public let type: PanelType
    public var code: String
    public var title: String
    public var language: CodeLanguage
    public var editorState: SourceEditorState
}
```

### Settings Architecture

User preferences are stored via `@AppStorage` directly in views, enabling:

- Automatic persistence to UserDefaults
- Immediate UI updates when settings change
- No manual state synchronization required

| Setting Category | Storage Keys |
|-----------------|--------------|
| Code Style | `selectedLanguage`, `selectedTheme`, `fontSize`, `windowLayout` |
| Panel Titles | `doTitle`, `dontTitle`, `showTitle` |
| Indicators | `indicatorStyle`, `indicatorPosition`, `indicatorSize`, `doIndicatorIcon`, `dontIndicatorIcon`, `doIndicatorLabel`, `dontIndicatorLabel` |

### Export Pipeline

The export system uses offscreen window rendering (not `ImageRenderer`) because `ImageRenderer` cannot render `NSViewRepresentable` views like `SourceEditor`.

```
User taps Export
        │
        ▼
Calculate dimensions from content
        │
        ▼
Create ExportView with settings
        │
        ▼
Wrap in NSHostingView
        │
        ▼
Create offscreen NSWindow
        │
        ▼
Wait for SourceEditor to render
        │
        ▼
Capture via bitmapImageRepForCachingDisplay
        │
        ▼
Scale to 2x for Retina
        │
        ▼
Save as PNG via BookmarkManager
```

### Security-Scoped Bookmarks

To persist folder access across app launches in a sandboxed environment:

```swift
@MainActor
public final class BookmarkManager: Sendable {
    public static let shared = BookmarkManager()

    public func storeBookmark(for url: URL) throws
    public func resolveBookmark() -> URL?
    public func clearBookmark()
}
```

**Workflow:**
1. User selects folder via `NSOpenPanel`
2. `BookmarkManager.storeBookmark(for:)` creates security-scoped bookmark
3. On export, `resolveBookmark()` retrieves the URL
4. `startAccessingSecurityScopedResource()` before file I/O
5. `stopAccessingSecurityScopedResource()` after file I/O

### Color System

All colors use semantic naming via `Color+Semantic.swift`:

| Category | Examples |
|----------|----------|
| Indicators | `indicatorDo`, `indicatorDont` |
| Editor | `editorBackground`, `editorText`, `editorGutter` |
| Window | `windowBackground`, `titleBarBackground`, `windowBorder` |
| UI | `toolbarBackground`, `contentBackground`, `secondaryText` |

Colors are defined in `Resources/Colors.xcassets` with light/dark mode variants.

### Theme System

Editor themes extend `EditorTheme` with predefined presets:

- Atom One Dark
- Dracula
- GitHub Dark
- Monokai
- Nord
- Solarized Dark
- Xcode Default

Each theme defines colors for text, keywords, strings, comments, and other syntax elements.

## See Also

- <doc:GettingStarted>
- ``AppViewModel``
- ``BookmarkManager``
- ``EditorThemeOption``
