//
//  SettingsTypes.swift
//
//  Created on 17.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditSourceEditor
import Foundation

// MARK: - Font Family

/// The font family for code display in the editor.
///
/// Provides a selection of popular monospace fonts suitable for code editing.
/// The default is the system monospace font (SF Mono on macOS).
///
/// ## Usage
///
/// ```swift
/// @AppStorage("fontFamily") private var fontFamily = FontFamily.system.rawValue
/// ```
///
/// ## Available Fonts
///
/// - **System** - SF Mono (default system monospace)
/// - **Menlo** - Classic macOS monospace font
/// - **Monaco** - Legacy macOS programming font
/// - **Courier** - Traditional monospace font
///
/// ## Topics
///
/// ### Fonts
///
/// - ``system``
/// - ``menlo``
/// - ``monaco``
/// - ``courier``
public enum FontFamily: String, CaseIterable, Sendable {
    /// System monospace font (SF Mono on macOS).
    ///
    /// The default font, matching Apple's design guidelines
    /// for code display. Available in all weights.
    case system

    /// Menlo font family.
    ///
    /// A classic macOS monospace font derived from Bitstream Vera Sans Mono.
    /// Has been the default Terminal font for many years.
    case menlo = "Menlo"

    /// Monaco font family.
    ///
    /// The original macOS programming font, used in classic Mac OS
    /// and early versions of Xcode. Has a distinctive, compact style.
    case monaco = "Monaco"

    /// Courier New font family.
    ///
    /// A traditional typewriter-style monospace font. Has a more
    /// classic, formal appearance than other options.
    case courier = "Courier New"

    /// A human-readable label for display in pickers.
    public var label: String {
        switch self {
        case .system: "SF Mono"
        case .menlo: "Menlo"
        case .monaco: "Monaco"
        case .courier: "Courier New"
        }
    }

    /// Creates an NSFont with this font family at the specified size.
    ///
    /// - Parameter size: The font size in points.
    /// - Returns: An NSFont configured with this font family, or the
    ///   system monospace font if the specified font is unavailable.
    public func font(size: CGFloat) -> NSFont {
        switch self {
        case .system:
            NSFont.monospacedSystemFont(ofSize: size, weight: .regular)
        case .menlo, .monaco, .courier:
            NSFont(name: rawValue, size: size)
                ?? NSFont.monospacedSystemFont(ofSize: size, weight: .regular)
        }
    }
}

// MARK: - Indicator Position

/// The position of the indicator badge within a code panel.
///
/// Indicator badges can be placed in different corners of the code editor
/// to accommodate various design preferences and code layouts.
///
/// ## Usage
///
/// The position is stored via `@AppStorage` and applied to both panels:
///
/// ```swift
/// @AppStorage("indicatorPosition") private var indicatorPosition = IndicatorPosition.topRight.rawValue
/// ```
///
/// ## Topics
///
/// ### Positions
///
/// - ``topRight``
/// - ``bottomRight``
public enum IndicatorPosition: String, CaseIterable, Sendable {
    /// Places the indicator in the top-right corner of the editor.
    ///
    /// This is the default position, ideal for code that starts from
    /// the top and doesn't require immediate visual attention.
    case topRight = "top-right"

    /// Places the indicator in the bottom-right corner of the editor.
    ///
    /// Useful when the code content starts with important information
    /// that shouldn't be obscured by the badge.
    case bottomRight = "bottom-right"

    /// A human-readable label for display in pickers.
    public var label: String {
        switch self {
        case .topRight: "Top Right"
        case .bottomRight: "Bottom Right"
        }
    }
}

// MARK: - Indicator Style

/// The visual style of the indicator badge.
///
/// Controls whether the badge displays an icon, text label, or both.
/// This allows users to customize the visual density of indicators.
///
/// ## Usage
///
/// ```swift
/// @AppStorage("indicatorStyle") private var indicatorStyle = IndicatorStyle.iconAndText.rawValue
/// ```
///
/// ## Topics
///
/// ### Styles
///
/// - ``iconOnly``
/// - ``textOnly``
/// - ``iconAndText``
public enum IndicatorStyle: String, CaseIterable, Sendable {
    /// Shows only the SF Symbol icon without text.
    ///
    /// Creates a minimal, icon-only badge. The icon size is 60% of
    /// the badge size parameter.
    case iconOnly = "icon"

