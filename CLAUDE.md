# Bifcode - Code Comparison Image Generator

## Overview

- **Type**: macOS application
- **Stack**: Swift 6.2, SwiftUI, HighlightSwift
- **Architecture**: MVVM with @Observable
- **Platform**: macOS 15.0+ only

This CLAUDE.md is the authoritative source for development guidelines.
Extends global configuration from `~/.claude/CLAUDE.md`.

---

## Universal Development Rules

### Code Quality (MUST)

- **MUST** use Swift 6.2 strict concurrency mode
- **MUST** use `@Observable` for view model state (not `ObservableObject`)
- **MUST** use `@MainActor` for all UI-related code
- **MUST** ensure all shared types conform to `Sendable`
- **MUST** run SwiftFormat before committing: `swiftformat .`
- **MUST** target macOS 15.0+ (Sequoia) minimum
- **MUST NOT** commit secrets, API keys, or credentials
- **MUST NOT** use hardcoded colors (see Color Usage below)

### Color Usage (CRITICAL)

**NEVER** use hardcoded colors like `.gray`, `.red`, `.green`, etc.

**ALWAYS** use semantic colors from `Sources/Extensions/Color+Semantic.swift`:

```swift
// WRONG
Text("Do's").foregroundColor(.green)
Rectangle().fill(.red)

// CORRECT
Text("Do's").foregroundColor(.indicatorDo)
Rectangle().fill(.indicatorDont)
```

**Semantic Colors to Define**:
- `Color.indicatorDo` - Green checkmark/Do indicator
- `Color.indicatorDont` - Red X/Don't indicator
- `Color.editorBackground` - Code editor background
- `Color.editorLineNumber` - Line number text
- `Color.editorText` - Default code text
- `Color.windowBackground` - Window background
- `Color.titleText` - Window title text

**Rationale**: Ensures consistent theming and future light/dark mode support.

### Best Practices (SHOULD)

- **SHOULD** use `@AppStorage` for user preferences persistence
- **SHOULD** prefer computed properties over stored state when possible
- **SHOULD** use DocC documentation (`///`) for public APIs
- **SHOULD** keep views lightweight, delegate logic to ViewModels

### Anti-Patterns (MUST NOT)

- **MUST NOT** use AppKit unless absolutely necessary for export
- **MUST NOT** suppress Swift warnings without documented justification
- **MUST NOT** use `any` keyword without explicit justification
- **MUST NOT** hardcode file paths (use FileManager APIs)

---

## Core Commands

### Development

```bash
# Build
xcodebuild -project Bifcode.xcodeproj -scheme Bifcode -configuration Debug build

# Run
open -a Bifcode

# Format code
swiftformat .

# Run tests
xcodebuild test -project Bifcode.xcodeproj -scheme Bifcode -destination 'platform=macOS'
```

### Quality Gates (run before PR)

```bash
swiftformat . && xcodebuild test -project Bifcode.xcodeproj -scheme Bifcode -destination 'platform=macOS'
```

---

## Project Structure

### Application

```
Sources/
├── App/
│   └── BifcodeApp.swift          # @main entry point
├── Views/
│   ├── ContentView.swift         # Main container
│   ├── CodeEditorView.swift      # Code editor with line numbers
│   ├── IndicatorBadgeView.swift  # Do/Don't indicator
│   ├── SettingsView.swift        # Preferences panel
│   └── ExportPreviewView.swift   # Export preview
├── ViewModels/
│   ├── EditorViewModel.swift     # Code editor state
│   └── SettingsViewModel.swift   # App settings state
├── Models/
│   ├── CodePanel.swift           # Do/Don't panel model
│   ├── IndicatorStyle.swift      # Indicator styling
│   └── ExportSettings.swift      # Export configuration
├── Services/
│   ├── ExportService.swift       # PNG generation
│   ├── LanguageDetector.swift    # Syntax language detection
│   └── SettingsService.swift     # Preferences persistence
└── Extensions/
    ├── Color+Semantic.swift      # Semantic colors
    ├── Font+Code.swift           # Code fonts
    └── View+Export.swift         # View to image conversion
```

### Resources

```
Resources/
├── Assets.xcassets/
│   ├── Colors/                   # Semantic color sets
│   ├── Icons/                    # App and indicator icons
│   └── AppIcon.iconset/          # App icon
└── Localizable.strings           # Localization (future)
```

