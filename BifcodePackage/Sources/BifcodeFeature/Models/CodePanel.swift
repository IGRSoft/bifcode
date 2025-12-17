import Foundation
import HighlightSwift

/// Represents a code panel (Do or Don't)
public enum PanelType: String, Sendable {
    case doPanel = "do"
    case dontPanel = "dont"
}

/// Model for a code editor panel
@MainActor
@Observable
public final class CodePanel: Identifiable {
    public let id = UUID()
    public let type: PanelType

    public var code: String = ""
    public var title: String

    /// The language to use for highlighting (selected overrides detected)
    public var language: HighlightLanguage?

    public init(type: PanelType, title: String) {
        self.type = type
        self.title = title
    }
}