    /// Shows only the text label without an icon.
    ///
    /// Displays the label text (e.g., "Do's" or "Don'ts") without
    /// any icon. Text size is 30% of the badge size parameter.
    case textOnly = "text"

    /// Shows both the icon and text label.
    ///
    /// The default style, displaying the icon above the text label
    /// for maximum clarity.
    case iconAndText = "both"

    /// A human-readable label for display in pickers.
    public var label: String {
        switch self {
        case .iconOnly: "Icon Only"
        case .textOnly: "Text Only"
        case .iconAndText: "Icon + Text"
        }
    }
}

// MARK: - Indicator Icon

/// Curated SF Symbol icons for indicator badges.
///
/// Provides a curated selection of SF Symbols appropriate for
/// "Do" (positive) and "Don't" (negative) indicators. Icons are
/// grouped by semantic meaning for easy selection in the UI.
///
/// ## Usage
///
/// Access icons by category for pickers:
///
/// ```swift
/// // For "Do" panels
/// let doIcons = IndicatorIcon.positiveIcons
///
/// // For "Don't" panels
/// let dontIcons = IndicatorIcon.negativeIcons
/// ```
///
/// ## Topics
///
/// ### Positive Icons
///
/// - ``checkmark``
/// - ``checkmarkCircle``
/// - ``checkmarkSquare``
/// - ``thumbsUp``
/// - ``star``
///
/// ### Negative Icons
///
/// - ``xmark``
/// - ``xmarkCircle``
/// - ``xmarkSquare``
/// - ``thumbsDown``
/// - ``warning``
///
/// ### Icon Access
///
/// - ``systemName``
/// - ``positiveIcons``
/// - ``negativeIcons``
public enum IndicatorIcon: String, CaseIterable, Sendable {
    // Positive indicators

    /// A simple checkmark icon.
    case checkmark

    /// A checkmark inside a circle.
    case checkmarkCircle = "checkmark.circle"

    /// A checkmark inside a square.
    case checkmarkSquare = "checkmark.square"

    /// A thumbs up hand gesture.
    case thumbsUp = "hand.thumbsup"

    /// A filled star icon.
    case star = "star.fill"

    // Negative indicators

    /// A simple X mark icon.
    case xmark

    /// An X mark inside a circle.
    case xmarkCircle = "xmark.circle"

    /// An X mark inside a square.
    case xmarkSquare = "xmark.square"

    /// A thumbs down hand gesture.
    case thumbsDown = "hand.thumbsdown"

    /// An exclamation mark in a triangle (warning).
    case warning = "exclamationmark.triangle"

    /// The SF Symbol system name for this icon.
    ///
    /// Use this value with `Image(systemName:)`:
    ///
    /// ```swift
    /// Image(systemName: icon.systemName)
    /// ```
    public var systemName: String { rawValue }

    /// Icons suitable for "Do" (positive) indicators.
    ///
    /// Returns: checkmark, checkmark.circle, checkmark.square,
    /// hand.thumbsup, star.fill
    public static var positiveIcons: [IndicatorIcon] {
        [.checkmark, .checkmarkCircle, .checkmarkSquare, .thumbsUp, .star]
    }

    /// Icons suitable for "Don't" (negative) indicators.
    ///
    /// Returns: xmark, xmark.circle, xmark.square,
    /// hand.thumbsdown, exclamationmark.triangle
    public static var negativeIcons: [IndicatorIcon] {
        [.xmark, .xmarkCircle, .xmarkSquare, .thumbsDown, .warning]
    }
}

// MARK: - Window Layout

/// The arrangement of code panels in the main view.
///
/// Controls whether the Do and Don't panels are displayed
/// side-by-side (horizontal) or stacked (vertical).
///
/// ## Usage
///
/// ```swift
/// @AppStorage("windowLayout") private var windowLayout = WindowLayout.horizontal.rawValue
/// ```
///
/// ## Topics
///
/// ### Layouts
///
/// - ``horizontal``
/// - ``vertical``
public enum WindowLayout: String, CaseIterable, Sendable {
    /// Panels are arranged side-by-side horizontally.
    ///
    /// The Don't panel appears on the left, and the Do panel
    /// appears on the right. Best for wide displays.
    case horizontal

    /// Panels are stacked vertically.
    ///
    /// The Don't panel appears on top, and the Do panel
    /// appears below. Best for narrow displays or portrait mode.
    case vertical

