import Foundation

/// Indicator position options
public enum IndicatorPosition: String, CaseIterable, Sendable {
    case topRight = "top-right"
    case bottomRight = "bottom-right"

    public var label: String {
        switch self {
        case .topRight: "Top Right"
        case .bottomRight: "Bottom Right"
        }
    }
}

/// Indicator style options
public enum IndicatorStyle: String, CaseIterable, Sendable {
    case iconOnly = "icon"
    case textOnly = "text"
    case iconAndText = "both"

    public var label: String {
        switch self {
        case .iconOnly: "Icon Only"
        case .textOnly: "Text Only"
        case .iconAndText: "Icon + Text"
        }
    }
}

/// Window layout options
public enum WindowLayout: String, CaseIterable, Sendable {
    case horizontal
    case vertical

    public var label: String {
        switch self {
        case .horizontal: "Side by Side"
        case .vertical: "Stacked"
        }
    }
}
