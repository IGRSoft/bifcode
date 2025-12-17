# Bifcode

Code comparison image generator for Do's and Don'ts. Create professional side-by-side code examples with syntax highlighting for documentation, tutorials, and technical content.

## Overview

- **Type**: macOS application
- **Stack**: Swift 6.2, SwiftUI, HighlightSwift
- **Platform**: macOS 15.0+ (Sequoia)
- **License**: MIT

## Features

### Core Functionality

- **Dual Code Windows** - Separate Do's (green) and Don'ts (red) editors
- **Syntax Highlighting** - 50+ languages with auto-detection
- **PNG Export** - High-quality images ready for sharing
- **Dark Theme** - Optimized for readability

### Customization Options

| Option | Description |
|--------|-------------|
| Icon Style | Choose Do/Don't indicator design |
| Title Visibility | Show/hide window titles |
| Indicator Size | Adjust badge dimensions |
| Indicator Position | Top-right or bottom-left placement |
| Font Size | Customize code font size |
| Window Layout | Vertical or horizontal arrangement |
| Window Titles | Custom titles for each panel |
| Language Selection | Auto-detect with manual override |
| Save Location | Default Desktop, configurable |
| Watermark | Bottom-center branding |

### Auto-Sizing

Windows automatically resize based on:
- Code content length
- Line count
- Indicator badge dimensions

## Use Cases

- Documentation and style guides
- Tutorial content
- Code review illustrations
- Technical blog posts
- Social media developer content

## Requirements

- macOS 15.0+ (Sequoia)
- Apple Silicon or Intel Mac

## Installation

### From Release

Download the latest `.dmg` from Releases and drag to Applications.

### From Source

```bash
git clone https://github.com/nickmain/bifcode.git
cd bifcode
open Bifcode.xcodeproj
# Build and run (Cmd+R)
```

## Dependencies

| Package | Purpose |
|---------|---------|
| [HighlightSwift](https://github.com/appstefan/HighlightSwift) | Syntax highlighting with language auto-detection |

## Architecture

```
Bifcode/
├── Sources/
│   ├── App/              # App entry point
│   ├── Views/            # SwiftUI views
│   ├── ViewModels/       # @Observable view models
│   ├── Models/           # Data models
│   ├── Services/         # Export, settings services
│   └── Extensions/       # Color, Font extensions
├── Resources/
│   └── Assets.xcassets/  # Colors, icons
└── Tests/
```

## License

MIT License - see [LICENSE](LICENSE)