    /// A human-readable label for display in pickers.
    public var label: String {
        switch self {
        case .horizontal: "Side by Side"
        case .vertical: "Stacked"
        }
    }
}

// MARK: - Theme Mode

/// The color mode for the code editor themes.
///
/// Controls whether dark or light themes are displayed in the theme picker.
/// Users can toggle between modes, and the selected theme will switch to
/// an equivalent theme in the new mode when available.
///
/// ## Usage
///
/// ```swift
/// @AppStorage("themeMode") private var themeMode = ThemeMode.dark.rawValue
/// ```
///
/// ## Topics
///
/// ### Modes
///
/// - ``dark``
/// - ``light``
public enum ThemeMode: String, CaseIterable, Sendable {
    /// Dark mode themes with dark backgrounds.
    ///
    /// Ideal for low-light environments and reducing eye strain.
    case dark

    /// Light mode themes with light backgrounds.
    ///
    /// Better for bright environments and matching system light mode.
    case light

    /// A human-readable label for display in pickers.
    public var label: String {
        switch self {
        case .dark: "Dark"
        case .light: "Light"
        }
    }
}

// MARK: - Editor Themes

/// Available syntax highlighting themes for the code editor.
///
/// `EditorThemeOption` provides a curated selection of popular code editor
/// themes in both dark and light variants. Each theme defines colors for text,
/// keywords, strings, comments, and other syntax elements.
///
/// ## Usage
///
/// Select a theme and access its underlying `EditorTheme`:
///
/// ```swift
/// @AppStorage("selectedTheme") private var selectedTheme = EditorThemeOption.atomOneDark.rawValue
///
/// // Get the EditorTheme for CodeEditSourceEditor
/// let theme = EditorThemeOption.atomOneDark.editorTheme
/// ```
///
/// ## Available Themes
///
/// ### Dark Themes
///
/// | Theme | Description |
/// |-------|-------------|
/// | Atom One Dark | Popular dark theme from Atom editor |
/// | Dracula | High contrast dark theme |
/// | GitHub Dark | GitHub's official dark mode |
/// | Monokai | Classic theme from Sublime Text |
/// | Nord | Arctic, bluish color palette |
/// | Solarized Dark | Solarized dark variant |
/// | Xcode Default | macOS Xcode default dark theme |
///
/// ### Light Themes
///
/// | Theme | Description |
/// |-------|-------------|
/// | Atom One Light | Light variant of Atom One |
/// | GitHub Light | GitHub's official light mode |
/// | Solarized Light | Solarized light variant |
/// | Xcode Light | macOS Xcode default light theme |
///
/// ## Topics
///
/// ### Dark Themes
///
/// - ``atomOneDark``
/// - ``dracula``
/// - ``githubDark``
/// - ``monokai``
/// - ``nord``
/// - ``solarizedDark``
/// - ``xcodeDefault``
///
/// ### Light Themes
///
/// - ``atomOneLight``
/// - ``githubLight``
/// - ``solarizedLight``
/// - ``xcodeLight``
///
/// ### Accessing Theme Data
///
/// - ``label``
/// - ``editorTheme``
/// - ``mode``
/// - ``themes(for:)``
/// - ``equivalent(in:)``
public enum EditorThemeOption: String, CaseIterable, Sendable {
    // MARK: - Dark Themes

    /// Atom One Dark theme.
    ///
    /// A popular dark theme originally from the Atom editor.
    /// Features a dark gray background with muted, readable colors.
    case atomOneDark = "atom-one-dark"

    /// Dracula theme.
    ///
    /// A high-contrast dark theme with vibrant colors.
    /// Features a purple/pink accent color scheme.
    case dracula

    /// GitHub Dark theme.
    ///
    /// GitHub's official dark mode color scheme.
    /// Features a very dark background with blue accents.
    case githubDark = "github-dark"

    /// Monokai theme.
    ///
    /// A classic theme originally from Sublime Text.
    /// Features warm colors on a dark brown-gray background.
    case monokai

    /// Nord theme.
    ///
    /// An arctic, bluish color palette inspired by polar nights.
    /// Features cool blue and gray tones.
    case nord

    /// Solarized Dark theme.
    ///
    /// The dark variant of the Solarized color scheme.
    /// Features a teal-tinged dark background with carefully
    /// chosen contrasting colors.
    case solarizedDark = "solarized-dark"

    /// Xcode Default Dark theme.
    ///
    /// The default dark theme from Apple's Xcode.
    /// Features a very dark background with the familiar
    /// Xcode syntax coloring.
    case xcodeDefault = "xcode-default"

