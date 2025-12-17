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

    @ObservationIgnored
    @AppStorage("doTitle") private var doTitleSetting: String = "Do's"

    @ObservationIgnored
    @AppStorage("dontTitle") private var dontTitleSetting: String = "Don'ts"

    /// Computed URL for save location, defaults to Desktop
    public var saveLocation: URL {
        if saveLocationPath.isEmpty {
            return FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        }
        return URL(fileURLWithPath: saveLocationPath)
    }

    // MARK: - Initialization

    public init() {
        // Read titles from UserDefaults directly for initialization
        let defaults = UserDefaults.standard
        let doTitle = defaults.string(forKey: "doTitle") ?? "Do's"
        let dontTitle = defaults.string(forKey: "dontTitle") ?? "Don'ts"

        doPanel = CodePanel(type: .doPanel, title: doTitle)
        dontPanel = CodePanel(type: .dontPanel, title: dontTitle)
    }

    // MARK: - Language Management

    /// Updates the language for both panels
    public func setLanguage(_ language: CodeLanguage) {
        doPanel.language = language
        dontPanel.language = language
    }

    // MARK: - Export

    public func exportImage() async -> NSImage? {
        // TODO: Implement image export
        nil
    }

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