### Testing

```
Tests/
├── ViewModelTests/               # ViewModel unit tests
├── ServiceTests/                 # Service unit tests
└── IntegrationTests/             # Export integration tests
```

---

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [HighlightSwift](https://github.com/appstefan/HighlightSwift) | 1.1+ | Syntax highlighting & language auto-detection |

### Adding HighlightSwift

In Xcode:
1. File → Add Package Dependencies
2. URL: `https://github.com/appstefan/highlightswift`
3. Version: 1.1+

---

## Feature Specifications

### Code Editor

- Line numbers (configurable visibility)
- Syntax highlighting via HighlightSwift `CodeText`
- Auto-detect language with manual override
- Monospace font (SF Mono or system monospace)
- Dark theme background

### Indicator Badge

- Position: top-right (default) or bottom-left
- Styles: icon-only, text-only, icon+text
- Do: Green checkmark with "Do's" label
- Don't: Red X with "Don'ts" label
- Configurable size

### Export

- PNG format, high-resolution
- Side-by-side or stacked layout
- Auto-size to content
- Watermark: bottom-center, configurable text
- Save location: Desktop (default), user-configurable

### Settings Persistence

Use `@AppStorage` for all user preferences:

```swift
@AppStorage("indicatorPosition") var indicatorPosition: IndicatorPosition = .topRight
@AppStorage("showTitle") var showTitle: Bool = true
@AppStorage("indicatorSize") var indicatorSize: Double = 48
@AppStorage("fontSize") var fontSize: Double = 14
@AppStorage("windowLayout") var windowLayout: WindowLayout = .horizontal
@AppStorage("saveLocation") var saveLocation: String = "~/Desktop"
@AppStorage("watermarkText") var watermarkText: String = "bifcode"
```

---

## Quick Find Commands

### Code Navigation

```bash
# Find SwiftUI views
rg -n "struct.*View.*:" Sources/Views

# Find ViewModels
rg -n "@Observable.*class" Sources/ViewModels

# Find services
rg -n "class.*Service" Sources/Services

# Find color usage
rg -n "Color\." Sources/
```

### Architecture Search

```bash
# Find all @AppStorage usage
rg -n "@AppStorage" Sources/

# Find HighlightSwift usage
rg -n "import HighlightSwift" Sources/
rg -n "CodeText" Sources/

# Find export logic
rg -n "ImageRenderer\|NSImage" Sources/
```

---

## Security Guidelines

### Safe Operations

- Review bash commands before execution
- Confirm before: `git push --force`, `rm -rf`, any destructive operation
- No network requests (offline app)

### Data Privacy

- All data stays local
- No analytics or telemetry
- Export saves to user-specified location only

---

## Git Workflow

- Branch from `master` for features: `feature/description`
- Use Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`
- PRs require: passing tests, SwiftFormat, type checks
- Squash commits on merge
- Delete branches after merge

---

## Testing Requirements

- **Unit tests**: All ViewModels, Services
- **Integration tests**: Export pipeline
- **Framework**: Swift Testing preferred (`@Test`, `#expect`)
- **Location**: `/Tests/` directory
- Run tests before committing

---

## Available Tools

Standard tools available:
- `rg` (ripgrep) for code search
- `git` for version control
- `swift` for package management
- `xcodebuild` for building and testing
- `swiftformat` for code formatting

### Tool Permissions

- **Allowed**: Read any file, write Swift files, run tests/builds
- **Warn first**: Edit `Info.plist`, `Package.resolved`
- **Ask first**: `git push`, delete commands
- **Block**: Force push to master

---

## Common Gotchas

1. **HighlightSwift Async**: Use `await highlight.attributedText()` for manual highlighting
2. **ImageRenderer macOS**: Requires `@MainActor` context
3. **Window Sizing**: Use `GeometryReader` for content-based sizing
4. **Font Metrics**: SF Mono has different metrics than system fonts
5. **Color Assets**: Must define both light/dark variants
6. **Export Resolution**: Use `scale` parameter for Retina export

---

## Design References

Sample UI mockups in `tasks/20251217-bifcode-setup/images/`:
- `dos-window-sample.png` - Green checkmark indicator
- `donts-window-sample.png` - Red X indicator
