//
//  CodeEditorView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditLanguages
import CodeEditSourceEditor
import SwiftUI

/// A complete code editor panel with title bar, syntax highlighting editor, and Do/Don't indicator
public struct CodeEditorView: View {
    @Bindable var panel: CodePanel
    let onCodeChange: () -> Void

    // MARK: - Settings (via @AppStorage)

    @AppStorage("indicatorPosition") private var indicatorPositionRaw: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyleRaw: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("showTitle") private var showTitle: Bool = true
    @AppStorage("fontSize") private var fontSize: Double = 14
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = EditorThemeOption.atomOneDark.rawValue

    private var indicatorPosition: IndicatorPosition {
        IndicatorPosition(rawValue: indicatorPositionRaw) ?? .topRight
    }

    private var indicatorStyle: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorStyleRaw) ?? .iconAndText
    }

    private var selectedTheme: EditorThemeOption {
        EditorThemeOption(rawValue: selectedThemeRaw) ?? .atomOneDark
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
                    .zIndex(2)
            }

            editorArea
                .zIndex(1)
        }
        .frame(minHeight: minPanelHeight)
        .background(Color(nsColor: selectedTheme.editorTheme.background))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.windowBorder, lineWidth: 1)
        )
    }

    /// Line height matching the editor's font
    private var lineHeight: CGFloat {
        let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        return font.ascender - font.descender + font.leading
    }

    /// Minimum panel height based on content lines
    private var minPanelHeight: CGFloat {
        let lineCount = max(panel.code.components(separatedBy: "\n").count, 1)
        let editorPadding: CGFloat = 10
        let titleBarHeight: CGFloat = showTitle ? 38 : 0
        return titleBarHeight + (CGFloat(lineCount) * lineHeight) + editorPadding
    }

    // MARK: - Title Bar

    private var titleBar: some View {
        HStack(spacing: 14) {
            // Traffic light placeholder
            Circle()
                .fill(Color.editorCloseButton)
                .frame(width: 14, height: 14)

            // Title
            Label(panel.title, systemImage: "text.document.fill")
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
            // Code editor using CodeEditSourceEditor
            sourceEditor

            // Indicator badge
            IndicatorBadgeView(
                type: panel.type,
                style: indicatorStyle,
                size: indicatorSize
            )
            .padding(12)
        }
    }

    private var sourceEditor: some View {
        SourceEditor(
            $panel.code,
            language: panel.language,
            configuration: editorConfiguration,
            state: $panel.editorState
        )
        .onChange(of: panel.code) { _, _ in
            onCodeChange()
        }
    }

    private var editorConfiguration: SourceEditorConfiguration {
        SourceEditorConfiguration(
            appearance: .init(
                theme: selectedTheme.editorTheme,
                font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular),
                wrapLines: false
            ),
            peripherals: .init(showMinimap: false, showFoldingRibbon: false)
        )
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

    return CodeEditorView(panel: panel)
        .frame(width: 400, height: 300)
        .padding()
        .background(Color.contentBackground)
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

    return CodeEditorView(panel: panel)
        .frame(width: 400, height: 300)
        .padding()
        .background(Color.contentBackground)
}

#Preview("Panel - No Title Bar") {
    let panel = CodePanel(type: .doPanel, title: "Do's")
    panel.code = "let greeting = \"Hello, World!\""

    return CodeEditorView(panel: panel)
        .frame(width: 400, height: 150)
        .padding()
        .background(Color.contentBackground)
}
