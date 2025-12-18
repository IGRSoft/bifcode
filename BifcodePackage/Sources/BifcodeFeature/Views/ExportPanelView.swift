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

/// Static code panel view optimized for ImageRenderer export
/// Uses Text instead of SourceEditor for pure SwiftUI rendering
struct ExportPanelView: View {
    let panel: CodePanel
    let indicatorPosition: IndicatorPosition
    let indicatorStyle: IndicatorStyle
    let indicatorSize: CGFloat
    let indicatorIconName: String
    let indicatorLabel: String
    let showTitle: Bool
    let fontSize: CGFloat
    let theme: EditorTheme

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
            // Static code display
            codeContent
                .padding(10)

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

    private var codeContent: some View {
        HStack(alignment: .top, spacing: 0) {
            // Line numbers
            lineNumbers
                .padding(.trailing, 8)

            // Code text with syntax highlighting colors from theme
            Text(panel.code)
                .font(.system(size: fontSize, design: .monospaced))
                .foregroundStyle(Color(nsColor: theme.text.color))
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
    }

    private var lineNumbers: some View {
        let lines = panel.code.components(separatedBy: "\n")
        let maxDigits = String(lines.count).count

        return VStack(alignment: .trailing, spacing: 0) {
            ForEach(1 ... max(lines.count, 1), id: \.self) { number in
                Text(String(format: "%\(maxDigits)d", number))
                    .font(.system(size: fontSize, design: .monospaced))
                    .foregroundStyle(Color(nsColor: theme.invisibles.color))
            }
        }
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
    .frame(width: 400)
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
    .frame(width: 400)
    .padding()
    .background(Color.contentBackground)
}
