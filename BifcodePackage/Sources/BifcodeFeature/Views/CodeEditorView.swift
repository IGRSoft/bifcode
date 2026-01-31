//
//  CodeEditorView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditLanguages
import CodeEditSourceEditor
import SwiftUI

/// A complete code editor panel with title bar, syntax highlighting, and indicator badge.
///
/// `CodeEditorView` is the main interactive component for editing code in Bifcode.
/// It combines a title bar, CodeEditSourceEditor for syntax highlighting, and an
/// ``IndicatorBadgeView`` to show the "Do" or "Don't" designation.
///
/// ## Overview
///
/// Each panel consists of three visual layers:
/// 1. **Title Bar** - Shows the panel title with a document icon
/// 2. **Code Editor** - Syntax-highlighted code using `SourceEditor`
/// 3. **Indicator Badge** - Positioned "Do" or "Don't" badge
///
/// ## Code Limits
///
/// The editor enforces limits to ensure exported images remain readable:
/// - Maximum 24 lines of code
/// - Maximum 210 characters per line
///
/// ## Settings Integration
///
/// The view reads settings directly from `@AppStorage`:
/// - Indicator position, style, size, icons, and labels
/// - Font size and theme
/// - Title visibility
///
/// ## Usage
///
/// ```swift
/// @Bindable var panel: CodePanel
///
/// CodeEditorView(panel: panel) {
///     // Called when code changes
///     print("Code updated: \(panel.code)")
/// }
/// ```
///
/// ## Topics
///
/// ### Creating an Editor
///
/// - ``init(panel:onCodeChange:)``
///
/// ### Related Types
///
/// - ``CodePanel``
/// - ``IndicatorBadgeView``
public struct CodeEditorView: View {
    /// The code panel model containing the code, title, and language.
    @Bindable var panel: CodePanel
    
    /// Callback invoked when the code content changes.
    let onCodeChange: () -> Void
    
    // MARK: - Settings (via @AppStorage)
    
    @AppStorage("indicatorPosition") private var indicatorPositionRaw: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyleRaw: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("doIndicatorIcon") private var doIndicatorIcon: String = "checkmark"
    @AppStorage("dontIndicatorIcon") private var dontIndicatorIcon: String = "xmark"
    @AppStorage("doIndicatorLabel") private var doIndicatorLabel: String = "Do's"
    @AppStorage("dontIndicatorLabel") private var dontIndicatorLabel: String = "Don'ts"
    @AppStorage("showTitle") private var showTitle: Bool = true
    @AppStorage("showLineNumbers") private var showLineNumbers: Bool = true
    @AppStorage("fontSize") private var fontSize: Double = 14
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = EditorThemeOption.atomOneDark.rawValue
    @AppStorage("themeMode") private var themeModeRaw: String = ThemeMode.dark.rawValue
    
    private var indicatorPosition: IndicatorPosition {
        IndicatorPosition(rawValue: indicatorPositionRaw) ?? .topRight
    }
    