    // MARK: - Light Themes

    /// Atom One Light theme.
    ///
    /// The light variant of the popular Atom One theme.
    /// Features a light gray background with readable syntax colors.
    case atomOneLight = "atom-one-light"

    /// GitHub Light theme.
    ///
    /// GitHub's official light mode color scheme.
    /// Features a white background with familiar GitHub coloring.
    case githubLight = "github-light"

    /// Solarized Light theme.
    ///
    /// The light variant of the Solarized color scheme.
    /// Features a cream-colored background with warm tones.
    case solarizedLight = "solarized-light"

    /// Xcode Default Light theme.
    ///
    /// The default light theme from Apple's Xcode.
    /// Features a white background with familiar Xcode syntax coloring.
    case xcodeLight = "xcode-light"

    /// A human-readable label for display in pickers.
    public var label: String {
        switch self {
        case .atomOneDark: "Atom One Dark"
        case .dracula: "Dracula"
        case .githubDark: "GitHub Dark"
        case .monokai: "Monokai"
        case .nord: "Nord"
        case .solarizedDark: "Solarized Dark"
        case .xcodeDefault: "Xcode Default"
        case .atomOneLight: "Atom One Light"
        case .githubLight: "GitHub Light"
        case .solarizedLight: "Solarized Light"
        case .xcodeLight: "Xcode Light"
        }
    }

    /// The theme mode (dark or light).
    ///
    /// Use this to filter themes by mode in the UI.
    public var mode: ThemeMode {
        switch self {
        case .atomOneDark, .dracula, .githubDark, .monokai, .nord, .solarizedDark, .xcodeDefault:
            .dark
        case .atomOneLight, .githubLight, .solarizedLight, .xcodeLight:
            .light
        }
    }

    /// Returns all themes for a specific mode.
    ///
    /// Use this to filter the theme picker based on the current mode:
    ///
    /// ```swift
    /// let darkThemes = EditorThemeOption.themes(for: .dark)
    /// let lightThemes = EditorThemeOption.themes(for: .light)
    /// ```
    ///
    /// - Parameter mode: The theme mode to filter by.
    /// - Returns: An array of themes matching the specified mode.
    public static func themes(for mode: ThemeMode) -> [EditorThemeOption] {
        allCases.filter { $0.mode == mode }
    }

    /// Returns the equivalent theme in the target mode, if available.
    ///
    /// When switching between dark and light modes, this method finds
    /// the corresponding theme variant. For themes without an equivalent
    /// (like Dracula or Monokai), returns `nil`.
    ///
    /// ```swift
    /// let darkTheme = EditorThemeOption.atomOneDark
    /// let lightEquivalent = darkTheme.equivalent(in: .light) // .atomOneLight
    /// ```
    ///
    /// - Parameter targetMode: The mode to find an equivalent theme in.
    /// - Returns: The equivalent theme, or `nil` if none exists.
    public func equivalent(in targetMode: ThemeMode) -> EditorThemeOption? {
        guard mode != targetMode else { return self }

        switch self {
        case .atomOneDark: return .atomOneLight
        case .atomOneLight: return .atomOneDark
        case .githubDark: return .githubLight
        case .githubLight: return .githubDark
        case .solarizedDark: return .solarizedLight
        case .solarizedLight: return .solarizedDark
        case .xcodeDefault: return .xcodeLight
        case .xcodeLight: return .xcodeDefault
        case .dracula, .monokai, .nord: return nil
        }
    }

    /// The underlying `EditorTheme` for CodeEditSourceEditor.
    ///
    /// Use this property to configure the `SourceEditor` appearance:
    ///
    /// ```swift
    /// SourceEditorConfiguration(
    ///     appearance: .init(theme: selectedTheme.editorTheme, ...)
    /// )
    /// ```
    public var editorTheme: EditorTheme {
        switch self {
        case .atomOneDark: .atomOneDark
        case .dracula: .dracula
        case .githubDark: .githubDark
        case .monokai: .monokai
        case .nord: .nord
        case .solarizedDark: .solarizedDark
        case .xcodeDefault: .xcodeDefault
        case .atomOneLight: .atomOneLight
        case .githubLight: .githubLight
        case .solarizedLight: .solarizedLight
        case .xcodeLight: .xcodeLight
        }
    }
}

// MARK: - EditorTheme Presets

