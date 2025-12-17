import CodeEditLanguages
import SwiftUI

/// Main content view with Do/Don't code panels
public struct ContentView: View {
    @State private var viewModel = AppViewModel()
    @State private var selectedLanguage: CodeLanguage = .swift

    // MARK: - Settings (via @AppStorage)

    @AppStorage("windowLayout") private var windowLayoutRaw: String = WindowLayout.horizontal.rawValue

    private var layout: WindowLayout {
        WindowLayout(rawValue: windowLayoutRaw) ?? .horizontal
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            ToolBarView(
                selectedLanguage: $selectedLanguage,
                onExport: {
                    Task {
                        await exportImage()
                    }
                }
            )

            panelsView
                .padding()
        }
        .background(Color(white: 0.1))
        .frame(minHeight: 400)
        .onChange(of: selectedLanguage) { _, newValue in
            viewModel.setLanguage(newValue)
        }
    }

    // MARK: - Panels

    private var panelsView: some View {
        Group {
            if layout == .horizontal {
                HStack(spacing: 16) {
                    panels
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        panels
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var panels: some View {
        CodeEditorView(panel: viewModel.dontPanel)

        CodeEditorView(panel: viewModel.doPanel)
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
