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

/// A static, non-interactive code panel for export rendering.
///
/// `ExportPanelView` renders a single code panel with syntax highlighting
/// and indicator badge for image export. Unlike ``CodeEditorView``, this
/// view is disabled (non-interactive) and designed for offscreen rendering.
///
/// ## Overview
///
/// The export panel maintains visual consistency with the interactive
/// ``CodeEditorView`` by using the same:
/// - `SourceEditor` configuration
/// - Title bar styling
/// - Indicator badge positioning
/// - Color theming
///
/// ## Differences from CodeEditorView
///
/// | Aspect | CodeEditorView | ExportPanelView |
/// |--------|---------------|-----------------|
/// | Interactive | Yes | No (disabled) |
/// | @AppStorage | Reads settings | Receives as params |
/// | Editor state | Shared | Local |
/// | Purpose | User editing | Image export |
///
/// > Note: This is an internal view and not part of the public API.
struct ExportPanelView: View {
    /// The code panel to render.
    @Bindable var panel: CodePanel

    /// Position of the indicator badge.
    let indicatorPosition: IndicatorPosition

    /// Style of the indicator badge.
    let indicatorStyle: IndicatorStyle

    /// Size of the indicator badge in points.
    let indicatorSize: CGFloat

    /// SF Symbol name for the indicator icon.
    let indicatorIconName: String

    /// Text label for the indicator.
    let indicatorLabel: String

    /// Whether to show the title bar.
    let showTitle: Bool

    /// Font size for code text.
    let fontSize: CGFloat

    /// The syntax highlighting theme.
    let theme: EditorTheme

    /// The current theme mode for window styling.
    let themeMode: ThemeMode

    /// Local editor state (not shared with interactive editor).
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
                .stroke(Color.windowBorder(for: themeMode), lineWidth: 1)
        )
    }

    // MARK: - Title Bar

    private var titleBar: some View {
        HStack(spacing: 14) {
            // Traffic light placeholder
            Circle()
                .fill(Color.editorCloseButton(for: themeMode))
                .frame(width: 14, height: 14)

            // Title - single line with truncation
            Label(panel.title, systemImage: "text.document.fill")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.titleText(for: themeMode))
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.titleBarBackground(for: themeMode))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(panel.title) panel header")
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(panel.type == .doPanel ? "Do" : "Don't") code panel")
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
        theme: .atomOneDark,
        themeMode: .dark
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
        theme: .atomOneDark,
        themeMode: .dark
    )
    .frame(width: 400, height: 200)
    .padding()
    .background(Color.contentBackground)
}
