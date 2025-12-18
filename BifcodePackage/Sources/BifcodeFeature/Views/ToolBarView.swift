//
//  ToolBarView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import CodeEditSourceEditor
import SwiftUI

/// Toolbar view with all settings inline
public struct ToolBarView: View {
    // MARK: - App Storage

    @AppStorage("windowLayout") private var windowLayout: String = WindowLayout.horizontal.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyle: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorPosition") private var indicatorPosition: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("doIndicatorIcon") private var doIndicatorIcon: String = "checkmark"
    @AppStorage("dontIndicatorIcon") private var dontIndicatorIcon: String = "xmark"
    @AppStorage("doIndicatorLabel") private var doIndicatorLabel: String = "Do's"
    @AppStorage("dontIndicatorLabel") private var dontIndicatorLabel: String = "Don'ts"
    @AppStorage("fontSize") private var fontSize: Double = 14
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = EditorThemeOption.atomOneDark.rawValue

    @AppStorage("selectedLanguage") private var selectedLanguageRaw: String = "swift"

    /// Current indicator style for disable logic
    private var currentIndicatorStyle: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorStyle) ?? .iconAndText
    }

    /// Selected language derived from stored raw value
    private var selectedLanguage: CodeLanguage {
        CodeLanguage.allLanguages.first { $0.id.rawValue == selectedLanguageRaw } ?? .swift
    }

    @Binding private var doTitleSetting: String
    @Binding private var dontTitleSetting: String

    // MARK: - Callbacks

    var onExport: () -> Void
    var onLanguageChange: (CodeLanguage) -> Void

    // MARK: - Initialization

    public init(
        doTitleSetting: Binding<String>,
        dontTitleSetting: Binding<String>,
        onExport: @escaping () -> Void,
        onLanguageChange: @escaping (CodeLanguage) -> Void
    ) {
        _doTitleSetting = doTitleSetting
        _dontTitleSetting = dontTitleSetting
        self.onExport = onExport
        self.onLanguageChange = onLanguageChange
    }

    // MARK: - Body
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            codeSettingsView()
                .padding(.trailing, 8)

            Divider().frame(height: 150)

            indicatorSettingsView()
                .padding(.trailing, 8)
            
            Divider().frame(height: 150)

            Spacer(minLength: 0)

            // Export
            exportButton
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.toolbarBackground)
    }

    @ViewBuilder
    private func codeSettingsView() -> some View {
        VStack(spacing: 16) {
            Text("Code Style")
                .font(.caption)
                .foregroundStyle(Color.secondaryText)
            
            HStack(spacing: 8) {
                // Language
                languagePicker
                
                // Theme
                themePicker
                
                Divider().frame(width: 1, height: 20)
                    .padding(.leading, 8)
                
                // Layout
                layoutToggle
            }
            .fixedSize()
            
            // Font Size
            fontSizeControl
            
            VStack(spacing: 16) {
                Text("Panel Titles")
                    .font(.caption)
                    .foregroundStyle(Color.secondaryText)
                
                HStack(spacing: 16) {
                    doTitleField
                    dontTitleField
                }
            }
            .padding(.top, 11)
            .frame(maxWidth: .infinity)
        }
        .fixedSize()
        .layoutPriority(1)
    }
    
    @ViewBuilder
    private func indicatorSettingsView() -> some View {
        VStack(spacing: 16) {
            Text("Indicator Style")
                .font(.caption)
                .foregroundStyle(Color.secondaryText)

            HStack(spacing: 8) {
                // Indicator Style
                indicatorStylePicker

                // Indicator Position
                indicatorPositionPicker
            }
            .fixedSize()
            .layoutPriority(1)
            
            // Indicator Size
            indicatorSizeControl
            
            // Icon Pickers
            HStack(spacing: 16) {
                doIconPicker
                    .frame(maxWidth: .infinity)
                Spacer()
                dontIconPicker
                    .padding(.leading, 8)
            }
            .frame(maxWidth: .infinity)

            // Indicator Labels
            HStack(spacing: 8) {
                doIndicatorLabelField
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                dontIndicatorLabelField
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
        .fixedSize()
    }
    
    // MARK: - Language Picker

    private var languagePicker: some View {
        HStack(spacing: 4) {
            Picker("", selection: $selectedLanguageRaw) {
                ForEach(commonLanguages, id: \.id) { lang in
                    Text(lang.id.rawValue.capitalized).tag(lang.id.rawValue)
                }
            }
            .pickerStyle(.menu)
            .fixedSize()
            .onChange(of: selectedLanguageRaw) { _, _ in
                onLanguageChange(selectedLanguage)
            }
        }
    }

    private var commonLanguages: [CodeLanguage] {
        [
            .swift, .python, .javascript, .typescript,
            .java, .kotlin, .go, .rust, .ruby,
            .c, .cpp, .cSharp, .php, .sql,
            .html, .css, .json, .yaml, .bash,
        ]
    }

    // MARK: - Theme Picker

    private var themePicker: some View {
        Picker("", selection: $selectedThemeRaw) {
            ForEach(EditorThemeOption.allCases, id: \.rawValue) { theme in
                Text(theme.label).tag(theme.rawValue)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
    }

    // MARK: - Layout Toggle

    private var layoutToggle: some View {
        Picker("", selection: $windowLayout) {
            Image(systemName: "rectangle.split.2x1").tag(WindowLayout.horizontal.rawValue)
            Image(systemName: "rectangle.split.1x2").tag(WindowLayout.vertical.rawValue)
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Indicator Style

    private var indicatorStylePicker: some View {
        Picker("", selection: Binding(
            get: { IndicatorStyle(rawValue: indicatorStyle) ?? .iconAndText },
            set: { indicatorStyle = $0.rawValue }
        )) {
            ForEach(IndicatorStyle.allCases, id: \.self) { style in
                Text(style.label).tag(style)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
    }

    // MARK: - Indicator Position

    private var indicatorPositionPicker: some View {
        Picker("", selection: Binding(
            get: { IndicatorPosition(rawValue: indicatorPosition) ?? .topRight },
            set: { indicatorPosition = $0.rawValue }
        )) {
            ForEach(IndicatorPosition.allCases, id: \.self) { position in
                Text(position.label).tag(position)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
    }

    // MARK: - Icon Pickers

    private var doIconPicker: some View {
        Picker("Do", selection: $doIndicatorIcon) {
            ForEach(IndicatorIcon.positiveIcons, id: \.rawValue) { icon in
                Image(systemName: icon.systemName)
                    .tag(icon.systemName)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .disabled(currentIndicatorStyle == .textOnly)
    }

    private var dontIconPicker: some View {
        Picker("Don't", selection: $dontIndicatorIcon) {
            ForEach(IndicatorIcon.negativeIcons, id: \.rawValue) { icon in
                Image(systemName: icon.systemName)
                    .tag(icon.systemName)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .disabled(currentIndicatorStyle == .textOnly)
    }

    // MARK: - Indicator Label Fields

    private var doIndicatorLabelField: some View {
        TextField("Do Label", text: $doIndicatorLabel)
            .textFieldStyle(.roundedBorder)
            .disabled(currentIndicatorStyle == .iconOnly)
            .onChange(of: doIndicatorLabel) { _, newValue in
                if newValue.count > 10 {
                    doIndicatorLabel = String(newValue.prefix(10))
                }
            }
    }

    private var dontIndicatorLabelField: some View {
        TextField("Don't Label", text: $dontIndicatorLabel)
            .textFieldStyle(.roundedBorder)
            .disabled(currentIndicatorStyle == .iconOnly)
            .onChange(of: dontIndicatorLabel) { _, newValue in
                if newValue.count > 10 {
                    dontIndicatorLabel = String(newValue.prefix(10))
                }
            }
    }

    // MARK: - Indicator Size

    private var indicatorSizeControl: some View {
        HStack(spacing: 4) {
            Slider(value: $indicatorSize, in: 32 ... 80, step: 4)
                .frame(maxWidth: .infinity)

            Text("\(Int(indicatorSize))")
                .font(.body)
                .monospacedDigit()
                .padding(.leading, 8)
                .fixedSize()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Font Size

    private var fontSizeControl: some View {
        HStack(spacing: 4) {
            Slider(value: $fontSize, in: 10 ... 34, step: 1)
                .frame(maxWidth: .infinity)

            Text("\(Int(fontSize))")
                .font(.body)
                .monospacedDigit()
                .padding(.leading, 8)
                .fixedSize()
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Title Fields

    private var doTitleField: some View {
        TextField("Do Title", text: $doTitleSetting)
            .textFieldStyle(.roundedBorder)
            .frame(width: 150)
            .onChange(of: doTitleSetting) { _, newValue in
                if newValue.count > 70 {
                    doTitleSetting = String(newValue.prefix(70))
                }
            }
    }

    private var dontTitleField: some View {
        TextField("Don't Title", text: $dontTitleSetting)
            .textFieldStyle(.roundedBorder)
            .frame(width: 150)
            .onChange(of: dontTitleSetting) { _, newValue in
                if newValue.count > 70 {
                    dontTitleSetting = String(newValue.prefix(70))
                }
            }
    }

    // MARK: - Export Button

    private var exportButton: some View {
        VStack(spacing: 16) {
            Button { onExport() } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 34))
            }
            .buttonStyle(.borderedProminent)
            .fixedSize()
            
            Button("Choose") {
                chooseSaveLocation()
            }
        }
    }
    
    // MARK: - Actions

    private func chooseSaveLocation() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose"
        panel.message = "Select a folder to save exported images"

        if panel.runModal() == .OK, let url = panel.url {
            do {
                try BookmarkManager.shared.storeBookmark(for: url)
            } catch {
                // Log bookmark creation failure - user can try again
                print("Failed to create bookmark: \(error)")
            }
        }
    }
}

// MARK: - Preview

#Preview("ToolBarView") {
    ToolBarView(
        doTitleSetting: .constant("1"),
        dontTitleSetting: .constant("2"),
        onExport: {},
        onLanguageChange: { _ in }
    )
}
