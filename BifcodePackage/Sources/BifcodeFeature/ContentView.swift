import HighlightSwift
import SwiftUI

/// Main content view with Do/Don't code panels
public struct ContentView: View {
    @State private var viewModel = AppViewModel()

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            toolbar

            panelsView
                .padding()

            if viewModel.settings.showWatermark {
                watermark
            }
        }
        .background(Color(white: 0.1))
        .frame(minWidth: 800, minHeight: 500)
    }

    // MARK: - Toolbar

    private var toolbar: some View {
        HStack {
            // Language picker for Do panel
            languagePicker(for: viewModel.doPanel, label: "Do's Language")

            Spacer()

            // Layout toggle
            Picker("", selection: Binding(
                get: { viewModel.settings.windowLayout },
                set: { viewModel.settings.windowLayout = $0 }
            )) {
                Image(systemName: "rectangle.split.2x1").tag(WindowLayout.horizontal)
                Image(systemName: "rectangle.split.1x2").tag(WindowLayout.vertical)
            }
            .pickerStyle(.segmented)
            .frame(width: 80)

            Spacer()

            // Language picker for Don't panel
            languagePicker(for: viewModel.dontPanel, label: "Don'ts Language")

            Spacer()

            // Export button
            Button {
                Task {
                    await exportImage()
                }
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(white: 0.15))
    }

    private func languagePicker(for panel: CodePanel, label: String) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            Picker("", selection: Binding(
                get: { panel.selectedLanguage ?? panel.detectedLanguage },
                set: { panel.selectedLanguage = $0 }
            )) {
                Text("Auto").tag(nil as HighlightLanguage?)
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

    // MARK: - Panels

    private var panelsView: some View {
        Group {
            if viewModel.settings.windowLayout == .horizontal {
                HStack(spacing: 16) {
                    panels
                }
            } else {
                VStack(spacing: 16) {
                    panels
                }
            }
        }
    }

    @ViewBuilder
    private var panels: some View {
        CodePanelView(
            panel: viewModel.dontPanel,
            settings: viewModel.settings
        ) {
            Task {
                await viewModel.detectLanguage(for: viewModel.dontPanel)
            }
        }

        CodePanelView(
            panel: viewModel.doPanel,
            settings: viewModel.settings
        ) {
            Task {
                await viewModel.detectLanguage(for: viewModel.doPanel)
            }
        }
    }

    // MARK: - Watermark

    private var watermark: some View {
        Text(viewModel.settings.watermarkText)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color.watermark)
            .padding(.bottom, 8)
    }

    // MARK: - Export

    private func exportImage() async {
        // TODO: Implement export using ImageRenderer
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
