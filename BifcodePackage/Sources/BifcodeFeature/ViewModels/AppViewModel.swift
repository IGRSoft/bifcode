//
//  AppViewModel.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

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

    // MARK: - Save Location

    /// Computed URL for save location, defaults to Desktop.
    /// Uses security-scoped bookmarks to persist access across app launches.
    public var saveLocation: URL {
        // Try to resolve bookmarked location first
        if let bookmarkedURL = BookmarkManager.shared.resolveBookmark() {
            return bookmarkedURL
        }
        // Fall back to Desktop
        return FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
    }

    /// Whether a custom save location has been set via bookmark
    public var hasCustomSaveLocation: Bool {
        BookmarkManager.shared.hasBookmark
    }

    /// Display name of the current save location
    public var saveLocationName: String {
        BookmarkManager.shared.bookmarkedLocationName ?? "Desktop"
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

    /// Save an image to the configured save location.
    ///
    /// Handles security-scoped resource access for bookmarked locations.
    /// - Parameter image: The NSImage to save as PNG
    /// - Throws: `ExportError` if conversion or saving fails
    public func saveImage(_ image: NSImage) async throws {
        let location = saveLocation
        let needsSecurityScope = hasCustomSaveLocation

        // Start security-scoped access if using bookmarked URL
        if needsSecurityScope {
            guard location.startAccessingSecurityScopedResource() else {
                throw ExportError.accessDenied
            }
        }

        defer {
            if needsSecurityScope {
                location.stopAccessingSecurityScopedResource()
            }
        }

        let filename = "bifcode-\(Date().timeIntervalSince1970).png"
        let url = location.appendingPathComponent(filename)

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
    case accessDenied

    public var errorDescription: String? {
        switch self {
        case .conversionFailed: "Failed to convert image to PNG"
        case .saveFailed: "Failed to save image"
        case .accessDenied: "Cannot access save location. Please choose a new folder."
        }
    }
}
