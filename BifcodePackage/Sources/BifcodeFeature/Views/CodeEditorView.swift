import HighlightSwift
import SwiftUI

/// Code editor with line numbers and syntax highlighting
public struct CodeEditorView: View {
    @Binding var code: String
    let language: HighlightLanguage?
    let fontSize: CGFloat
    let showLineNumbers: Bool

    @State private var lineCount: Int = 1

    public init(
        code: Binding<String>,
        language: HighlightLanguage? = nil,
        fontSize: CGFloat = 14,
        showLineNumbers: Bool = true
    ) {
        _code = code
        self.language = language
        self.fontSize = fontSize
        self.showLineNumbers = showLineNumbers
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if showLineNumbers {
                lineNumbersView
            }

            codeAreaView
        }
        .background(Color.editorBackground)
        .onChange(of: code) { _, newValue in
            updateLineCount(newValue)
        }
        .onAppear {
            updateLineCount(code)
        }
    }

    // MARK: - Line Numbers

    private var lineNumbersView: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(1 ... max(lineCount, 1), id: \.self) { number in
                Text("\(number)")
                    .font(.system(size: fontSize, design: .monospaced))
                    .foregroundStyle(Color.editorLineNumber)
                    .frame(height: fontSize * 1.4)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.editorGutter)
    }

    // MARK: - Code Area

    private var codeAreaView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let language {
                CodeText(code)
                    .highlightLanguage(language)
                    .codeTextColors(.theme(.atomOne))
                    .font(.system(size: fontSize, design: .monospaced))
                    .padding(8)
            } else {
                CodeText(code)
                    .codeTextColors(.theme(.atomOne))
                    .font(.system(size: fontSize, design: .monospaced))
                    .padding(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Helpers

    private func updateLineCount(_ text: String) {
        lineCount = max(text.components(separatedBy: "\n").count, 1)
    }
}
