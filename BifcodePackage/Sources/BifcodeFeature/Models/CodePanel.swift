//
//  CodePanel.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import CodeEditSourceEditor
import Foundation

/// The type of code panel, either "Do" (positive example) or "Don't" (negative example).
///
/// `PanelType` determines the visual appearance and default indicator settings
/// for a ``CodePanel``. Do panels typically display green checkmarks, while
/// Don't panels display red X marks.
///
/// ## Topics
///
/// ### Panel Types
///
/// - ``doPanel``
/// - ``dontPanel``
public enum PanelType: String, Sendable {
    /// A panel displaying positive code examples (best practices).
    ///
    /// Do panels show code that developers should follow. By default,
    /// they display a green checkmark indicator and "Do's" label.
    case doPanel = "do"

    /// A panel displaying negative code examples (anti-patterns).
    ///
    /// Don't panels show code that developers should avoid. By default,
    /// they display a red X indicator and "Don'ts" label.
    case dontPanel = "dont"
}

/// A model representing a single code editor panel with syntax highlighting.
///
/// `CodePanel` is the data model for a code editor in Bifcode. Each panel
/// contains the code content, display title, programming language for
/// syntax highlighting, and editor state (cursor position, scroll, etc.).
///
/// ## Overview
///
/// The app uses two `CodePanel` instances: one for "Do's" examples and one
/// for "Don'ts" examples. Both are managed by ``AppViewModel``.
///
/// ```swift
/// // Create a new panel
/// let panel = CodePanel(type: .doPanel, title: "Best Practices")
/// panel.code = "let userName = \"Alice\""
/// panel.language = .swift
///
/// // Access in a view
/// @Bindable var panel: CodePanel
/// Text(panel.code)
/// ```
///
/// ## Thread Safety
///
/// `CodePanel` is isolated to `@MainActor` and uses the `@Observable` macro
/// for reactive updates. It should only be accessed from the main thread.
///
/// ## Topics
///
/// ### Creating a Panel
///
/// - ``init(type:title:language:)``
///
/// ### Panel Properties
///
/// - ``id``
/// - ``type``
/// - ``code``
/// - ``title``
/// - ``language``
/// - ``editorState``
@MainActor
@Observable
public final class CodePanel: Identifiable {
    /// A unique identifier for the panel.
    ///
    /// Used by SwiftUI for efficient view updates when panels are
    /// displayed in lists or collections.
    public let id = UUID()

    /// The type of panel (Do or Don't).
    ///
    /// This determines the default indicator appearance and semantics
    /// of the code displayed.
    public let type: PanelType

    /// The source code content displayed in the editor.
    ///
    /// This is the user-editable code that receives syntax highlighting.
    /// The code is limited to 24 lines and 210 characters per line by
    /// ``CodeEditorView``.
    public var code: String = ""

    /// The display title shown in the panel's title bar.
    ///
    /// Titles are displayed with a document icon and support up to
    /// 70 characters. Longer titles are truncated with ellipsis.
    public var title: String

    /// The programming language used for syntax highlighting.
    ///
    /// Changing this property triggers the editor to re-render with
    /// the appropriate syntax highlighting rules. Supports 19+ languages
    /// via CodeEditLanguages.
    ///
    /// ```swift
    /// panel.language = .python  // Highlight as Python
    /// panel.language = .swift   // Highlight as Swift
    /// ```
    public var language: CodeLanguage

    /// The editor state containing cursor position, selection, and scroll.
    ///
    /// This state is managed by `SourceEditor` from CodeEditSourceEditor.
    /// It persists cursor position and selection between renders.
    public var editorState: SourceEditorState

    /// Creates a new code panel with the specified configuration.
    ///
    /// - Parameters:
    ///   - type: The panel type (Do or Don't).
    ///   - title: The display title. Defaults to empty string.
    ///   - language: The syntax highlighting language. Defaults to Swift.
    ///
    /// ```swift
    /// // Create a Swift "Do's" panel
    /// let doPanel = CodePanel(type: .doPanel, title: "Do's")
    ///
    /// // Create a Python "Don'ts" panel
    /// let dontPanel = CodePanel(
    ///     type: .dontPanel,
    ///     title: "Avoid This",
    ///     language: .python
    /// )
    /// ```
    public init(type: PanelType, title: String = "", language: CodeLanguage = .swift) {
        self.type = type
        self.title = title
        self.language = language
        editorState = SourceEditorState()
    }
}
