//
//  ContentView.swift
//
//  Created on 17.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import CodeEditLanguages
import CodeEditSourceEditor
import SwiftUI

/// The main view of the Bifcode application displaying side-by-side code comparison panels.
///
/// `ContentView` is the root view that orchestrates the entire user interface, including
/// the toolbar, code editor panels, and the export pipeline. It manages user settings
/// via `@AppStorage` and coordinates between the UI and ``AppViewModel``.
///
/// ## Overview
///
/// The view consists of two main sections:
/// 1. **Toolbar** - Language selection, panel titles, indicator settings, and export button
/// 2. **Panels Area** - Two ``CodeEditorView`` instances for Do's and Don'ts code
///
/// ## Layout Modes
///
/// The panels can be arranged in two layouts controlled by ``WindowLayout``:
/// - **Horizontal** - Panels side-by-side (default)
/// - **Vertical** - Panels stacked with scroll support
///
/// ## Export Pipeline
///
/// Export uses an offscreen `NSWindow` rendering technique because standard
/// `ImageRenderer` cannot capture `NSViewRepresentable` views like `SourceEditor`.
/// The pipeline:
/// 1. Calculates dimensions based on code content and font metrics
/// 2. Creates an ``ExportView`` with the calculated dimensions
/// 3. Hosts in an offscreen `NSWindow` for proper layer rendering
/// 4. Captures via `bitmapImageRepForCachingDisplay` at 2x Retina scale
/// 5. Saves to user-selected location via ``AppViewModel``
///
/// ## Settings Persistence
///
/// All user preferences are stored via `@AppStorage`:
/// - Panel titles and indicator labels
/// - Indicator icons (SF Symbol names)
/// - Layout, position, style settings
/// - Font size and theme selection
///
/// ## Topics
///
/// ### Related Views
///
/// - ``ToolBarView``
/// - ``CodeEditorView``
/// - ``ExportView``
///
/// ### Supporting Types
///
/// - ``AppViewModel``
/// - ``WindowLayout``
/// - ``IndicatorPosition``
/// - ``IndicatorStyle``
public struct ContentView: View {
    @State private var viewModel = AppViewModel()
    @State private var exportResult: ExportResult?
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
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
    @AppStorage("themeMode") private var themeModeRaw: String = ThemeMode.dark.rawValue
    @AppStorage("exportFormat") private var exportFormatRaw: String = ExportFormat.png.rawValue
    
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
    