/// Extension providing predefined theme presets for `EditorTheme`.
///
/// Each theme defines complete color settings for syntax highlighting:
/// - Text colors (default, keywords, types, variables)
/// - String and number literals
/// - Comments
/// - Editor chrome (background, selection, line highlight)
///
/// > Note: These properties use `nonisolated(unsafe)` because they are
/// > constant static values that don't require actor isolation.
extension EditorTheme {
    /// Atom One Dark theme preset.
    ///
    /// A popular dark theme with a `#282c34` background and muted,
    /// readable syntax colors.
    public nonisolated(unsafe) static let atomOneDark = EditorTheme(
        text: .init(color: NSColor(red: 0.67, green: 0.69, blue: 0.75, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.16, green: 0.18, blue: 0.20, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.24, green: 0.29, blue: 0.38, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.78, green: 0.47, blue: 0.71, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.38, green: 0.70, blue: 0.96, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.90, green: 0.73, blue: 0.47, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.90, green: 0.73, blue: 0.47, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.88, green: 0.42, blue: 0.44, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.82, green: 0.53, blue: 0.34, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.82, green: 0.53, blue: 0.34, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.60, green: 0.76, blue: 0.48, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.60, green: 0.76, blue: 0.48, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.36, green: 0.40, blue: 0.44, alpha: 1.0))
    )

    /// Dracula theme preset.
    ///
    /// A high-contrast dark theme with vibrant purple and pink accents
    /// on a `#282a36` background.
    public nonisolated(unsafe) static let dracula = EditorTheme(
        text: .init(color: NSColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.16, green: 0.16, blue: 0.21, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.27, green: 0.28, blue: 0.35, alpha: 1.0),
        keywords: .init(color: NSColor(red: 1.0, green: 0.47, blue: 0.78, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.54, green: 0.89, blue: 0.98, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.54, green: 0.89, blue: 0.98, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.31, green: 0.98, blue: 0.48, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.74, green: 0.58, blue: 0.98, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.74, green: 0.58, blue: 0.98, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.95, green: 0.98, blue: 0.48, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.95, green: 0.98, blue: 0.48, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.38, green: 0.45, blue: 0.55, alpha: 1.0))
    )

    /// GitHub Dark theme preset.
    ///
    /// GitHub's official dark mode color scheme with a very dark
    /// `#0d1117` background and blue accents.
    public nonisolated(unsafe) static let githubDark = EditorTheme(
        text: .init(color: NSColor(red: 0.79, green: 0.82, blue: 0.87, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.05, green: 0.07, blue: 0.10, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.15, green: 0.24, blue: 0.42, alpha: 1.0),
        keywords: .init(color: NSColor(red: 1.0, green: 0.49, blue: 0.52, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.84, green: 0.70, blue: 1.0, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.49, green: 0.73, blue: 1.0, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.49, green: 0.73, blue: 1.0, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.79, green: 0.82, blue: 0.87, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.49, green: 0.73, blue: 1.0, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.49, green: 0.73, blue: 1.0, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.63, green: 0.83, blue: 0.61, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.63, green: 0.83, blue: 0.61, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.53, green: 0.57, blue: 0.63, alpha: 1.0))
    )

    /// Monokai theme preset.
    ///
    /// A classic theme from Sublime Text with warm colors on a
    /// `#272822` brown-gray background.
    public nonisolated(unsafe) static let monokai = EditorTheme(
        text: .init(color: NSColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.15, green: 0.16, blue: 0.13, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.28, green: 0.30, blue: 0.25, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.97, green: 0.15, blue: 0.45, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.40, green: 0.85, blue: 0.94, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.40, green: 0.85, blue: 0.94, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.65, green: 0.89, blue: 0.18, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.68, green: 0.51, blue: 1.0, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.68, green: 0.51, blue: 1.0, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.90, green: 0.86, blue: 0.45, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.90, green: 0.86, blue: 0.45, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.46, green: 0.44, blue: 0.37, alpha: 1.0))
    )

