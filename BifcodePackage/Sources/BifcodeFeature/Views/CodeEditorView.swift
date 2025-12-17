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
        CodeText((1...max(lineCount, 1)).map(String.init).joined(separator: "\n"))
            .codeTextColors(.theme(.atomOne))
            .font(.system(size: fontSize, design: .monospaced))
            .padding(8)
            .background(Color.editorGutter)
    }

    // MARK: - Code Area

    private var codeAreaView: some View {
        Group {
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

// MARK: - Preview

#Preview("Code Editor with lines numbers") {
    @Previewable @State var code = """
    func greet(name: String) -> String {
        return "Hello, \\(name)!"
    }

    let message = greet(name: "World")
    print(message)
    """

    CodeEditorView(
        code: $code,
        language: .swift,
        fontSize: 14,
        showLineNumbers: true
    )
    .frame(width: 400, height: 200)
}

#Preview("Code Editor without lines numbers") {
    @Previewable @State var code = """
    func greet(name: String) -> String {
        return "Hello, \\(name)!"
    }

    let message = greet(name: "World")
    print(message)
    """

    CodeEditorView(
        code: $code,
        language: .swift,
        fontSize: 14,
        showLineNumbers: false
    )
    .frame(width: 400, height: 200)
}
