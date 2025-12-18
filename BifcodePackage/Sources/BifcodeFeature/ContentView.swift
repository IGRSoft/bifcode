//
//  ContentView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditLanguages
import CodeEditSourceEditor
import SwiftUI

/// Main content view with Do/Don't code panels
public struct ContentView: View {
    @State private var viewModel = AppViewModel()

    // Language is stored via @AppStorage in ToolBarView, we read it here to initialize panels
    @AppStorage("selectedLanguage") private var selectedLanguageRaw: String = "swift"

    private var selectedLanguage: CodeLanguage {
        CodeLanguage.allLanguages.first { $0.id.rawValue == selectedLanguageRaw } ?? .swift
    }

    // MARK: - Settings (via @AppStorage)

    @AppStorage("doTitle") private var doTitleSetting: String = "Do's"
    @AppStorage("dontTitle") private var dontTitleSetting: String = "Don'ts"
    @AppStorage("doIndicatorIcon") private var doIndicatorIcon: String = "checkmark"
    @AppStorage("dontIndicatorIcon") private var dontIndicatorIcon: String = "xmark"
    @AppStorage("doIndicatorLabel") private var doIndicatorLabel: String = "Do's"
    @AppStorage("dontIndicatorLabel") private var dontIndicatorLabel: String = "Don'ts"

    @AppStorage("windowLayout") private var windowLayoutRaw: String = WindowLayout.horizontal.rawValue
    @AppStorage("indicatorPosition") private var indicatorPositionRaw: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyleRaw: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("showTitle") private var showTitle: Bool = true
    @AppStorage("fontSize") private var fontSize: Double = 14
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = EditorThemeOption.atomOneDark.rawValue

    private var layout: WindowLayout {
        WindowLayout(rawValue: windowLayoutRaw) ?? .horizontal
    }

    private var indicatorPosition: IndicatorPosition {
        IndicatorPosition(rawValue: indicatorPositionRaw) ?? .topRight
    }

    private var indicatorStyle: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorStyleRaw) ?? .iconAndText
    }

    private var selectedTheme: EditorThemeOption {
        EditorThemeOption(rawValue: selectedThemeRaw) ?? .atomOneDark
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            ToolBarView(
                doTitleSetting: $doTitleSetting,
                dontTitleSetting: $dontTitleSetting,
                onExport: { Task(operation: exportImage) },
                onLanguageChange: { viewModel.setLanguage($0) }
            )

            panelsView
                .padding(16)
        }
        .background(Color.contentBackground)
        .frame(minHeight: 400)
        .onAppear {
            // Initialize with stored language and titles on appear
            viewModel.setLanguage(selectedLanguage)
            viewModel.update(doTitle: doTitleSetting, dontTitle: dontTitleSetting)
        }
        .onChange(of: selectedLanguageRaw) { _, _ in
            // Update panels when language changes via AppStorage
            viewModel.setLanguage(selectedLanguage)
        }
        .onChange(of: doTitleSetting) { _, newValue in
            viewModel.update(doTitle: newValue, dontTitle: dontTitleSetting)
        }
        .onChange(of: dontTitleSetting) { _, newValue in
            viewModel.update(doTitle: doTitleSetting, dontTitle: newValue)
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

    // MARK: - Export View

    /// Creates the export view with current settings
    private var exportView: ExportView {
        ExportView(
            doPanel: viewModel.doPanel,
            dontPanel: viewModel.dontPanel,
            layout: layout,
            indicatorPosition: indicatorPosition,
            indicatorStyle: indicatorStyle,
            indicatorSize: indicatorSize,
            doIndicatorIcon: doIndicatorIcon,
            dontIndicatorIcon: dontIndicatorIcon,
            doIndicatorLabel: doIndicatorLabel,
            dontIndicatorLabel: dontIndicatorLabel,
            showTitle: showTitle,
            fontSize: fontSize,
            theme: selectedTheme.editorTheme
        )
    }

    // MARK: - Export

    @MainActor
    private func exportImage() async {
        let renderer = ImageRenderer(content: exportView)
        // Use 2x scale for Retina quality
        renderer.scale = 2.0

        guard let nsImage = renderer.nsImage else {
            // TODO: Show error alert
            return
        }

        do {
            try await viewModel.saveImage(nsImage)
        } catch {
            // TODO: Show error alert
            print("Export failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