    /// Nord theme preset.
    ///
    /// An arctic, bluish color palette with cool blue-gray tones
    /// on a `#2e3440` background.
    public nonisolated(unsafe) static let nord = EditorTheme(
        text: .init(color: NSColor(red: 0.85, green: 0.87, blue: 0.91, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.18, green: 0.20, blue: 0.25, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.26, green: 0.30, blue: 0.37, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.51, green: 0.63, blue: 0.76, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.53, green: 0.75, blue: 0.82, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.53, green: 0.75, blue: 0.82, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.85, green: 0.87, blue: 0.91, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.85, green: 0.87, blue: 0.91, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.70, green: 0.56, blue: 0.68, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.70, green: 0.56, blue: 0.68, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.65, green: 0.75, blue: 0.55, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.65, green: 0.75, blue: 0.55, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.38, green: 0.43, blue: 0.50, alpha: 1.0))
    )

    /// Solarized Dark theme preset.
    ///
    /// The dark variant of Solarized with a teal-tinged `#002b36`
    /// background and carefully balanced colors.
    public nonisolated(unsafe) static let solarizedDark = EditorTheme(
        text: .init(color: NSColor(red: 0.51, green: 0.58, blue: 0.59, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.0, green: 0.17, blue: 0.21, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.07, green: 0.25, blue: 0.30, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.52, green: 0.60, blue: 0.0, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.15, green: 0.55, blue: 0.82, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.71, green: 0.54, blue: 0.0, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.71, green: 0.54, blue: 0.0, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.15, green: 0.55, blue: 0.82, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.35, green: 0.43, blue: 0.46, alpha: 1.0))
    )