    private var indicatorStyle: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorStyleRaw) ?? .iconAndText
    }
    
    private var selectedTheme: EditorThemeOption {
        EditorThemeOption(rawValue: selectedThemeRaw) ?? .atomOneDark
    }
    
    private var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeRaw) ?? .dark
    }
    
    /// Creates a new code editor view for the specified panel.
    ///
    /// - Parameters:
    ///   - panel: The ``CodePanel`` model to display and edit.
    ///   - onCodeChange: A closure called whenever the code content changes.
    ///     Defaults to an empty closure.
    ///
    /// ```swift
    /// CodeEditorView(panel: viewModel.doPanel) {
    ///     updateExportPreview()
    /// }
    /// ```
    public init(
        panel: CodePanel,
        onCodeChange: @escaping () -> Void = {}
    ) {
        self.panel = panel
        self.onCodeChange = onCodeChange
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if showTitle {
                titleBar
                    .zIndex(2)
            }
            
            editorArea
                .zIndex(1)
        }
        .frame(minHeight: minPanelHeight)
        .background(Color(nsColor: selectedTheme.editorTheme.background))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.windowBorder(for: themeMode), lineWidth: 1)
        )
    }
    
    /// Line height matching the editor's font
    private var lineHeight: CGFloat {
        let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        return font.ascender - font.descender + font.leading
    }
    
    /// Minimum panel height based on content lines
    /// Uses minimum of 5 lines to prevent broken views with 1-4 lines
    private var minPanelHeight: CGFloat {
        let minLineCount = 5
        let lineCount = max(panel.code.components(separatedBy: "\n").count, minLineCount)
        let editorPadding: CGFloat = 10
        let titleBarHeight: CGFloat = showTitle ? 38 : 0
        return titleBarHeight + (CGFloat(lineCount) * lineHeight) + editorPadding
    }
    
    // MARK: - Title Bar
    
    private var titleBar: some View {
        HStack(spacing: 14) {
            // Traffic light placeholder
            Circle()
                .fill(Color.editorCloseButton(for: themeMode))
                .frame(width: 14, height: 14)
            
            // Title - single line with truncation
            Label(panel.title, systemImage: "text.document.fill")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.titleText(for: themeMode))
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color.titleBarBackground(for: themeMode))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(panel.title) panel header")
    }
    
    // MARK: - Editor Area
    
    private var editorArea: some View {
        ZStack(alignment: indicatorAlignment) {
            // Code editor using CodeEditSourceEditor
            sourceEditor
            
            // Indicator badge
            IndicatorBadgeView(
                type: panel.type,
                style: indicatorStyle,
                size: indicatorSize,
                iconName: panel.type == .doPanel ? doIndicatorIcon : dontIndicatorIcon,
                label: panel.type == .doPanel ? doIndicatorLabel : dontIndicatorLabel
            )
            .padding(12)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(panel.type == .doPanel ? "Do" : "Don't") code editor")
    }
    
    // MARK: - Code Limits
    
    /// Maximum characters per line
    private static let maxLineLength = 210
    
    /// Maximum number of lines
    private static let maxLineCount = 24
    
    /// Applies line length and line count limits to the code
    private func applyCodeLimits() {
        var lines = panel.code.components(separatedBy: "\n")
        
        // Limit number of lines
        if lines.count > Self.maxLineCount {
            lines = Array(lines.prefix(Self.maxLineCount))
        }
        
        // Limit line length
        lines = lines.map { line in
            if line.count > Self.maxLineLength {
                return String(line.prefix(Self.maxLineLength))
            }
            return line
        }
        
        let limitedCode = lines.joined(separator: "\n")
        if limitedCode != panel.code {
            panel.code = limitedCode
        }
    }
    
    /// Unique identifier for forcing editor recreation when language, theme, font, or line numbers change
    private var editorIdentifier: String {
        "\(panel.id)-\(panel.language.id)-\(selectedThemeRaw)-\(Int(fontSize))-\(showLineNumbers)"
    }
    
    /// Tracks if initial appearance has occurred to force editor recreation
    @State private var hasAppeared = false
    
    private var sourceEditor: some View {
        SourceEditor(
            $panel.code,
            language: panel.language,
            configuration: editorConfiguration,
            state: $panel.editorState
        )
        .id(hasAppeared ? editorIdentifier : "initial")
        .onAppear {
            // Force recreation after initial appearance to apply stored settings
            if !hasAppeared {
                DispatchQueue.main.async {
                    hasAppeared = true
                }
            }
        }
        .onChange(of: panel.code) { _, _ in
            applyCodeLimits()
            onCodeChange()
        }
    }
    
    private var editorConfiguration: SourceEditorConfiguration {
        SourceEditorConfiguration(
            appearance: .init(
                theme: selectedTheme.editorTheme,
                font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular),
                wrapLines: false
            ),
            peripherals: .init(
                showGutter: showLineNumbers,
                showMinimap: false,
                showFoldingRibbon: false
            )
        )
    }
    
    private var indicatorAlignment: Alignment {
        indicatorPosition == .topRight ? .topTrailing : .bottomTrailing
    }
}

// MARK: - Previews

#Preview("Do Panel") {
    let panel = CodePanel(type: .doPanel, title: "Do's")
    panel.code = """
    // Use descriptive variable names
    let userName = "Alice"
    let isLoggedIn = true
    
    // Handle errors gracefully
    do {
        try processData()
    } catch {
        logger.error(error)
    }
    """
    
    return CodeEditorView(panel: panel)
        .frame(width: 400, height: 300)
        .padding()
        .background(Color.contentBackground)
}

#Preview("Don't Panel") {
    let panel = CodePanel(type: .dontPanel, title: "Don'ts")
    panel.code = """
    // Avoid single-letter variables
    let x = "Bob"
    let y = false
    
    // Don't ignore errors
    try? processData()
    """
    
    return CodeEditorView(panel: panel)
        .frame(width: 400, height: 300)
        .padding()
        .background(Color.contentBackground)
}

#Preview("Panel - No Title Bar") {
    let panel = CodePanel(type: .doPanel, title: "Do's")
    panel.code = "let greeting = \"Hello, World!\""
    
    return CodeEditorView(panel: panel)
        .frame(width: 400, height: 150)
        .padding()
        .background(Color.contentBackground)
}
