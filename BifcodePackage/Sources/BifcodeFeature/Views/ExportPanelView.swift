//
//  ExportPanelView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditLanguages
import CodeEditSourceEditor
import SwiftUI

/// Static code panel view for ImageRenderer export
/// Uses SourceEditor with same settings as CodeEditorView for consistent rendering
struct ExportPanelView: View {
    @Bindable var panel: CodePanel
    let indicatorPosition: IndicatorPosition
    let indicatorStyle: IndicatorStyle
    let indicatorSize: CGFloat
    let indicatorIconName: String
    let indicatorLabel: String
    let showTitle: Bool
    let fontSize: CGFloat
    let theme: EditorTheme

    /// Editor state for the source editor
    @State private var editorState = SourceEditorState()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            if showTitle {
                titleBar
            }

            editorArea
        }
        .background(Color(nsColor: theme.background))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.windowBorder, lineWidth: 1)
        )
    }

    // MARK: - Title Bar

    private var titleBar: some View {
        HStack(spacing: 14) {
            // Traffic light placeholder
            Circle()
                .fill(Color.editorCloseButton)
                .frame(width: 14, height: 14)

            // Title - single line with truncation
            Label(panel.title, systemImage: "text.document.fill")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.titleText)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.titleBarBackground)
    }

    // MARK: - Editor Area

    private var editorArea: some View {
        ZStack(alignment: indicatorAlignment) {
            // Code editor using CodeEditSourceEditor with same settings
            sourceEditor

            // Indicator badge
            IndicatorBadgeView(
                type: panel.type,
                style: indicatorStyle,
                size: indicatorSize,
                iconName: indicatorIconName,
                label: indicatorLabel
            )
            .padding(12)
        }
    }

    /// Unique identifier for forcing editor recreation when language or theme changes
    private var editorIdentifier: String {
        "\(panel.id)-\(panel.language.id)-export"
    }

    private var sourceEditor: some View {
        SourceEditor(
            $panel.code,
            language: panel.language,
            configuration: editorConfiguration,
            state: $editorState
        )
        .id(editorIdentifier)
        .disabled(true) // Make non-interactive for export
    }

    private var editorConfiguration: SourceEditorConfiguration {
        SourceEditorConfiguration(
            appearance: .init(
                theme: theme,
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

// MARK: - Preview

#Preview("Export Panel - Do") {
    let panel = CodePanel(type: .doPanel, title: "Do's")
    panel.code = """
    // Use descriptive variable names
    let userName = "Alice"
    let isLoggedIn = true
    """

    return ExportPanelView(
        panel: panel,
        indicatorPosition: .topRight,
        indicatorStyle: .iconAndText,
        indicatorSize: 48,
        indicatorIconName: "checkmark",
        indicatorLabel: "Do's",
        showTitle: true,
        fontSize: 14,
        theme: .atomOneDark
    )
    .frame(width: 400, height: 200)
    .padding()
    .background(Color.contentBackground)
}

#Preview("Export Panel - Don't") {
    let panel = CodePanel(type: .dontPanel, title: "Don'ts")
    panel.code = """
    // Avoid single-letter variables
    let x = "Bob"
    let y = false
    """

    return ExportPanelView(
        panel: panel,
        indicatorPosition: .topRight,
        indicatorStyle: .iconAndText,
        indicatorSize: 48,
        indicatorIconName: "xmark",
        indicatorLabel: "Don'ts",
        showTitle: true,
        fontSize: 14,
        theme: .atomOneDark
    )
    .frame(width: 400, height: 200)
    .padding()
    .background(Color.contentBackground)
}
