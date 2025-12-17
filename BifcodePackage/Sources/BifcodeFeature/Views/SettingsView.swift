import SwiftUI

/// Settings panel for app preferences
public struct SettingsView: View {
    @Bindable var settings: AppSettings

    public init(settings: AppSettings) {
        self.settings = settings
    }

    public var body: some View {
        Form {
            indicatorSection
            editorSection
            exportSection
        }
        .formStyle(.grouped)
        .frame(width: 450)
        .onChange(of: settings.indicatorPosition) { _, _ in settings.save() }
        .onChange(of: settings.indicatorStyle) { _, _ in settings.save() }
        .onChange(of: settings.indicatorSize) { _, _ in settings.save() }
        .onChange(of: settings.showTitle) { _, _ in settings.save() }
        .onChange(of: settings.fontSize) { _, _ in settings.save() }
        .onChange(of: settings.windowLayout) { _, _ in settings.save() }
        .onChange(of: settings.doTitle) { _, _ in settings.save() }
        .onChange(of: settings.dontTitle) { _, _ in settings.save() }
        .onChange(of: settings.watermarkText) { _, _ in settings.save() }
        .onChange(of: settings.showWatermark) { _, _ in settings.save() }
    }

    // MARK: - Indicator Section

    private var indicatorSection: some View {
        Section("Indicator") {
            Picker("Style", selection: $settings.indicatorStyle) {
                ForEach(IndicatorStyle.allCases, id: \.self) { style in
                    Text(style.label).tag(style)
                }
            }

            Picker("Position", selection: $settings.indicatorPosition) {
                ForEach(IndicatorPosition.allCases, id: \.self) { position in
                    Text(position.label).tag(position)
                }
            }

            HStack {
                Text("Size")
                Slider(value: $settings.indicatorSize, in: 32 ... 80, step: 4)
                Text("\(Int(settings.indicatorSize))px")
                    .monospacedDigit()
                    .frame(width: 40)
            }
        }
    }

    // MARK: - Editor Section

    private var editorSection: some View {
        Section("Editor") {
            Toggle("Show Title Bar", isOn: $settings.showTitle)

            HStack {
                Text("Font Size")
                Slider(value: $settings.fontSize, in: 10 ... 24, step: 1)
                Text("\(Int(settings.fontSize))pt")
                    .monospacedDigit()
                    .frame(width: 40)
            }

            Picker("Layout", selection: $settings.windowLayout) {
                ForEach(WindowLayout.allCases, id: \.self) { layout in
                    Text(layout.label).tag(layout)
                }
            }

            TextField("Do's Title", text: $settings.doTitle)
            TextField("Don'ts Title", text: $settings.dontTitle)
        }
    }

    // MARK: - Export Section

    private var exportSection: some View {
        Section("Export") {
            Toggle("Show Watermark", isOn: $settings.showWatermark)

            if settings.showWatermark {
                TextField("Watermark Text", text: $settings.watermarkText)
            }

            HStack {
                Text("Save Location")
                Spacer()
                Text(settings.saveLocation.lastPathComponent)
                    .foregroundStyle(.secondary)
                Button("Choose...") {
                    chooseSaveLocation()
                }
            }
        }
    }

    // MARK: - Actions

    private func chooseSaveLocation() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            settings.saveLocation = url
            settings.save()
        }
    }
}
