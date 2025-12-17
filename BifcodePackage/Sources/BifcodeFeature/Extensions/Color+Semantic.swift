import SwiftUI

public extension Color {
    // MARK: - Indicator Colors

    /// Green checkmark indicator for "Do's"
    static let indicatorDo = Color(red: 0.2, green: 0.8, blue: 0.4)

    /// Red X indicator for "Don'ts"
    static let indicatorDont = Color(red: 0.9, green: 0.3, blue: 0.3)

    // MARK: - Editor Colors

    /// Code editor background
    static let editorBackground = Color(red: 0.12, green: 0.12, blue: 0.14)

    /// Line number text color
    static let editorLineNumber = Color(white: 0.4)

    /// Default code text color
    static let editorText = Color(white: 0.9)

    /// Editor gutter background
    static let editorGutter = Color(red: 0.1, green: 0.1, blue: 0.12)

    // MARK: - Window Colors

    /// Window background
    static let windowBackground = Color(red: 0.15, green: 0.15, blue: 0.17)

    /// Title bar background
    static let titleBarBackground = Color(red: 0.18, green: 0.18, blue: 0.2)

    /// Title text color
    static let titleText = Color(white: 0.85)

    /// Window border color
    static let windowBorder = Color(white: 0.25)

    // MARK: - Watermark

    /// Watermark text color
    static let watermark = Color(white: 0.5)
}
