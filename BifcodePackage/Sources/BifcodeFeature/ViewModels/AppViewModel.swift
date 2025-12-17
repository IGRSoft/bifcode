import CodeEditLanguages
import Foundation
import SwiftUI

/// Main application view model
@MainActor
@Observable
public final class AppViewModel {
    // MARK: - Properties

    public let doPanel: CodePanel
    public let dontPanel: CodePanel

    // MARK: - Settings (via @AppStorage)

    @ObservationIgnored
    @AppStorage("saveLocation") private var saveLocationPath: String = ""

    /// Computed URL for save location, defaults to Desktop
    public var saveLocation: URL {
        if saveLocationPath.isEmpty {
            return FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
        }
        return URL(fileURLWithPath: saveLocationPath)
    }

    // MARK: - Initialization

    public init() {
        // Read titles from UserDefaults directly for initialization
        doPanel = CodePanel(type: .doPanel)
        dontPanel = CodePanel(type: .dontPanel)
    }

    // MARK: - Language Management

    /// Updates the language for both panels
    public func setLanguage(_ language: CodeLanguage) {
        doPanel.language = language
        dontPanel.language = language
    }
    
    /// Updates the language for both panels
    public func update(doTitle: String, dontTitle: String) {
        doPanel.title = doTitle
        dontPanel.title = dontTitle
    }

    // MARK: - Export

    public func saveImage(_ image: NSImage) async throws {
        let filename = "bifcode-\(Date().timeIntervalSince1970).png"
        let url = saveLocation.appendingPathComponent(filename)

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
