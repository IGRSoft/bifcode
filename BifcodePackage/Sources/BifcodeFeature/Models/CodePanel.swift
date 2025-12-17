import CodeEditLanguages
import CodeEditSourceEditor
import Foundation

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

    /// The language to use for highlighting
    public var language: CodeLanguage

    /// Editor state for cursor position, scroll, etc.
    public var editorState: SourceEditorState

    public init(type: PanelType, title: String, language: CodeLanguage = .swift) {
        self.type = type
        self.title = title
        self.language = language
        editorState = SourceEditorState()
    }
}
