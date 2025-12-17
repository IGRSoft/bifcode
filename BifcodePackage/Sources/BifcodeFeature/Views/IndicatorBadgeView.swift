import SwiftUI

/// Do/Don't indicator badge
public struct IndicatorBadgeView: View {
    let type: PanelType
    let style: IndicatorStyle
    let size: CGFloat

    public init(type: PanelType, style: IndicatorStyle, size: CGFloat) {
        self.type = type
        self.style = style
        self.size = size
    }

    private var color: Color {
        type == .doPanel ? .indicatorDo : .indicatorDont
    }

    private var iconName: String {
        type == .doPanel ? "checkmark" : "xmark"
    }

    private var label: String {
        type == .doPanel ? "Do's" : "Don'ts"
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
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.15)
                .stroke(color, lineWidth: 3)
                .frame(width: size, height: size)

            Image(systemName: iconName)
                .font(.system(size: size * 0.5, weight: .bold))
                .foregroundStyle(color)
        }
    }

    private var textView: some View {
        Text(label)
            .font(.system(size: size * 0.3, weight: .semibold, design: .rounded))
            .foregroundStyle(color)
    }
}
