//
//  SettingsTypes.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditSourceEditor
import Foundation

/// Indicator position options
public enum IndicatorPosition: String, CaseIterable, Sendable {
    case topRight = "top-right"
    case bottomRight = "bottom-right"

    public var label: String {
        switch self {
        case .topRight: "Top Right"
        case .bottomRight: "Bottom Right"
        }
    }
}

/// Indicator style options
public enum IndicatorStyle: String, CaseIterable, Sendable {
    case iconOnly = "icon"
    case textOnly = "text"
    case iconAndText = "both"

    public var label: String {
        switch self {
        case .iconOnly: "Icon Only"
        case .textOnly: "Text Only"
        case .iconAndText: "Icon + Text"
        }
    }
}

/// Window layout options
public enum WindowLayout: String, CaseIterable, Sendable {
    case horizontal
    case vertical

    public var label: String {
        switch self {
        case .horizontal: "Side by Side"
        case .vertical: "Stacked"
        }
    }
}

// MARK: - Editor Themes

/// Available editor theme options
public enum EditorThemeOption: String, CaseIterable, Sendable {
    case atomOneDark = "atom-one-dark"
    case dracula
    case githubDark = "github-dark"
    case monokai
    case nord
    case solarizedDark = "solarized-dark"
    case xcodeDefault = "xcode-default"

    public var label: String {
        switch self {
        case .atomOneDark: "Atom One Dark"
        case .dracula: "Dracula"
        case .githubDark: "GitHub Dark"
        case .monokai: "Monokai"
        case .nord: "Nord"
        case .solarizedDark: "Solarized Dark"
        case .xcodeDefault: "Xcode Default"
        }
    }

    /// Converts to CodeEditSourceEditor's EditorTheme
    public var editorTheme: EditorTheme {
        switch self {
        case .atomOneDark: .atomOneDark
        case .dracula: .dracula
        case .githubDark: .githubDark
        case .monokai: .monokai
        case .nord: .nord
        case .solarizedDark: .solarizedDark
        case .xcodeDefault: .xcodeDefault
        }
    }
}

// MARK: - EditorTheme Presets

extension EditorTheme {
    /// Atom One Dark theme
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

    /// Dracula theme
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

    /// GitHub Dark theme
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

    /// Monokai theme
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

    /// Nord theme
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

    /// Solarized Dark theme
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

    /// Xcode Default (Dark) theme
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
}
