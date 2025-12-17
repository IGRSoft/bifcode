import AppKit
import HighlightSwift
import SwiftUI

/// A complete code panel with title bar, editor, and indicator
public struct CodePanelView: View {
    @Bindable var panel: CodePanel
    let onCodeChange: () -> Void

    // MARK: - Settings (via @AppStorage)

    @AppStorage("indicatorPosition") private var indicatorPositionRaw: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyleRaw: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("showTitle") private var showTitle: Bool = true
    @AppStorage("fontSize") private var fontSize: Double = 14

    private var indicatorPosition: IndicatorPosition {
        IndicatorPosition(rawValue: indicatorPositionRaw) ?? .topRight
    }

    private var indicatorStyle: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorStyleRaw) ?? .iconAndText
    }

    public init(
        panel: CodePanel,
        onCodeChange: @escaping () -> Void = {}
    ) {
        self.panel = panel
        self.onCodeChange = onCodeChange
    }

    public var body: some View {
        VStack(spacing: 0) {
            if showTitle {
                titleBar
            }

            editorArea
        }
        .frame(minHeight: minPanelHeight)
        .background(Color.windowBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.windowBorder, lineWidth: 1)
        )
    }

    /// Line height matching TextEditor's default line spacing
    private var lineHeight: CGFloat {
        // Use the same NSFont for consistent line height calculation
        nsCodeFont.ascender - nsCodeFont.descender + nsCodeFont.leading
    }

    /// Minimum panel height based on content lines
    private var minPanelHeight: CGFloat {
        let lineCount = max(panel.code.components(separatedBy: "\n").count, 1)
        let editorPadding: CGFloat = 10 // top + bottom padding
        let titleBarHeight: CGFloat = showTitle ? 38 : 0
        return titleBarHeight + (CGFloat(lineCount) * lineHeight) + editorPadding
    }

    // MARK: - Title Bar

    private var titleBar: some View {
        HStack(spacing: 14) {
            // Traffic light placeholder
            Circle()
                .fill(Color.editorCloseButton)
                .frame(width: 12, height: 12)

            // Title
            Text(panel.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.titleText)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.titleBarBackground)
    }

    // MARK: - Editor Area

    private var editorArea: some View {
        ZStack(alignment: indicatorAlignment) {
            // Code editor with TextEditor for input
            codeInput

            // Indicator badge
            IndicatorBadgeView(
                type: panel.type,
                style: indicatorStyle,
                size: indicatorSize
            )
            .padding(12)
        }
    }

    /// NSFont for consistent rendering between Text and TextEditor
    private var nsCodeFont: NSFont {
        NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
    }

    /// Monospaced code font used for both line numbers and text editor
    private var codeFont: Font {
        Font(nsCodeFont)
    }

    private var codeInput: some View {
        HStack(alignment: .top, spacing: 0) {
            // Line numbers
            lineNumbersView

            // Text editor
            TextEditor(text: $panel.code)
                .font(codeFont)
                .scrollContentBackground(.hidden)
                .foregroundStyle(Color.editorText)
                .onChange(of: panel.code) { _, _ in
                    onCodeChange()
                }
                .padding(.top, 4)
        }
        .background(Color.editorBackground)
    }

    private var lineNumbersView: some View {
        let lines = max(panel.code.components(separatedBy: "\n").count, 1)

        return VStack(alignment: .trailing, spacing: 0) {
            ForEach(1 ... lines, id: \.self) { number in
                Text("\(number)")
                    .font(codeFont)
                    .foregroundStyle(Color.editorLineNumber)
                    .frame(height: lineHeight)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 4) // Match TextEditor's internal top inset
        .background(Color.editorGutter)
    }

    private var indicatorAlignment: Alignment {
        indicatorPosition == .topRight ? .topTrailing : .bottomTrailing
    }
}

// MARK: - Previews

#Preview("Do Panel") {
    let panel = CodePanel(type: .doPanel, title: "Do's")
    panel.code = """
    // Use descriptive variable names
    let userName = "Alice"
    let isLoggedIn = true

    // Handle errors gracefully
    do {
        try processData()
    } catch {
        logger.error(error)
    }
    """

    return CodePanelView(panel: panel)
        .frame(width: 400, height: 300)
        .padding()
        .background(Color(white: 0.1))
}

#Preview("Don't Panel") {
    let panel = CodePanel(type: .dontPanel, title: "Don'ts")
    panel.code = """
    // Avoid single-letter variables
    let x = "Bob"
    let y = false

    // Don't ignore errors
    try? processData()
    """

    return CodePanelView(panel: panel)
        .frame(width: 400, height: 300)
        .padding()
        .background(Color(white: 0.1))
}

#Preview("Panel - No Title Bar") {
    // Note: To preview without title bar, set UserDefaults["showTitle"] = false
    let panel = CodePanel(type: .doPanel, title: "Do's")
    panel.code = "let greeting = \"Hello, World!\""

    return CodePanelView(panel: panel)
        .frame(width: 400, height: 150)
        .padding()
        .background(Color(white: 0.1))
}
