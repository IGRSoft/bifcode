//
//  ExportView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditSourceEditor
import SwiftUI

/// A container view arranging both code panels for image export.
///
/// `ExportView` arranges the Do and Don't ``ExportPanelView`` instances
/// either horizontally or vertically based on the layout setting. This view
/// is used exclusively for generating the export image—it's rendered
/// offscreen and captured as a bitmap.
///
/// ## Overview
///
/// The export view:
/// - Arranges panels based on ``WindowLayout`` (horizontal or vertical)
/// - Applies consistent padding (24pt) and spacing (24pt)
/// - Adds drop shadows to each panel
/// - Uses a transparent background for the final image
///
/// > Note: This is an internal view and not part of the public API.
/// > It's created by ``ContentView/renderExportViewToImage()`` during export.
struct ExportView: View {
    /// The "Do's" code panel to export.
    let doPanel: CodePanel

    /// The "Don'ts" code panel to export.
    let dontPanel: CodePanel

    /// The panel arrangement (horizontal or vertical).
    let layout: WindowLayout

    /// Position of the indicator badge.
    let indicatorPosition: IndicatorPosition

    /// Style of the indicator badge.
    let indicatorStyle: IndicatorStyle

    /// Size of the indicator badge in points.
    let indicatorSize: CGFloat

    /// SF Symbol name for the Do badge.
    let doIndicatorIcon: String

    /// SF Symbol name for the Don't badge.
    let dontIndicatorIcon: String

    /// Text label for the Do badge.
    let doIndicatorLabel: String

    /// Text label for the Don't badge.
    let dontIndicatorLabel: String

    /// Whether to show the title bar on panels.
    let showTitle: Bool

    /// Font size for code text.
    let fontSize: CGFloat

    /// The syntax highlighting theme.
    let theme: EditorTheme

    /// The current theme mode for window styling.
    let themeMode: ThemeMode

    // Panel dimensions for export

    /// Width of each panel in points.
    let panelWidth: CGFloat

    /// Height of the Do panel in points.
    let doPanelHeight: CGFloat

    /// Height of the Don't panel in points.
    let dontPanelHeight: CGFloat

    var body: some View {
        Group {
            if layout == .horizontal {
                HStack(alignment: .top, spacing: 24) {
                    panels
                }
            } else {
                VStack(spacing: 24) {
                    panels
                }
            }
        }
        .padding(24)
        .background(Color.clear)
    }

    @ViewBuilder
    private var panels: some View {
        ExportPanelView(
            panel: dontPanel,
            indicatorPosition: indicatorPosition,
            indicatorStyle: indicatorStyle,
            indicatorSize: indicatorSize,
            indicatorIconName: dontIndicatorIcon,
            indicatorLabel: dontIndicatorLabel,
            showTitle: showTitle,
            fontSize: fontSize,
            theme: theme,
            themeMode: themeMode
        )
        .frame(width: panelWidth, height: dontPanelHeight)
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)

        ExportPanelView(
            panel: doPanel,
            indicatorPosition: indicatorPosition,
            indicatorStyle: indicatorStyle,
            indicatorSize: indicatorSize,
            indicatorIconName: doIndicatorIcon,
            indicatorLabel: doIndicatorLabel,
            showTitle: showTitle,
            fontSize: fontSize,
            theme: theme,
            themeMode: themeMode
        )
        .frame(width: panelWidth, height: doPanelHeight)
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview("Export View - Horizontal") {
    let doPanel = CodePanel(type: .doPanel, title: "Do's")
    doPanel.code = """
    // Use descriptive names
    let userName = "Alice"
    """

    let dontPanel = CodePanel(type: .dontPanel, title: "Don'ts")
    dontPanel.code = """
    // Avoid short names
    let x = "Bob"
    """

    return ExportView(
        doPanel: doPanel,
        dontPanel: dontPanel,
        layout: .horizontal,
        indicatorPosition: .topRight,
        indicatorStyle: .iconAndText,
        indicatorSize: 48,
        doIndicatorIcon: "checkmark",
        dontIndicatorIcon: "xmark",
        doIndicatorLabel: "Do's",
        dontIndicatorLabel: "Don'ts",
        showTitle: true,
        fontSize: 14,
        theme: .atomOneDark,
        themeMode: .dark,
        panelWidth: 350,
        doPanelHeight: 120,
        dontPanelHeight: 120
    )
    .frame(width: 800, height: 300)
}

#Preview("Export View - Vertical") {
    let doPanel = CodePanel(type: .doPanel, title: "Do's")
    doPanel.code = """
    // Use descriptive names
    let userName = "Alice"
    """

    let dontPanel = CodePanel(type: .dontPanel, title: "Don'ts")
    dontPanel.code = """
    // Avoid short names
    let x = "Bob"
    """

    return ExportView(
        doPanel: doPanel,
        dontPanel: dontPanel,
        layout: .vertical,
        indicatorPosition: .topRight,
        indicatorStyle: .iconAndText,
        indicatorSize: 48,
        doIndicatorIcon: "checkmark",
        dontIndicatorIcon: "xmark",
        doIndicatorLabel: "Do's",
        dontIndicatorLabel: "Don'ts",
        showTitle: true,
        fontSize: 14,
        theme: .atomOneDark,
        themeMode: .dark,
        panelWidth: 400,
        doPanelHeight: 120,
        dontPanelHeight: 120
    )
    .frame(width: 500, height: 500)
}
