# Bifcode - Code Comparison Image Generator

## Overview

- **Type**: macOS application
- **Stack**: Swift 6.2, SwiftUI, CodeEditSourceEditor
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

**ALWAYS** use semantic colors from `BifcodePackage/Sources/BifcodeFeature/Extensions/Color+Semantic.swift`:

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
# Build (workspace)
xcodebuild -workspace Bifcode.xcworkspace -scheme Bifcode -configuration Debug build

# Run
open -a Bifcode

# Format code
swiftformat .

# Run tests
xcodebuild test -workspace Bifcode.xcworkspace -scheme Bifcode -destination 'platform=macOS'

# Build SPM package only
cd BifcodePackage && swift build
```

### Quality Gates (run before PR)

```bash
swiftformat . && xcodebuild test -workspace Bifcode.xcworkspace -scheme Bifcode -destination 'platform=macOS'
```

---

## Project Structure

### Workspace + SPM Architecture

```
Bifcode/
├── Bifcode.xcworkspace/          # Open this in Xcode
├── Bifcode.xcodeproj/            # App shell project
├── Bifcode/                      # App target (minimal)
│   ├── Assets.xcassets/          # App icons, colors
│   ├── BifcodeApp.swift          # @main entry point
│   └── Bifcode.entitlements      # Sandbox settings
├── BifcodePackage/               # Primary development area
│   ├── Package.swift             # SPM configuration
│   ├── Sources/BifcodeFeature/   # Feature code
│   └── Tests/                    # Unit tests
├── BifcodeUITests/               # UI automation tests
└── Config/                       # XCConfig build settings
```

### Feature Package Structure

```
BifcodePackage/Sources/BifcodeFeature/
├── ContentView.swift             # Main app view
├── Models/
│   ├── SettingsTypes.swift       # Enums: IndicatorPosition, IndicatorStyle, WindowLayout
│   └── CodePanel.swift           # Code panel model
├── Views/
│   ├── CodeEditorView.swift      # Code editor with line numbers
│   ├── CodePanelView.swift       # Complete panel with indicator
│   ├── IndicatorBadgeView.swift  # Do/Don't badge
│   └── SettingsView.swift        # Preferences panel
├── ViewModels/
│   └── AppViewModel.swift        # Main view model
└── Extensions/
    └── Color+Semantic.swift      # Semantic colors
```

### Resources

```
Bifcode/Assets.xcassets/
├── AccentColor.colorset/         # App accent color
└── AppIcon.appiconset/           # App icon
```

### Testing

```
BifcodePackage/Tests/BifcodeFeatureTests/   # Unit tests
BifcodeUITests/                              # UI tests
```

---

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [CodeEditSourceEditor](https://github.com/CodeEditApp/CodeEditSourceEditor) | 0.12.0+ | Xcode-inspired code editor with syntax highlighting |
| [CodeEditLanguages](https://github.com/CodeEditApp/CodeEditLanguages) | 0.1.20+ | Tree-sitter language support (19+ languages) |
| [DeveloperSupportStore](https://github.com/IGRSoft/DeveloperSupportStore) | 1.0.0+ | In-app purchase support |

### Adding CodeEditSourceEditor

In Xcode:
1. File → Add Package Dependencies
2. URL: `https://github.com/CodeEditApp/CodeEditSourceEditor`
3. Version: 0.12.0+

**Support the CodeEditApp project:**
- ⭐ [Star on GitHub](https://github.com/CodeEditApp/CodeEditSourceEditor)
- 💖 [Sponsor CodeEditApp](https://github.com/sponsors/CodeEditApp)

---

## Feature Specifications

### Code Editor

- Syntax highlighting via CodeEditSourceEditor `SourceEditor`
- 19+ supported languages via CodeEditLanguages
- 11 syntax themes (7 dark, 4 light)
- Monospace font (SF Mono or system monospace)
- Dark and light theme modes

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
rg -n "struct.*View.*:" BifcodePackage/Sources

# Find ViewModels
rg -n "@Observable.*class" BifcodePackage/Sources

# Find models
rg -n "struct.*:" BifcodePackage/Sources/BifcodeFeature/Models

# Find color usage
rg -n "Color\." BifcodePackage/Sources
```

### Architecture Search

```bash
# Find all @AppStorage usage
rg -n "@AppStorage" BifcodePackage/Sources

# Find CodeEditSourceEditor usage
rg -n "import CodeEditSourceEditor" BifcodePackage/Sources
rg -n "SourceEditor" BifcodePackage/Sources

# Find export logic
rg -n "ImageRenderer\|NSImage" BifcodePackage/Sources
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

1. **CodeEditSourceEditor State**: Use `SourceEditorState` for cursor position and selection management
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
