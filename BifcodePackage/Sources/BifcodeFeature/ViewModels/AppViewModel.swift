import Foundation
import HighlightSwift
import SwiftUI

/// Main application view model
@MainActor
@Observable
public final class AppViewModel {
    // MARK: - Properties

    public let settings: AppSettings
    public let doPanel: CodePanel
    public let dontPanel: CodePanel

    private let highlighter = Highlight()

    // MARK: - Initialization

    public init() {
        settings = AppSettings()
        doPanel = CodePanel(type: .doPanel, title: settings.doTitle)
        dontPanel = CodePanel(type: .dontPanel, title: settings.dontTitle)
    }

    // MARK: - Language Detection

    public func detectLanguage(for panel: CodePanel) async {
        guard !panel.code.isEmpty else {
            panel.detectedLanguage = nil
            return
        }

        do {
            let result = try await highlighter.request(panel.code)
            // Convert language string to HighlightLanguage enum
            panel.detectedLanguage = HighlightLanguage(rawValue: result.language)
        } catch {
            panel.detectedLanguage = nil
        }
    }

    // MARK: - Export

    public func exportImage() async -> NSImage? {
        // TODO: Implement image export
        nil
    }

    public func saveImage(_ image: NSImage) async throws {
        let filename = "bifcode-\(Date().timeIntervalSince1970).png"
        let url = settings.saveLocation.appendingPathComponent(filename)

        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:])
        else {
            throw ExportError.conversionFailed
        }

        try pngData.write(to: url)
    }
}

// MARK: - Errors

public enum ExportError: LocalizedError {
    case conversionFailed
    case saveFailed

    public var errorDescription: String? {
        switch self {
        case .conversionFailed: "Failed to convert image to PNG"
        case .saveFailed: "Failed to save image"
        }
    }
}