    private var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeRaw) ?? .dark
    }
    
    private var exportFormat: ExportFormat {
        ExportFormat(rawValue: exportFormatRaw) ?? .png
    }
    
    public init() {}
    
    /// Check if both code panels are empty (export should be disabled)
    private var isCodeEmpty: Bool {
        viewModel.doPanel.code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            viewModel.dontPanel.code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ToolBarView(
                    doTitleSetting: $doTitleSetting,
                    dontTitleSetting: $dontTitleSetting,
                    isExportDisabled: isCodeEmpty,
                    onExport: { Task(operation: exportImage) },
                    onLanguageChange: { viewModel.setLanguage($0) }
                )
                
                panelsView
                    .padding(16)
            }
            
            // Toast overlay at top of toolbar
            if let result = exportResult {
                ToastView(result: result) {
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                        exportResult = nil
                    }
                }
                .padding(.top, 8)
                .zIndex(100)
            }
        }
        .background(Color.contentBackground)
        .frame(minHeight: 400)
        .onAppear {
            // Initialize with stored language and titles on appear
            // viewModel.setLanguage(selectedLanguage)
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
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Code comparison")
                .accessibilityHint("Side by side Do and Don't panels")
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        panels
                    }
                    .padding(24)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Code comparison")
                    .accessibilityHint("Stacked Do and Don't panels")
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
    
    /// Creates the export view with current settings and dimensions
    private func makeExportView(
        panelWidth: CGFloat,
        doPanelHeight: CGFloat,
        dontPanelHeight: CGFloat
    ) -> ExportView {
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
            theme: selectedTheme.editorTheme,
            themeMode: themeMode,
            panelWidth: panelWidth,
            doPanelHeight: doPanelHeight,
            dontPanelHeight: dontPanelHeight
        )
    }
    
    // MARK: - Export
    
    /// Exports the current code panels as a PNG image.
    ///
    /// This method orchestrates the export pipeline:
    /// 1. Renders the panels to an `NSImage` via ``renderExportViewToImage()``
    /// 2. Saves the image using ``AppViewModel/saveImage(_:)``
    /// 3. Displays a toast notification with the result
    ///
    /// > Note: Export is disabled when both code panels are empty.
    @MainActor
    private func exportImage() async {
        // Use NSHostingView + snapshot instead of ImageRenderer
        // because ImageRenderer cannot render NSViewRepresentable views like SourceEditor
        guard let nsImage = await renderExportViewToImage() else {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                exportResult = .failure(ExportError.conversionFailed)
            }
            return
        }
        
        do {
            let savedURL = try await viewModel.saveImage(nsImage, format: exportFormat)
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                exportResult = .success(savedURL)
            }
        } catch {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
                exportResult = .failure(error)
            }
        }
    }
    
    /// Renders the export view to an NSImage using an offscreen window.
    ///
    /// This method uses an offscreen `NSWindow` technique because `ImageRenderer`
    /// cannot capture `NSViewRepresentable` views like `SourceEditor` from
    /// CodeEditSourceEditor.
    ///
    /// ## Rendering Steps
    ///
    /// 1. **Size Calculation** - Computes dimensions based on:
    ///    - Longest line in both code panels
    ///    - Monospace font character width
    ///    - Line counts for each panel (minimum 5 lines)
    ///    - Additional space for gutters, indicators, padding, and shadows
    ///
    /// 2. **View Setup** - Creates an ``ExportView`` with calculated dimensions
    ///    and hosts it in an `NSHostingView`
    ///
    /// 3. **Offscreen Window** - Creates a borderless window positioned off-screen
    ///    to allow proper layer rendering
    ///
    /// 4. **Render Wait** - Waits for `SourceEditor` to fully render using
    ///    multiple short sleeps with `Task.yield()`
    ///
    /// 5. **Capture** - Uses `bitmapImageRepForCachingDisplay` for proper layer
    ///    capture, then scales to 2x for Retina displays
    ///
    /// - Returns: The rendered image at 2x Retina scale, or `nil` if rendering fails.
    @MainActor
    private func renderExportViewToImage() async -> NSImage? {
        // Calculate size based on layout and content
        let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        
        // Find the longest line in both panels
        let doLines = viewModel.doPanel.code.components(separatedBy: "\n")
        let dontLines = viewModel.dontPanel.code.components(separatedBy: "\n")
        let allLines = doLines + dontLines
        let maxLineLength = allLines.map(\.count).max() ?? 1
        
        // Calculate width based on character count using monospace font
        let fontSymbolRect = font.boundingRect(forGlyph: font.glyph(withName: "W"))
        let charWidth = fontSymbolRect.width
        let charHeight = fontSymbolRect.height
        
        let codeWidth = CGFloat(maxLineLength) * charWidth
        
        // Add padding for: line numbers gutter (50), indicator badge, panel padding (24)
        let gutterWidth: CGFloat = 50
        let indicatorWidth: CGFloat = indicatorSize
        let panelPadding: CGFloat = 24
        
        // Calculate individual panel heights based on their line counts
        let lineHeight: CGFloat = charHeight * 2
        let titleBarHeight: CGFloat = showTitle ? 38 : 0
        let editorPadding: CGFloat = 16
        
        // Minimum 5 lines for proper rendering - prevents broken views with 1-4 lines
        let minLineCount = 5
        let doLineCount = max(doLines.count, minLineCount)
        let dontLineCount = max(dontLines.count, minLineCount)
        
        let panelWidth = max(codeWidth + gutterWidth + indicatorWidth + panelPadding, 250)
        let doPanelHeight = titleBarHeight + (CGFloat(doLineCount) * lineHeight) + editorPadding
        let dontPanelHeight = titleBarHeight + (CGFloat(dontLineCount) * lineHeight) + editorPadding
        
        let padding: CGFloat = 24
        let spacing: CGFloat = 24
        // Extra padding for shadows
        let shadowPadding: CGFloat = 20
        
        let contentWidth: CGFloat
        let contentHeight: CGFloat
        
        if layout == .horizontal {
            // For horizontal, use the taller panel height for container (panels align at top)
            let maxPanelHeight = max(doPanelHeight, dontPanelHeight)
            contentWidth = (panelWidth * 2) + spacing + (padding * 2)
            contentHeight = maxPanelHeight + (padding * 2)
        } else {
            // For vertical, sum both heights
            contentWidth = panelWidth + (padding * 2)
            contentHeight = doPanelHeight + dontPanelHeight + spacing + (padding * 2)
        }
        
        // Add shadow padding to total size
        let totalWidth = contentWidth + (shadowPadding * 2)
        let totalHeight = contentHeight + (shadowPadding * 2)
        let size = NSSize(width: totalWidth, height: totalHeight)
        
        // Create export view with explicit frame and dimensions
        let framedExportView = makeExportView(
            panelWidth: panelWidth,
            doPanelHeight: doPanelHeight,
            dontPanelHeight: dontPanelHeight
        )
        .frame(width: contentWidth, height: contentHeight)
        .padding(shadowPadding) // Add padding for shadow rendering
        
        let hostingView = NSHostingView(rootView: framedExportView)
        hostingView.wantsLayer = true
        
        // Create an offscreen window to host the view
        // This is required for NSViewRepresentable views to render properly
        let offscreenWindow = NSWindow(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        offscreenWindow.contentView = hostingView
        offscreenWindow.isReleasedWhenClosed = false
        offscreenWindow.backgroundColor = .clear
        
        // Move window offscreen and make it visible for rendering
        offscreenWindow.setFrameOrigin(NSPoint(x: -10_000, y: -10_000))
        offscreenWindow.orderBack(nil)
        
        // Force layout
        hostingView.frame = NSRect(origin: .zero, size: size)
        hostingView.layoutSubtreeIfNeeded()
        
        // Wait for SourceEditor to fully render
        // Use multiple short sleeps to allow RunLoop to process
        for _ in 0..<10 {
            try? await Task.sleep(for: .milliseconds(50))
            await Task.yield()
        }
        
        // Use bitmapImageRepForCachingDisplay for proper layer capture
        guard let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds) else {
            offscreenWindow.orderOut(nil)
            return nil
        }
        
        // Cache the display into the bitmap
        hostingView.cacheDisplay(in: hostingView.bounds, to: bitmapRep)
        
        // Clean up the offscreen window
        offscreenWindow.orderOut(nil)
        
        // Create final image at 2x scale for Retina
        let scale: CGFloat = 2.0
        let scaledSize = NSSize(width: size.width * scale, height: size.height * scale)
        
        guard let scaledBitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(scaledSize.width),
            pixelsHigh: Int(scaledSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else {
            let image = NSImage(size: size)
            image.addRepresentation(bitmapRep)
            return image
        }
        
        scaledBitmapRep.size = size
        
        // Draw the captured content at 2x scale
        NSGraphicsContext.saveGraphicsState()
        if let context = NSGraphicsContext(bitmapImageRep: scaledBitmapRep) {
            NSGraphicsContext.current = context
            context.imageInterpolation = .high
            
            let sourceImage = NSImage(size: size)
            sourceImage.addRepresentation(bitmapRep)
            
            sourceImage.draw(
                in: NSRect(origin: .zero, size: size),
                from: .zero,
                operation: .copy,
                fraction: 1.0
            )
        }
        NSGraphicsContext.restoreGraphicsState()
        
        let finalImage = NSImage(size: size)
        finalImage.addRepresentation(scaledBitmapRep)
        
        return finalImage
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
