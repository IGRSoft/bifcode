import Foundation
import SwiftUI

/// Indicator position options
public enum IndicatorPosition: String, CaseIterable, Sendable {
    case topRight = "top-right"
    case bottomLeft = "bottom-left"

    public var label: String {
        switch self {
        case .topRight: "Top Right"
        case .bottomLeft: "Bottom Left"
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

/// Application settings with persistence
@MainActor
@Observable
public final class AppSettings {
    // MARK: - Indicator Settings

    public var indicatorPosition: IndicatorPosition = .topRight
    public var indicatorStyle: IndicatorStyle = .iconAndText
    public var indicatorSize: CGFloat = 48
    public var showTitle: Bool = true

    // MARK: - Editor Settings

    public var fontSize: CGFloat = 14
    public var windowLayout: WindowLayout = .horizontal
    public var doTitle: String = "Do's"
    public var dontTitle: String = "Don'ts"

    // MARK: - Export Settings

    public var saveLocation: URL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    public var watermarkText: String = "bifcode"
    public var showWatermark: Bool = true

    // MARK: - Initialization

    public init() {
        loadFromUserDefaults()
    }

    // MARK: - Persistence

    private func loadFromUserDefaults() {
        let defaults = UserDefaults.standard

        if let position = defaults.string(forKey: "indicatorPosition"),
           let value = IndicatorPosition(rawValue: position)
        {
            indicatorPosition = value
        }

        if let style = defaults.string(forKey: "indicatorStyle"),
           let value = IndicatorStyle(rawValue: style)
        {
            indicatorStyle = value
        }

        indicatorSize = defaults.double(forKey: "indicatorSize").nonZero ?? 48
        showTitle = defaults.object(forKey: "showTitle") as? Bool ?? true
        fontSize = defaults.double(forKey: "fontSize").nonZero ?? 14

        if let layout = defaults.string(forKey: "windowLayout"),
           let value = WindowLayout(rawValue: layout)
        {
            windowLayout = value
        }

        doTitle = defaults.string(forKey: "doTitle") ?? "Do's"
        dontTitle = defaults.string(forKey: "dontTitle") ?? "Don'ts"

        if let path = defaults.string(forKey: "saveLocation"),
           let url = URL(string: path)
        {
            saveLocation = url
        }

        watermarkText = defaults.string(forKey: "watermarkText") ?? "bifcode"
        showWatermark = defaults.object(forKey: "showWatermark") as? Bool ?? true
    }

    public func save() {
        let defaults = UserDefaults.standard

        defaults.set(indicatorPosition.rawValue, forKey: "indicatorPosition")
        defaults.set(indicatorStyle.rawValue, forKey: "indicatorStyle")
        defaults.set(indicatorSize, forKey: "indicatorSize")
        defaults.set(showTitle, forKey: "showTitle")
        defaults.set(fontSize, forKey: "fontSize")
        defaults.set(windowLayout.rawValue, forKey: "windowLayout")
        defaults.set(doTitle, forKey: "doTitle")
        defaults.set(dontTitle, forKey: "dontTitle")
        defaults.set(saveLocation.absoluteString, forKey: "saveLocation")
        defaults.set(watermarkText, forKey: "watermarkText")
        defaults.set(showWatermark, forKey: "showWatermark")
    }
}

// MARK: - Helpers

private extension Double {
    var nonZero: Double? {
        self > 0 ? self : nil
    }
}
