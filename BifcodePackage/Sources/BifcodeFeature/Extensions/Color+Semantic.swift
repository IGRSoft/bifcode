import SwiftUI

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
}
