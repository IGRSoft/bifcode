//
//  IndicatorBadgeView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI

/// Do/Don't indicator badge
public struct IndicatorBadgeView: View {
    let type: PanelType
    let style: IndicatorStyle
    let size: CGFloat
    let iconName: String
    let label: String

    public init(
        type: PanelType,
        style: IndicatorStyle,
        size: CGFloat,
        iconName: String? = nil,
        label: String? = nil
    ) {
        self.type = type
        self.style = style
        self.size = size
        self.iconName = iconName ?? (type == .doPanel ? "checkmark" : "xmark")
        self.label = label ?? (type == .doPanel ? "Do's" : "Don'ts")
    }

    private var color: Color {
        type == .doPanel ? .indicatorDo : .indicatorDont
    }

    public var body: some View {
        VStack(spacing: 4) {
            if style != .textOnly {
                iconView
            }

            if style != .iconOnly {
                textView
            }
        }
    }

    private var iconView: some View {
        Image(systemName: iconName)
            .font(.system(size: size * 0.6, weight: .bold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
    }

    private var textView: some View {
        Text(label)
            .font(.system(size: size * 0.3, weight: .semibold, design: .rounded))
            .foregroundStyle(color)
    }
}

// MARK: - Previews

#Preview("Indicator Styles") {
    VStack(spacing: 24) {
        // Do Panel variants
        HStack(spacing: 32) {
            IndicatorBadgeView(type: .doPanel, style: .iconOnly, size: 48)
            IndicatorBadgeView(type: .doPanel, style: .textOnly, size: 48)
            IndicatorBadgeView(type: .doPanel, style: .iconAndText, size: 48)
        }

        // Don't Panel variants
        HStack(spacing: 32) {
            IndicatorBadgeView(type: .dontPanel, style: .iconOnly, size: 48)
            IndicatorBadgeView(type: .dontPanel, style: .textOnly, size: 48)
            IndicatorBadgeView(type: .dontPanel, style: .iconAndText, size: 48)
        }
    }
    .padding(32)
    .background(Color.editorBackground)
}

#Preview("Do Indicator - Large") {
    IndicatorBadgeView(type: .doPanel, style: .iconAndText, size: 80)
        .padding(32)
        .background(Color.editorBackground)
}

#Preview("Don't Indicator - Large") {
    IndicatorBadgeView(type: .dontPanel, style: .iconAndText, size: 80)
        .padding(32)
        .background(Color.editorBackground)
}
