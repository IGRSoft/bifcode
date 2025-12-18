//
//  IndicatorBadgeView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import SwiftUI

/// A visual badge indicating whether a code panel shows "Do" or "Don't" examples.
///
/// `IndicatorBadgeView` displays an icon, text label, or both to clearly mark
/// code panels as positive (Do) or negative (Don't) examples. The badge uses
/// semantic colors from the app's color system.
///
/// ## Overview
///
/// The badge appearance is controlled by three main factors:
/// - **Type** - Determines color (green for Do, red for Don't)
/// - **Style** - Shows icon only, text only, or both
/// - **Size** - Controls overall badge dimensions
///
/// ## Sizing
///
/// Badge elements scale proportionally to the `size` parameter:
/// - Icon: 60% of size
/// - Text: 30% of size
///
/// ## Usage
///
/// ```swift
/// // Icon and text badge for "Do" panel
/// IndicatorBadgeView(
///     type: .doPanel,
///     style: .iconAndText,
///     size: 48
/// )
///
/// // Custom icon badge for "Don't" panel
/// IndicatorBadgeView(
///     type: .dontPanel,
///     style: .iconOnly,
///     size: 64,
///     iconName: "exclamationmark.triangle"
/// )
/// ```
///
/// ## Topics
///
/// ### Creating a Badge
///
/// - ``init(type:style:size:iconName:label:)``
///
/// ### Related Types
///
/// - ``PanelType``
/// - ``IndicatorStyle``
/// - ``IndicatorIcon``
public struct IndicatorBadgeView: View {
    /// The panel type determining the badge color (Do = green, Don't = red).
    let type: PanelType

    /// The display style controlling which elements are shown.
    let style: IndicatorStyle

    /// The overall size of the badge in points.
    let size: CGFloat

    /// The SF Symbol name for the icon.
    let iconName: String

    /// The text label displayed below the icon.
    let label: String

    /// Creates a new indicator badge with the specified configuration.
    ///
    /// - Parameters:
    ///   - type: The panel type (Do or Don't) determining the badge color.
    ///   - style: The display style (icon only, text only, or both).
    ///   - size: The overall badge size in points.
    ///   - iconName: The SF Symbol name. Defaults to "checkmark" for Do,
    ///     "xmark" for Don't.
    ///   - label: The text label. Defaults to "Do's" or "Don'ts".
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
