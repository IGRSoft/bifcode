import HighlightSwift
import SwiftUI

/// Toolbar view with language picker, layout toggle, settings, and export button
public struct ToolBarView: View {
    // MARK: - App Storage

    @AppStorage("windowLayout") private var windowLayout: String = WindowLayout.horizontal.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyle: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorPosition") private var indicatorPosition: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("fontSize") private var fontSize: Double = 14
    @AppStorage("showWatermark") private var showWatermark: Bool = true
    @AppStorage("watermarkText") private var watermarkText: String = "bifcode"

    // MARK: - State

    @State private var showingSettings = false

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

            settingsButton

            exportButton
        }
        .padding()
        .background(Color(white: 0.15))
        .popover(isPresented: $showingSettings, arrowEdge: .bottom) {
            settingsPanel
        }
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

    // MARK: - Settings Button

    private var settingsButton: some View {
        Button {
            showingSettings.toggle()
        } label: {
            Image(systemName: "gearshape")
        }
        .buttonStyle(.borderless)
        .padding(.trailing, 8)
    }

    // MARK: - Settings Panel

    private var settingsPanel: some View {
        Form {
            Section("Indicator") {
                Picker("Style", selection: Binding(
                    get: { IndicatorStyle(rawValue: indicatorStyle) ?? .iconAndText },
                    set: { indicatorStyle = $0.rawValue }
                )) {
                    ForEach(IndicatorStyle.allCases, id: \.self) { style in
                        Text(style.label).tag(style)
                    }
                }

                Picker("Position", selection: Binding(
                    get: { IndicatorPosition(rawValue: indicatorPosition) ?? .topRight },
                    set: { indicatorPosition = $0.rawValue }
                )) {
                    ForEach(IndicatorPosition.allCases, id: \.self) { position in
                        Text(position.label).tag(position)
                    }
                }

                HStack {
                    Text("Size")
                    Slider(value: $indicatorSize, in: 32 ... 80, step: 4)
                    Text("\(Int(indicatorSize))px")
                        .monospacedDigit()
                        .frame(width: 40)
                }
            }

            Section("Editor") {
                HStack {
                    Text("Font Size")
                    Slider(value: $fontSize, in: 10 ... 24, step: 1)
                    Text("\(Int(fontSize))pt")
                        .monospacedDigit()
                        .frame(width: 40)
                }
            }

            Section("Export") {
                Toggle("Show Watermark", isOn: $showWatermark)

                if showWatermark {
                    TextField("Watermark Text", text: $watermarkText)
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 320, height: 340)
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