    /// Xcode Default Dark theme preset.
    ///
    /// Apple's default dark theme for Xcode with a very dark
    /// `#1c1c1e` background and familiar Xcode syntax coloring.
    public nonisolated(unsafe) static let xcodeDefault = EditorTheme(
        text: .init(color: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
        insertionPoint: .white,
        invisibles: .init(color: NSColor(white: 0.3, alpha: 1.0)),
        background: NSColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0),
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.20, green: 0.37, blue: 0.56, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.99, green: 0.42, blue: 0.62, alpha: 1.0)),
        commands: .init(color: NSColor(red: 0.40, green: 0.83, blue: 0.77, alpha: 1.0)),
        types: .init(color: NSColor(red: 0.36, green: 0.85, blue: 0.99, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.80, green: 0.59, blue: 0.20, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.40, green: 0.83, blue: 0.77, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.82, green: 0.62, blue: 0.99, alpha: 1.0)),
        numbers: .init(color: NSColor(red: 0.82, green: 0.62, blue: 0.99, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.99, green: 0.42, blue: 0.36, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.82, green: 0.62, blue: 0.99, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.42, green: 0.48, blue: 0.51, alpha: 1.0))
    )

    // MARK: - Light Theme Presets

    /// Atom One Light theme preset.
    ///
    /// The light variant of Atom One with a `#fafafa` background
    /// and readable syntax colors.
    public nonisolated(unsafe) static let atomOneLight = EditorTheme(
        text: .init(color: NSColor(red: 0.22, green: 0.23, blue: 0.26, alpha: 1.0)), // #383a42
        insertionPoint: .black,
        invisibles: .init(color: NSColor(white: 0.8, alpha: 1.0)),
        background: NSColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0), // #fafafa
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.65, green: 0.15, blue: 0.64, alpha: 1.0)), // #a626a4
        commands: .init(color: NSColor(red: 0.25, green: 0.43, blue: 0.77, alpha: 1.0)), // #4078f2
        types: .init(color: NSColor(red: 0.76, green: 0.49, blue: 0.0, alpha: 1.0)), // #c18401
        attributes: .init(color: NSColor(red: 0.76, green: 0.49, blue: 0.0, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.90, green: 0.25, blue: 0.21, alpha: 1.0)), // #e45649
        values: .init(color: NSColor(red: 0.60, green: 0.40, blue: 0.0, alpha: 1.0)), // #986801
        numbers: .init(color: NSColor(red: 0.60, green: 0.40, blue: 0.0, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.31, green: 0.63, blue: 0.31, alpha: 1.0)), // #50a14f
        characters: .init(color: NSColor(red: 0.31, green: 0.63, blue: 0.31, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.63, green: 0.63, blue: 0.65, alpha: 1.0)) // #a0a1a7
    )

    /// GitHub Light theme preset.
    ///
    /// GitHub's official light mode color scheme with a `#ffffff`
    /// background and familiar GitHub coloring.
    public nonisolated(unsafe) static let githubLight = EditorTheme(
        text: .init(color: NSColor(red: 0.14, green: 0.16, blue: 0.18, alpha: 1.0)), // #24292e
        insertionPoint: .black,
        invisibles: .init(color: NSColor(white: 0.8, alpha: 1.0)),
        background: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.88, green: 0.93, blue: 0.98, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.84, green: 0.23, blue: 0.29, alpha: 1.0)), // #d73a49
        commands: .init(color: NSColor(red: 0.44, green: 0.26, blue: 0.69, alpha: 1.0)), // #6f42c1
        types: .init(color: NSColor(red: 0.44, green: 0.26, blue: 0.69, alpha: 1.0)),
        attributes: .init(color: NSColor(red: 0.44, green: 0.26, blue: 0.69, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.14, green: 0.16, blue: 0.18, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.0, green: 0.36, blue: 0.58, alpha: 1.0)), // #005cc5
        numbers: .init(color: NSColor(red: 0.0, green: 0.36, blue: 0.58, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.01, green: 0.18, blue: 0.38, alpha: 1.0)), // #032f62
        characters: .init(color: NSColor(red: 0.01, green: 0.18, blue: 0.38, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.42, green: 0.45, blue: 0.49, alpha: 1.0)) // #6a737d
    )

    /// Solarized Light theme preset.
    ///
    /// The light variant of Solarized with a cream-colored `#fdf6e3`
    /// background and carefully balanced colors.
    public nonisolated(unsafe) static let solarizedLight = EditorTheme(
        text: .init(color: NSColor(red: 0.40, green: 0.48, blue: 0.51, alpha: 1.0)), // #657b83
        insertionPoint: .black,
        invisibles: .init(color: NSColor(white: 0.8, alpha: 1.0)),
        background: NSColor(red: 0.99, green: 0.96, blue: 0.89, alpha: 1.0), // #fdf6e3
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.93, green: 0.91, blue: 0.84, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.52, green: 0.60, blue: 0.0, alpha: 1.0)), // #859900
        commands: .init(color: NSColor(red: 0.15, green: 0.55, blue: 0.82, alpha: 1.0)), // #268bd2
        types: .init(color: NSColor(red: 0.71, green: 0.54, blue: 0.0, alpha: 1.0)), // #b58900
        attributes: .init(color: NSColor(red: 0.71, green: 0.54, blue: 0.0, alpha: 1.0)),
        variables: .init(color: NSColor(red: 0.15, green: 0.55, blue: 0.82, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)), // #2aa198
        numbers: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        characters: .init(color: NSColor(red: 0.16, green: 0.63, blue: 0.60, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.58, green: 0.63, blue: 0.63, alpha: 1.0)) // #93a1a1
    )

    /// Xcode Default Light theme preset.
    ///
    /// Apple's default light theme for Xcode with a `#ffffff`
    /// background and familiar Xcode syntax coloring.
    public nonisolated(unsafe) static let xcodeLight = EditorTheme(
        text: .init(color: NSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)), // #000000
        insertionPoint: .black,
        invisibles: .init(color: NSColor(white: 0.8, alpha: 1.0)),
        background: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), // #ffffff
        lineHighlight: NSColor.clear,
        selection: NSColor(red: 0.73, green: 0.84, blue: 0.95, alpha: 1.0),
        keywords: .init(color: NSColor(red: 0.68, green: 0.24, blue: 0.64, alpha: 1.0)), // #ad3da4
        commands: .init(color: NSColor(red: 0.11, green: 0.43, blue: 0.47, alpha: 1.0)), // #1c6b72
        types: .init(color: NSColor(red: 0.11, green: 0.38, blue: 0.56, alpha: 1.0)), // #1c5f8f
        attributes: .init(color: NSColor(red: 0.59, green: 0.40, blue: 0.15, alpha: 1.0)), // #976726
        variables: .init(color: NSColor(red: 0.11, green: 0.43, blue: 0.47, alpha: 1.0)),
        values: .init(color: NSColor(red: 0.11, green: 0.15, blue: 0.73, alpha: 1.0)), // #1c26ba
        numbers: .init(color: NSColor(red: 0.11, green: 0.15, blue: 0.73, alpha: 1.0)),
        strings: .init(color: NSColor(red: 0.82, green: 0.12, blue: 0.11, alpha: 1.0)), // #d12f1b
        characters: .init(color: NSColor(red: 0.11, green: 0.15, blue: 0.73, alpha: 1.0)),
        comments: .init(color: NSColor(red: 0.36, green: 0.42, blue: 0.47, alpha: 1.0)) // #5d6c79
    )
}
