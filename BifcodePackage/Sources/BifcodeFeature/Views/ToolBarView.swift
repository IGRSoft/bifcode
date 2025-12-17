import HighlightSwift
import SwiftUI

/// Toolbar view with language picker, layout toggle, and export button
public struct ToolBarView: View {
    // MARK: - Storage

    @AppStorage("windowLayout") private var windowLayout: String = WindowLayout.horizontal.rawValue

    // MARK: - Bindings

    @Binding var selectedLanguage: HighlightLanguage?
    var onExport: () -> Void

    // MARK: - Initialization

    public init(selectedLanguage: Binding<HighlightLanguage?>, onExport: @escaping () -> Void) {
        _selectedLanguage = selectedLanguage
        self.onExport = onExport
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            languagePicker

            Spacer()

            layoutToggle

            Spacer()

            exportButton
        }
        .padding()
        .background(Color(white: 0.15))
    }

    // MARK: - Language Picker

    private var languagePicker: some View {
        HStack(spacing: 8) {
            Text("Language")
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("", selection: $selectedLanguage) {
                Text("None").tag(nil as HighlightLanguage?)
                Divider()
                ForEach(commonLanguages, id: \.self) { lang in
                    Text(lang.rawValue.capitalized).tag(lang as HighlightLanguage?)
                }
            }
            .frame(width: 120)
        }
    }

    private var commonLanguages: [HighlightLanguage] {
        [
            .swift, .python, .javaScript, .typeScript,
            .java, .kotlin, .go, .rust, .ruby,
            .c, .cPlusPlus, .cSharp, .php, .sql,
            .html, .css, .json, .yaml, .bash,
        ]
    }

    // MARK: - Layout Toggle

    private var layoutToggle: some View {
        Picker("", selection: $windowLayout) {
            Image(systemName: "rectangle.split.2x1").tag(WindowLayout.horizontal.rawValue)
            Image(systemName: "rectangle.split.1x2").tag(WindowLayout.vertical.rawValue)
        }
        .pickerStyle(.segmented)
        .frame(width: 80)
    }

    // MARK: - Export Button

    private var exportButton: some View {
        Button {
            onExport()
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
        }
        .buttonStyle(.borderedProminent)
    }
}

// MARK: - Preview

#Preview("ToolBarView") {
    ToolBarView(
        selectedLanguage: .constant(nil),
        onExport: {}
    )
}
