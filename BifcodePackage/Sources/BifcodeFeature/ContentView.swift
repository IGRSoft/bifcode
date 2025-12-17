import HighlightSwift
import SwiftUI

/// Main content view with Do/Don't code panels
public struct ContentView: View {
    @State private var viewModel = AppViewModel()
    @State private var selectedLanguage: HighlightLanguage?
    @AppStorage("windowLayout") private var windowLayout: String = WindowLayout.horizontal.rawValue

    private var layout: WindowLayout {
        WindowLayout(rawValue: windowLayout) ?? .horizontal
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

            if viewModel.settings.showWatermark {
                watermark
            }
        }
        .background(Color(white: 0.1))
        .frame(minWidth: 800, minHeight: 500)
        .onChange(of: selectedLanguage) { _, newValue in
            viewModel.doPanel.selectedLanguage = newValue
            viewModel.dontPanel.selectedLanguage = newValue
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
