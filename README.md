# Bifcode

A macOS app for creating visual code comparison images — perfect for documentation, tutorials, and style guides showing "Do" vs "Don't" code examples.

## Powered By

<a href="https://github.com/CodeEditApp/CodeEditSourceEditor">
  <img src="https://img.shields.io/badge/Powered%20by-CodeEditSourceEditor-blue?style=for-the-badge" alt="Powered by CodeEditSourceEditor">
</a>

Bifcode's code editor is built on [**CodeEditSourceEditor**](https://github.com/CodeEditApp/CodeEditSourceEditor) — an Xcode-inspired code editor component from the [CodeEditApp](https://github.com/CodeEditApp) team.

**Support the project:**
- ⭐ [Star CodeEditSourceEditor on GitHub](https://github.com/CodeEditApp/CodeEditSourceEditor)
- 🏠 [Check out CodeEdit](https://github.com/CodeEditApp/CodeEdit) — A native macOS code editor
- 💖 [Sponsor CodeEditApp](https://github.com/sponsors/CodeEditApp)

## Features

### Code Editor
- Syntax highlighting with CodeEditSourceEditor
- Title bar toggle for cleaner exports
- Font size: 10–24pt
- Max 24 lines, 210 characters per line
- Dark and light theme modes

### Supported Languages (19)

| | | | |
|---|---|---|---|
| Swift | Python | JavaScript | TypeScript |
| Java | Kotlin | Go | Rust |
| Ruby | C | C++ | C# |
| PHP | SQL | HTML | CSS |
| JSON | YAML | Bash | |

### Syntax Themes (11)

**Dark Themes (7)**
| Theme | Description |
|-------|-------------|
| Atom One Dark | Popular dark theme from Atom editor |
| Dracula | High contrast dark theme with vibrant colors |
| GitHub Dark | GitHub's official dark mode |
| Monokai | Classic theme from Sublime Text |
| Nord | Arctic, bluish color palette |
| Solarized Dark | Teal-tinged dark with balanced colors |
| Xcode Default | Apple's default Xcode dark theme |

**Light Themes (4)**
| Theme | Description |
|-------|-------------|
| Atom One Light | Light variant of Atom One |
| GitHub Light | GitHub's official light mode |
| Solarized Light | Cream-colored background with warm tones |
| Xcode Light | Apple's default Xcode light theme |

### Indicator Badges

Customizable Do/Don't badges with:

- **Positions**: Top-right, Bottom-right
- **Styles**: Icon only, Text only, Icon + Text
- **Size**: 32–80px adjustable
- **Labels**: Custom text (max 10 characters)

**Available Icons (10 SF Symbols)**

| Positive (Do) | Negative (Don't) |
|---------------|------------------|
| checkmark | xmark |
| checkmark.circle | xmark.circle |
| checkmark.square | xmark.square |
| hand.thumbsup | hand.thumbsdown |
| star.fill | exclamationmark.triangle |

### Export

- **Format**: PNG at 2x Retina resolution
- **Layouts**: Horizontal (side-by-side) or Vertical (stacked)
- **Save Location**: Custom folder with bookmark persistence
- **Feedback**: Toast notification with "Reveal in Finder" action

### Accessibility

- Full VoiceOver support throughout the app
- Accessibility labels and hints on all controls
- Reduced motion support for animations

### In-App Purchases

Support the developer via DeveloperSupportStore integration.

## Requirements

- macOS 15.0+ (Sequoia)
- Xcode 16+
- Swift 6.2

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [CodeEditSourceEditor](https://github.com/CodeEditApp/CodeEditSourceEditor) | 0.12.0+ | Code editor with syntax highlighting |
| [DeveloperSupportStore](https://github.com/IGRSoft/DeveloperSupportStore) | 1.0.0+ | In-app purchase support |

## Project Architecture

```
Bifcode/
├── Bifcode.xcworkspace/              # Open this file in Xcode
├── Bifcode.xcodeproj/                # App shell project
├── Bifcode/                          # App target (minimal)
│   ├── Assets.xcassets/              # App-level assets (icons, colors)
│   ├── BifcodeApp.swift              # App entry point
│   ├── Bifcode.entitlements          # App sandbox settings
│   └── Bifcode.xctestplan            # Test configuration
├── BifcodePackage/                   # Primary development area
│   ├── Package.swift                 # Package configuration
│   ├── Sources/BifcodeFeature/       # Feature code
│   └── Tests/BifcodeFeatureTests/    # Unit tests
└── BifcodeUITests/                   # UI automation tests
```

### Feature Package Structure

```
BifcodePackage/Sources/BifcodeFeature/
├── ContentView.swift                 # Main app view with export pipeline
├── Models/
│   ├── CodePanel.swift               # Code panel data model
│   └── SettingsTypes.swift           # Enums for all settings
├── Views/
│   ├── ToolBarView.swift             # Settings toolbar
│   ├── CodeEditorView.swift          # Interactive code editor
│   ├── ExportView.swift              # Export container
│   ├── ExportPanelView.swift         # Non-interactive export panel
│   ├── IndicatorBadgeView.swift      # Do/Don't badge component
│   └── ToastView.swift               # Export notifications
├── ViewModels/
│   └── AppViewModel.swift            # State management
├── Services/
│   └── BookmarkManager.swift         # Save location persistence
├── Extensions/
│   └── Color+Semantic.swift          # Theming system
└── Configuration/
    └── BifcodeStoreConfiguration.swift  # IAP setup
```

## Development

### Build

```bash
xcodebuild -workspace Bifcode.xcworkspace -scheme Bifcode -configuration Debug build
```

### Test

```bash
xcodebuild test -workspace Bifcode.xcworkspace -scheme Bifcode -destination 'platform=macOS'
```

### Format Code

```bash
swiftformat .
```

### Build SPM Package Only

```bash
cd BifcodePackage && swift build
```

## Settings Reference

All user preferences are persisted via `@AppStorage`:

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `selectedLanguage` | String | `"swift"` | Programming language |
| `selectedTheme` | String | `"atom-one-dark"` | Syntax theme |
| `themeMode` | String | `"dark"` | Dark or light mode |
| `fontSize` | Double | `14` | Font size (10–24pt) |
| `windowLayout` | String | `"horizontal"` | Panel layout |
| `showTitle` | Bool | `true` | Show title bar |
| `doTitle` | String | `"Do's"` | Do panel title |
| `dontTitle` | String | `"Don'ts"` | Don't panel title |
| `indicatorPosition` | String | `"top-right"` | Badge position |
| `indicatorStyle` | String | `"both"` | Badge style |
| `indicatorSize` | Double | `48` | Badge size (32–80px) |
| `doIndicatorIcon` | String | `"checkmark"` | Do badge icon |
| `dontIndicatorIcon` | String | `"xmark"` | Don't badge icon |
| `doIndicatorLabel` | String | `"Do's"` | Do badge text |
| `dontIndicatorLabel` | String | `"Don'ts"` | Don't badge text |
| `hasMadePurchase` | Bool | `false` | Purchase state |

## Configuration

### XCConfig Build Settings

Build settings are managed through **XCConfig files** in `Config/`:
- `Config/Shared.xcconfig` - Common settings (bundle ID, versions, deployment target)
- `Config/Debug.xcconfig` - Debug-specific settings
- `Config/Release.xcconfig` - Release-specific settings
- `Config/Tests.xcconfig` - Test-specific settings

### App Sandbox & Entitlements

The app is sandboxed with file access permissions. Edit `Bifcode/Bifcode.entitlements` to modify capabilities.

## Notes

### Generated with XcodeBuildMCP

This project was scaffolded using [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP), which provides tools for AI-assisted macOS development workflows.
