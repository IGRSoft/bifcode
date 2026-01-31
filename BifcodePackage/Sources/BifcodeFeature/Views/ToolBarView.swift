//
//  ToolBarView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import CodeEditSourceEditor
import DeveloperSupportStore
import SwiftUI

/// A toolbar providing all code style and indicator settings with an export button.
///
/// `ToolBarView` is the main settings interface for Bifcode. It presents controls
/// organized into sections for code style, indicator customization, and export.
///
/// ## Overview
///
/// The toolbar contains three main sections:
///
/// ### Code Style Section
/// - **Language Picker** - Select from 19 programming languages
/// - **Theme Picker** - Choose from 7 syntax highlighting themes
/// - **Layout Toggle** - Switch between horizontal and vertical layouts
/// - **Font Size Slider** - Adjust code font (10-24pt)
/// - **Panel Titles** - Edit "Do" and "Don't" panel titles
///
/// ### Indicator Style Section
/// - **Style Picker** - Icon only, text only, or both
/// - **Position Picker** - Top-right or bottom-right
/// - **Size Slider** - Badge size (32-80px)
/// - **Icon Pickers** - Choose icons for Do/Don't badges
/// - **Label Fields** - Custom text for indicator labels
///
/// ### Export Section
/// - **Export Button** - Save as PNG (disabled when panels are empty)
/// - **Choose Button** - Select save location folder
///
/// ## Settings Persistence
///
/// All settings are automatically persisted via `@AppStorage` to UserDefaults.
///
/// ## Topics
///
/// ### Creating a Toolbar
///
/// - ``init(doTitleSetting:dontTitleSetting:isExportDisabled:onExport:onLanguageChange:)``
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
    @AppStorage("themeMode") private var themeModeRaw: String = ThemeMode.dark.rawValue
    
    @AppStorage("selectedLanguage") private var selectedLanguageRaw: String = "swift"
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    /// Current indicator style for disable logic
    private var currentIndicatorStyle: IndicatorStyle {
        IndicatorStyle(rawValue: indicatorStyle) ?? .iconAndText
    }
    
    /// Selected language derived from stored raw value
    private var selectedLanguage: CodeLanguage {
        CodeLanguage.allLanguages.first { $0.id.rawValue == selectedLanguageRaw } ?? .swift
    }
    
    /// Current theme mode derived from stored raw value
    private var currentThemeMode: ThemeMode {
        ThemeMode(rawValue: themeModeRaw) ?? .dark
    }
    
    /// Current selected theme derived from stored raw value
    private var currentTheme: EditorThemeOption {
        EditorThemeOption(rawValue: selectedThemeRaw) ?? .atomOneDark
    }
    
    /// All available themes (not filtered by mode)
    private var availableThemes: [EditorThemeOption] {
        EditorThemeOption.allCases
    }
    
    @Binding private var doTitleSetting: String
    @Binding private var dontTitleSetting: String
    
    // MARK: - Callbacks
    
    var onExport: () -> Void
    var onLanguageChange: (CodeLanguage) -> Void
    var isExportDisabled: Bool
    
    // MARK: - Initialization
    
    /// Creates a new toolbar view with the specified configuration.
    ///
    /// - Parameters:
    ///   - doTitleSetting: Binding to the "Do's" panel title.
    ///   - dontTitleSetting: Binding to the "Don'ts" panel title.
    ///   - isExportDisabled: Whether the export button should be disabled.
    ///     Set to `true` when both code panels are empty.
    ///   - onExport: Closure called when the export button is tapped.
    ///   - onLanguageChange: Closure called when the language selection changes,
    ///     providing the newly selected ``CodeLanguage``.
    ///
    /// ```swift
    /// ToolBarView(
    ///     doTitleSetting: $doTitle,
    ///     dontTitleSetting: $dontTitle,
    ///     isExportDisabled: viewModel.doPanel.code.isEmpty,
    ///     onExport: { Task { await exportImage() } },
    ///     onLanguageChange: { viewModel.setLanguage($0) }
    /// )
    /// ```
    public init(
        doTitleSetting: Binding<String>,
        dontTitleSetting: Binding<String>,
        isExportDisabled: Bool = false,
        onExport: @escaping () -> Void,
        onLanguageChange: @escaping (CodeLanguage) -> Void
    ) {
        _doTitleSetting = doTitleSetting
        _dontTitleSetting = dontTitleSetting
        self.isExportDisabled = isExportDisabled
        self.onExport = onExport
        self.onLanguageChange = onLanguageChange
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(alignment: .top, spacing: 24) {
            codeSettingsView()
            
            Divider()
                .frame(height: 184)
                .padding(.vertical, 8)
            
            indicatorSettingsView()
            
            Divider()
                .frame(height: 184)
                .padding(.vertical, 8)
            
            exportButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.toolbarBackground)
    }
    
    @ViewBuilder
    private func codeSettingsView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Header - HIG: Use clear, hierarchical typography
            Text("Code Style")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.sectionHeader)
            
            // Language & Theme Row
            HStack(spacing: 12) {
                languagePicker
                themePicker
            }
            
            // Font Size with Label
            VStack(alignment: .leading, spacing: 4) {
                Text("Font Size")
                    .font(.caption)
                    .foregroundStyle(Color.tertiaryText)
                fontSizeControl
            }
            
            // Mode & Layout Controls
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Theme")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    themeModeToggle
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Layout")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    layoutToggle
                }
            }
            
            // Panel Titles
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Don't Title")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    dontTitleField
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Do Title")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    doTitleField
                }
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
    
    @ViewBuilder
    private func indicatorSettingsView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Header - HIG: Use clear, hierarchical typography
            Text("Indicator Style")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.sectionHeader)
            
            // Style & Position Pickers
            HStack(spacing: 12) {
                indicatorStylePicker
                indicatorPositionPicker
            }
            
            // Indicator Size with Label
            VStack(alignment: .leading, spacing: 4) {
                Text("Badge Size")
                    .font(.caption)
                    .foregroundStyle(Color.tertiaryText)
                indicatorSizeControl
            }
            
            // Icon Pickers with Labels
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Don't Icon")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    dontIconPicker
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Do Icon")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    doIconPicker
                }
            }
            
            // Indicator Labels
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Don't Label")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    dontIndicatorLabelField
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Do Label")
                        .font(.caption)
                        .foregroundStyle(Color.tertiaryText)
                    doIndicatorLabelField
                }
            }
        }
        .fixedSize(horizontal: true, vertical: false)
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
            .accessibilityLabel("Programming Language")
            .accessibilityHint("Select syntax highlighting language")
            .onChange(of: selectedLanguageRaw) { _, _ in
                onLanguageChange(selectedLanguage)
            }
        }
    }
    
    private var commonLanguages: [CodeLanguage] {
        [
            // Popular languages
            .swift, .python, .javascript, .typescript,
            .java, .kotlin, .go, .rust, .ruby,
            .c, .cpp, .cSharp, .php, .sql,
            // Web & markup
            .html, .css, .json, .yaml, .markdown,
            // DevOps & config
            .bash, .dockerfile, .toml,
            // Functional & other
            .scala, .elixir, .haskell, .lua,
            .dart, .julia, .perl, .zig
        ]
    }
    
    // MARK: - Theme Mode Toggle
    
    private var themeModeToggle: some View {
        Picker("", selection: $themeModeRaw) {
            Image(systemName: "moon.fill").tag(ThemeMode.dark.rawValue)
            Image(systemName: "sun.max.fill").tag(ThemeMode.light.rawValue)
        }
        .pickerStyle(.segmented)
        .fixedSize()
        .accessibilityLabel("Theme Mode")
        .accessibilityHint("Toggle dark or light mode")
    }
    
    // MARK: - Theme Picker
    
    private var themePicker: some View {
        Picker("", selection: $selectedThemeRaw) {
            ForEach(availableThemes, id: \.rawValue) { theme in
                Text(theme.label).tag(theme.rawValue)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .accessibilityLabel("Color Theme")
        .accessibilityHint("Select code highlighting theme")
    }
    
    // MARK: - Layout Toggle
    
    private var layoutToggle: some View {
        Picker("", selection: $windowLayout) {
            Image(systemName: "rectangle.split.2x1").tag(WindowLayout.horizontal.rawValue)
            Image(systemName: "rectangle.split.1x2").tag(WindowLayout.vertical.rawValue)
        }
        .pickerStyle(.segmented)
        .accessibilityLabel("Layout")
        .accessibilityHint("Horizontal or vertical panel arrangement")
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
        .accessibilityLabel("Indicator Style")
        .accessibilityHint("Show icon, text, or both")
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
        .accessibilityLabel("Indicator Position")
        .accessibilityHint("Badge position on panels")
    }
    
    // MARK: - Icon Pickers
    
    private var doIconPicker: some View {
        Picker("", selection: $doIndicatorIcon) {
            ForEach(IndicatorIcon.positiveIcons, id: \.rawValue) { icon in
                Image(systemName: icon.systemName)
                    .tag(icon.systemName)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .disabled(currentIndicatorStyle == .textOnly)
        .accessibilityLabel("Do Icon")
        .accessibilityHint(currentIndicatorStyle == .textOnly
            ? "Disabled: Change indicator style to enable"
            : "Select icon for positive examples")
    }
    
    private var dontIconPicker: some View {
        Picker("", selection: $dontIndicatorIcon) {
            ForEach(IndicatorIcon.negativeIcons, id: \.rawValue) { icon in
                Image(systemName: icon.systemName)
                    .tag(icon.systemName)
            }
        }
        .pickerStyle(.menu)
        .fixedSize()
        .disabled(currentIndicatorStyle == .textOnly)
        .accessibilityLabel("Don't Icon")
        .accessibilityHint(currentIndicatorStyle == .textOnly
            ? "Disabled: Change indicator style to enable"
            : "Select icon for negative examples")
    }
    
    // MARK: - Indicator Label Fields
    
    private var doIndicatorLabelField: some View {
        TextField("Do's", text: $doIndicatorLabel)
            .textFieldStyle(.roundedBorder)
            .frame(width: 120)
            .disabled(currentIndicatorStyle == .iconOnly)
            .onChange(of: doIndicatorLabel) { _, newValue in
                if newValue.count > 10 {
                    doIndicatorLabel = String(newValue.prefix(10))
                }
            }
            .accessibilityLabel("Do Indicator Text")
            .accessibilityHint(currentIndicatorStyle == .iconOnly
                ? "Disabled: Change indicator style to enable"
                : "Custom label for positive indicator")
    }
    
    private var dontIndicatorLabelField: some View {
        TextField("Don'ts", text: $dontIndicatorLabel)
            .textFieldStyle(.roundedBorder)
            .frame(width: 120)
            .disabled(currentIndicatorStyle == .iconOnly)
            .onChange(of: dontIndicatorLabel) { _, newValue in
                if newValue.count > 10 {
                    dontIndicatorLabel = String(newValue.prefix(10))
                }
            }
            .accessibilityLabel("Don't Indicator Text")
            .accessibilityHint(currentIndicatorStyle == .iconOnly
                ? "Disabled: Change indicator style to enable"
                : "Custom label for negative indicator")
    }
    
    // MARK: - Indicator Size
    
    private var indicatorSizeControl: some View {
        HStack(spacing: 8) {
            Slider(value: $indicatorSize, in: 32...80, step: 4)
                .frame(width: 236)
            
            Text("\(Int(indicatorSize))")
                .font(.caption.monospacedDigit())
                .foregroundStyle(Color.secondaryText)
                .frame(width: 24, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Badge Size")
        .accessibilityValue("\(Int(indicatorSize)) pixels")
        .accessibilityHint("Adjust from 32 to 80 pixels")
    }
    
    // MARK: - Font Size
    
    private var fontSizeControl: some View {
        HStack(spacing: 8) {
            Slider(value: $fontSize, in: 10...24, step: 1)
                .frame(width: 248)
            
            Text("\(Int(fontSize))")
                .font(.caption.monospacedDigit())
                .foregroundStyle(Color.secondaryText)
                .frame(width: 24, alignment: .trailing)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Font Size")
        .accessibilityValue("\(Int(fontSize)) points")
        .accessibilityHint("Adjust from 10 to 24 points")
    }
    
    // MARK: - Title Fields
    
    private var doTitleField: some View {
        TextField("Do Title", text: $doTitleSetting)
            .textFieldStyle(.roundedBorder)
            .frame(width: 120)
            .onChange(of: doTitleSetting) { _, newValue in
                if newValue.count > 70 {
                    doTitleSetting = String(newValue.prefix(70))
                }
            }
            .accessibilityLabel("Do Panel Title")
            .accessibilityHint("Title shown above positive code example")
    }
    
    private var dontTitleField: some View {
        TextField("Don't Title", text: $dontTitleSetting)
            .textFieldStyle(.roundedBorder)
            .frame(width: 120)
            .onChange(of: dontTitleSetting) { _, newValue in
                if newValue.count > 70 {
                    dontTitleSetting = String(newValue.prefix(70))
                }
            }
            .accessibilityLabel("Don't Panel Title")
            .accessibilityHint("Title shown above negative code example")
    }
    
    // MARK: - Export Button
    
    @State private var isExportButtonHovered = false
    @State private var isStorePresented = false
    
    /// Tracks whether the user has made any purchase (subscription or tip).
    /// Persisted via AppStorage so the green icon state survives app restarts.
    @AppStorage("hasMadePurchase") private var hasMadePurchase = false
    
    private let storeConfiguration = BifcodeStoreConfiguration()
    private let storeService = StoreService()
    
    private var exportButton: some View {
        VStack(spacing: 12) {
            // Primary Export Action - HIG: Use .prominent for key actions
            Button { onExport() } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 22, weight: .medium))
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Circle())
            .scaleEffect(isExportButtonHovered && !isExportDisabled ? 1.05 : 1.0)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.15), value: isExportButtonHovered)
            .onHover { hovering in
                isExportButtonHovered = hovering
            }
            .disabled(isExportDisabled)
            .help("Export as PNG")
            .accessibilityLabel("Export as PNG")
            .accessibilityHint(isExportDisabled
                ? "Disabled: Add code to enable export"
                : "Save comparison image to selected folder")
            
            // Secondary Actions
            VStack(spacing: 8) {
                Button {
                    chooseSaveLocation()
                } label: {
                    Label("Location", systemImage: "folder")
                        .font(.caption)
                }
                .buttonStyle(.borderless)
                .help("Choose save location")
                .accessibilityLabel("Choose Save Location")
                .accessibilityHint("Select folder for exported images")
                
                storeButton
                    .padding(.top, 32)
            }
        }
        .frame(minWidth: 80)
    }
    
    private var storeButton: some View {
        Button {
            isStorePresented = true
        } label: {
            Image(systemName: hasMadePurchase ? "heart.fill" : "storefront")
                .font(.system(size: 24))
                .foregroundStyle(hasMadePurchase ? Color.storePurchased : Color.storeDefault)
        }
        .buttonStyle(.borderless)
        .help(hasMadePurchase ? "Thank you for supporting!" : "Support development")
        .accessibilityLabel(hasMadePurchase ? "Thank you for supporting" : "Support Development")
        .sheet(isPresented: $isStorePresented) {
            DeveloperSupportStoreView(
                configuration: storeConfiguration,
                storeService: storeService,
                onPurchaseSuccess: { _ in
                    hasMadePurchase = true
                },
                onDismiss: {
                    isStorePresented = false
                }
            )
        }
        .task {
            await checkPurchaseStatus()
        }
    }
    
    private func checkPurchaseStatus() async {
        // Skip sync if user has already made a purchase (persisted via AppStorage)
        guard !hasMadePurchase else { return }
        
        do {
            try await storeService.syncStoreData()
            // Check if there's an active subscription
            if storeService.hasActiveSubscription {
                hasMadePurchase = true
            }
        } catch {
            // Silently fail - purchase status will remain false
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
        isExportDisabled: false,
        onExport: {},
        onLanguageChange: { _ in }
    )
}

#Preview("ToolBarView - Export Disabled") {
    ToolBarView(
        doTitleSetting: .constant("1"),
        dontTitleSetting: .constant("2"),
        isExportDisabled: true,
        onExport: {},
        onLanguageChange: { _ in }
    )
}
