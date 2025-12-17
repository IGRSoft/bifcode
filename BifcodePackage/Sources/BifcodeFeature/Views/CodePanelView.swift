import HighlightSwift
import SwiftUI

/// A complete code panel with title bar, editor, and indicator
public struct CodePanelView: View {
    @Bindable var panel: CodePanel
    let settings: AppSettings
    let onCodeChange: () -> Void

    public init(
        panel: CodePanel,
        settings: AppSettings,
        onCodeChange: @escaping () -> Void = {}
    ) {
        self.panel = panel
        self.settings = settings
        self.onCodeChange = onCodeChange
    }

    public var body: some View {
        VStack(spacing: 0) {
            if settings.showTitle {
                titleBar
            }

            editorArea
        }
        .background(Color.windowBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.windowBorder, lineWidth: 1)
        )
    }

    // MARK: - Title Bar

    private var titleBar: some View {
        HStack {
            // Traffic light placeholder
            Circle()
                .fill(panel.type == .doPanel ? Color.indicatorDo : Color.indicatorDont)
                .frame(width: 12, height: 12)

            // File icon
            Image(systemName: "swift")
                .font(.system(size: 14))
                .foregroundStyle(Color.titleText.opacity(0.7))

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
                style: settings.indicatorStyle,
                size: settings.indicatorSize
            )
            .padding(12)
        }
    }

    private var codeInput: some View {
        HStack(alignment: .top, spacing: 0) {
            // Line numbers
            lineNumbersView

            // Text editor
            TextEditor(text: $panel.code)
                .font(.system(size: settings.fontSize, design: .monospaced))
                .scrollContentBackground(.hidden)
                .foregroundStyle(Color.editorText)
                .padding(8)
                .onChange(of: panel.code) { _, _ in
                    onCodeChange()
                }
        }
        .background(Color.editorBackground)
    }

    private var lineNumbersView: some View {
        let lines = max(panel.code.components(separatedBy: "\n").count, 10)

        return VStack(alignment: .trailing, spacing: 0) {
            ForEach(1 ... lines, id: \.self) { number in
                Text("\(number)")
                    .font(.system(size: settings.fontSize, design: .monospaced))
                    .foregroundStyle(Color.editorLineNumber)
                    .frame(height: settings.fontSize * 1.5)
            }
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .background(Color.editorGutter)
    }

    private var indicatorAlignment: Alignment {
        settings.indicatorPosition == .topRight ? .topTrailing : .bottomLeading
    }
}
