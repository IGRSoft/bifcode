import HighlightSwift
import SwiftUI

/// Toolbar view with all settings inline
public struct ToolBarView: View {
    // MARK: - App Storage

    @AppStorage("windowLayout") private var windowLayout: String = WindowLayout.horizontal.rawValue
    @AppStorage("indicatorStyle") private var indicatorStyle: String = IndicatorStyle.iconAndText.rawValue
    @AppStorage("indicatorPosition") private var indicatorPosition: String = IndicatorPosition.topRight.rawValue
    @AppStorage("indicatorSize") private var indicatorSize: Double = 48
    @AppStorage("fontSize") private var fontSize: Double = 14

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
        HStack(spacing: 16) {
            VStack(spacing: 16) {
                Text("Code Style")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    // Language
                    languagePicker

                    Divider().frame(width: 1, height: 20)
                        .padding(.leading, 8)

                    // Layout
                    layoutToggle
                }
                .layoutPriority(3)

                // Font Size
                fontSizeControl
                    .layoutPriority(2)
            }

            Divider().frame(height: 48)

            VStack(spacing: 16) {
                Text("Indicator Style")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    // Indicator Style
                    indicatorStylePicker

                    // Indicator Position
                    indicatorPositionPicker
                }

                // Indicator Size
                indicatorSizeControl
            }

            Divider().frame(height: 20)

            Spacer(minLength: 0)

            // Export
            exportButton
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(white: 0.15))
    }

    // MARK: - Language Picker

    private var languagePicker: some View {
        HStack(spacing: 4) {
            Picker("", selection: $selectedLanguage) {
                Text("None").tag(nil as HighlightLanguage?)
                Divider()
                ForEach(commonLanguages, id: \.self) { lang in
                    Text(lang.rawValue.capitalized).tag(lang as HighlightLanguage?)
                }
            }
            .frame(width: 100)
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
        .frame(width: 120)
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
        .frame(width: 120)
    }

    // MARK: - Indicator Size

    private var indicatorSizeControl: some View {
        HStack(spacing: 4) {
            Slider(value: $indicatorSize, in: 32 ... 80, step: 4)
                .frame(width: 160)

            Text("\(Int(indicatorSize))")
                .font(.body)
                .monospacedDigit()
                .frame(width: 20, alignment: .trailing)
        }
    }

    // MARK: - Font Size

    private var fontSizeControl: some View {
        HStack(spacing: 4) {
            Slider(value: $fontSize, in: 10 ... 24, step: 1)
                .frame(width: 130)

            Text("\(Int(fontSize))")
                .font(.body)
                .monospacedDigit()
                .frame(width: 24, alignment: .trailing)
        }
    }

    // MARK: - Export Button

    private var exportButton: some View {
        Button {
            onExport()
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
                .fixedSize()
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
