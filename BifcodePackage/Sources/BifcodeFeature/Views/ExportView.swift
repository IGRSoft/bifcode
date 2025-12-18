//
//  ExportView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditSourceEditor
import SwiftUI

/// Combined export view with both panels for ImageRenderer
/// This view is used exclusively for generating the export image
struct ExportView: View {
    let doPanel: CodePanel
    let dontPanel: CodePanel
    let layout: WindowLayout
    let indicatorPosition: IndicatorPosition
    let indicatorStyle: IndicatorStyle
    let indicatorSize: CGFloat
    let doIndicatorIcon: String
    let dontIndicatorIcon: String
    let doIndicatorLabel: String
    let dontIndicatorLabel: String
    let showTitle: Bool
    let fontSize: CGFloat
    let theme: EditorTheme

    var body: some View {
        Group {
            if layout == .horizontal {
                HStack(spacing: 24) {
                    panels
                }
            } else {
                VStack(spacing: 24) {
                    panels
                }
            }
        }
        .padding(24)
        .background(Color.contentBackground)
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
            theme: theme
        )
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
            theme: theme
        )
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
        theme: .atomOneDark
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
        theme: .atomOneDark
    )
    .frame(width: 500, height: 500)
}
