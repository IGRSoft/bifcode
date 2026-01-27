//
//  Color+Semantic.swift
//
//  Created on 17.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
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
public extension Color {
    // MARK: - Indicator Colors
    
    /// Green checkmark indicator for "Do's"
    /// Light: Slightly darker green for better contrast
    /// Dark: Bright green
    static let indicatorDo = Color("IndicatorDo", bundle: .module)
    
    /// Red X indicator for "Don'ts"
    /// Light: Slightly darker red for better contrast
    /// Dark: Bright red
    static let indicatorDont = Color("IndicatorDont", bundle: .module)
    
    // MARK: - Editor Colors
    
    /// Close button color (traffic light placeholder)
    /// Light: Slightly darker red
    /// Dark: Bright red
    static let editorCloseButton = Color("EditorCloseButton", bundle: .module)
    
    /// Code editor background
    /// Light: Off-white
    /// Dark: Dark gray
    static let editorBackground = Color("EditorBackground", bundle: .module)
    
    /// Line number text color
    /// Light: Medium gray
    /// Dark: Light gray
    static let editorLineNumber = Color("EditorLineNumber", bundle: .module)
    
    /// Default code text color (overridden by syntax theme)
    /// Light: Dark gray
    /// Dark: Off-white
    static let editorText = Color("EditorText", bundle: .module)
    
    /// Editor gutter background
    /// Light: Slightly darker than editor background
    /// Dark: Slightly darker than editor background
    static let editorGutter = Color("EditorGutter", bundle: .module)
    
    // MARK: - Window Colors
    
    /// Window background
    /// Light: Light gray
    /// Dark: Dark gray
    static let windowBackground = Color("WindowBackground", bundle: .module)
    
    /// Title bar background
    /// Light: Slightly darker than window
    /// Dark: Slightly lighter than window
    static let titleBarBackground = Color("TitleBarBackground", bundle: .module)
    
    /// Title text color
    /// Light: Dark gray
    /// Dark: Off-white
    static let titleText = Color("TitleText", bundle: .module)
    
    /// Window border color
    /// Light: Light gray
    /// Dark: Medium gray
    static let windowBorder = Color("WindowBorder", bundle: .module)
    
    // MARK: - UI Colors
    
    /// Toolbar background
    /// Light: Light gray
    /// Dark: Dark gray
    static let toolbarBackground = Color("ToolbarBackground", bundle: .module)
    
    /// Main content area background
    /// Light: Off-white
    /// Dark: Near black
    static let contentBackground = Color("ContentBackground", bundle: .module)
    
    /// Secondary text color
    /// Light: Semi-transparent black
    /// Dark: Semi-transparent white
    static let secondaryText = Color("SecondaryText", bundle: .module)
    
    /// Tertiary text color for labels and hints
    /// Light: Lighter semi-transparent black
    /// Dark: Lighter semi-transparent white
    static var tertiaryText: Color {
        Color.secondary.opacity(0.7)
    }
    
    /// Section header text color
    /// Light: Dark gray
    /// Dark: Light gray
    static var sectionHeader: Color {
        Color.primary.opacity(0.85)
    }
    
    /// Control group background for visual separation
    /// Light: Subtle light overlay
    /// Dark: Subtle dark overlay
    static var controlGroupBackground: Color {
        Color.primary.opacity(0.04)
    }
    
    /// Store button - purchased state (uses semantic green)
    static let storePurchased = Color("IndicatorDo", bundle: .module)
    
    /// Store button - not purchased state (uses system accent)
    static var storeDefault: Color {
        Color.accentColor
    }
    
    // MARK: - Toast Colors
    
    /// Toast success background - uses semantic green
    static let toastSuccess = Color("IndicatorDo", bundle: .module)
    
    /// Toast error background - uses semantic red
    static let toastError = Color("IndicatorDont", bundle: .module)
    
    // MARK: - Theme Mode Aware Colors
    
    /// Title bar background based on theme mode
    /// - Parameter mode: The current theme mode (dark or light)
    /// - Returns: Appropriate title bar background color
    static func titleBarBackground(for mode: ThemeMode) -> Color {
        mode == .dark
            ? Color("TitleBarBackground", bundle: .module)
            : Color("TitleBarBackgroundLight", bundle: .module)
    }
    
    /// Title text color based on theme mode
    /// - Parameter mode: The current theme mode (dark or light)
    /// - Returns: Appropriate title text color
    static func titleText(for mode: ThemeMode) -> Color {
        mode == .dark
            ? Color("TitleText", bundle: .module)
            : Color("TitleTextLight", bundle: .module)
    }
    
    /// Window border color based on theme mode
    /// - Parameter mode: The current theme mode (dark or light)
    /// - Returns: Appropriate window border color
    static func windowBorder(for mode: ThemeMode) -> Color {
        mode == .dark
            ? Color("WindowBorder", bundle: .module)
            : Color("WindowBorderLight", bundle: .module)
    }
    
    /// Close button color based on theme mode
    /// - Parameter mode: The current theme mode (dark or light)
    /// - Returns: Appropriate close button color
    static func editorCloseButton(for mode: ThemeMode) -> Color {
        mode == .dark
            ? Color("EditorCloseButton", bundle: .module)
            : Color("EditorCloseButtonLight", bundle: .module)
    }
}
