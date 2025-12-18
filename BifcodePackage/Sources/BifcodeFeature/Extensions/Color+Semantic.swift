//
//  Color+Semantic.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI

/// Semantic color definitions for Bifcode UI elements.
///
/// This extension provides named colors that load from the asset catalog
/// with automatic light/dark mode support. All colors are defined in
/// `Colors.xcassets` within the BifcodeFeature module.
///
/// ## Color Categories
///
/// The colors are organized into functional groups:
///
/// ### Indicator Colors
/// - ``indicatorDo`` - Green for positive "Do's" examples
/// - ``indicatorDont`` - Red for negative "Don'ts" examples
///
/// ### Editor Colors
/// - ``editorBackground`` - Code editor background
/// - ``editorText`` - Default code text
/// - ``editorLineNumber`` - Line number gutter text
/// - ``editorGutter`` - Line number gutter background
/// - ``editorCloseButton`` - Traffic light placeholder
///
/// ### Window Colors
/// - ``windowBackground`` - Main window background
/// - ``titleBarBackground`` - Panel title bar
/// - ``titleText`` - Title bar text
/// - ``windowBorder`` - Panel border stroke
///
/// ### UI Colors
/// - ``toolbarBackground`` - Toolbar container
/// - ``contentBackground`` - Main content area
/// - ``secondaryText`` - De-emphasized text
///
/// ## Usage
///
/// ```swift
/// Text("Do's")
///     .foregroundColor(.indicatorDo)
///
/// Rectangle()
///     .fill(Color.editorBackground)
/// ```
///
/// > Important: Never use hardcoded colors like `.red` or `.green`.
/// > Always use semantic colors for theme consistency.
extension Color {
    // MARK: - Indicator Colors

    /// Green checkmark indicator for "Do's"
    /// Light: Slightly darker green for better contrast
    /// Dark: Bright green
    public static let indicatorDo = Color("IndicatorDo", bundle: .module)

    /// Red X indicator for "Don'ts"
    /// Light: Slightly darker red for better contrast
    /// Dark: Bright red
    public static let indicatorDont = Color("IndicatorDont", bundle: .module)

    // MARK: - Editor Colors

    /// Close button color (traffic light placeholder)
    /// Light: Slightly darker red
    /// Dark: Bright red
    public static let editorCloseButton = Color("EditorCloseButton", bundle: .module)

    /// Code editor background
    /// Light: Off-white
    /// Dark: Dark gray
    public static let editorBackground = Color("EditorBackground", bundle: .module)

    /// Line number text color
    /// Light: Medium gray
    /// Dark: Light gray
    public static let editorLineNumber = Color("EditorLineNumber", bundle: .module)

    /// Default code text color (overridden by syntax theme)
    /// Light: Dark gray
    /// Dark: Off-white
    public static let editorText = Color("EditorText", bundle: .module)

    /// Editor gutter background
    /// Light: Slightly darker than editor background
    /// Dark: Slightly darker than editor background
    public static let editorGutter = Color("EditorGutter", bundle: .module)

    // MARK: - Window Colors

    /// Window background
    /// Light: Light gray
    /// Dark: Dark gray
    public static let windowBackground = Color("WindowBackground", bundle: .module)

    /// Title bar background
    /// Light: Slightly darker than window
    /// Dark: Slightly lighter than window
    public static let titleBarBackground = Color("TitleBarBackground", bundle: .module)

    /// Title text color
    /// Light: Dark gray
    /// Dark: Off-white
    public static let titleText = Color("TitleText", bundle: .module)

    /// Window border color
    /// Light: Light gray
    /// Dark: Medium gray
    public static let windowBorder = Color("WindowBorder", bundle: .module)

    // MARK: - UI Colors

    /// Toolbar background
    /// Light: Light gray
    /// Dark: Dark gray
    public static let toolbarBackground = Color("ToolbarBackground", bundle: .module)

    /// Main content area background
    /// Light: Off-white
    /// Dark: Near black
    public static let contentBackground = Color("ContentBackground", bundle: .module)

    /// Secondary text color
    /// Light: Semi-transparent black
    /// Dark: Semi-transparent white
    public static let secondaryText = Color("SecondaryText", bundle: .module)
}
