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
                .padding(16)
        }
        .background(Color.contentBackground)
        .frame(minHeight: 400)
        .onChange(of: selectedLanguage) { _, newValue in
            viewModel.setLanguage(newValue)
        }
    }

    // MARK: - Panels

    private var panelsView: some View {
        Group {
            if layout == .horizontal {
                HStack(spacing: 24) {
                    panels
                }
                .padding(24)
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        panels
                    }
                    .padding(24)
                }
            }
        }
    }

    @ViewBuilder
    private var panels: some View {
        CodeEditorView(panel: viewModel.dontPanel)
            .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)

        CodeEditorView(panel: viewModel.doPanel)
            .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 4)
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
