//
//  AppViewModel.swift
//
//  Created on 17.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import Foundation
import SwiftUI

/// The main view model managing application state and export functionality.
///
/// `AppViewModel` is the central state container for the Bifcode application.
/// It manages the Do and Don't code panels, handles export operations, and
/// coordinates with ``BookmarkManager`` for persistent save location access.
///
/// ## Overview
///
/// The view model maintains two ``CodePanel`` instances representing the
/// "Do's" and "Don'ts" code examples that users can edit and export.
///
/// ```swift
/// @State private var viewModel = AppViewModel()
///
/// // Access panels
/// let doCode = viewModel.doPanel.code
/// let dontCode = viewModel.dontPanel.code
///
/// // Update language for both panels
/// viewModel.setLanguage(.python)
///
/// // Export current view
/// try await viewModel.saveImage(capturedImage)
/// ```
///
/// ## Topics
///
/// ### Creating a View Model
///
/// - ``init()``
///
/// ### Accessing Panels
///
/// - ``doPanel``
/// - ``dontPanel``
///
/// ### Managing Languages
///
/// - ``setLanguage(_:)``
/// - ``update(doTitle:dontTitle:)``
///
/// ### Export
///
/// - ``saveImage(_:)``
/// - ``saveLocation``
/// - ``hasCustomSaveLocation``
/// - ``saveLocationName``
@MainActor
@Observable
public final class AppViewModel {
    // MARK: - Properties

    /// The "Do's" code panel containing positive code examples.
    ///
    /// This panel displays code that demonstrates best practices or
    /// recommended approaches. The indicator badge shows a green checkmark
    /// by default.
    public let doPanel: CodePanel

    /// The "Don'ts" code panel containing negative code examples.
    ///
    /// This panel displays code that demonstrates anti-patterns or
    /// approaches to avoid. The indicator badge shows a red X by default.
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

    /// Creates a new view model with default panel configurations.
    ///
    /// Initializes both the Do and Don't panels with Swift as the default
    /// language and empty code content. Panel titles are read from
    /// `@AppStorage` in the views.
    public init() {
        // Read titles from UserDefaults directly for initialization
        doPanel = CodePanel(type: .doPanel)
        dontPanel = CodePanel(type: .dontPanel)
    }

    // MARK: - Language Management

    /// Updates the syntax highlighting language for both panels.
    ///
    /// Call this method when the user selects a different programming
    /// language from the toolbar picker. Both panels are updated
    /// simultaneously to maintain consistency.
    ///
    /// - Parameter language: The new programming language for syntax highlighting.
    ///
    /// ```swift
    /// viewModel.setLanguage(.python)
    /// viewModel.setLanguage(.javascript)
    /// ```
    public func setLanguage(_ language: CodeLanguage) {
        doPanel.language = language
        dontPanel.language = language
    }

    /// Updates the titles for both code panels.
    ///
    /// Panel titles are displayed in the title bar above each code editor.
    /// This method synchronizes the view model's panels with the titles
    /// stored in `@AppStorage`.
    ///
    /// - Parameters:
    ///   - doTitle: The title for the "Do's" panel.
    ///   - dontTitle: The title for the "Don'ts" panel.
    public func update(doTitle: String, dontTitle: String) {
        doPanel.title = doTitle
        dontPanel.title = dontTitle
    }

    // MARK: - Export

    /// Save an image to the configured save location.
    ///
    /// Handles security-scoped resource access for bookmarked locations.
    /// - Parameter image: The NSImage to save as PNG
    /// - Returns: The URL where the image was saved
    /// - Throws: `ExportError` if conversion or saving fails
    @discardableResult
    public func saveImage(_ image: NSImage) async throws -> URL {
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
        return url
    }
}

// MARK: - Errors

/// Errors that can occur during image export operations.
///
/// These errors are thrown by ``AppViewModel/saveImage(_:)`` when
/// export operations fail. Each case provides a user-friendly
/// error description via `LocalizedError`.
///
/// ## Topics
///
/// ### Error Cases
///
/// - ``conversionFailed``
/// - ``saveFailed``
/// - ``accessDenied``
public enum ExportError: LocalizedError {
    /// The image could not be converted to PNG format.
    ///
    /// This typically occurs if the `NSImage` has invalid or
    /// unsupported image data.
    case conversionFailed

    /// The PNG data could not be written to disk.
    ///
    /// This may occur due to disk space issues or file system errors.
    case saveFailed

    /// The save location cannot be accessed.
    ///
    /// This occurs when the security-scoped bookmark is stale or invalid.
    /// The user should choose a new save location via the "Choose" button.
    case accessDenied

    public var errorDescription: String? {
        switch self {
        case .conversionFailed: "Failed to convert image to PNG"
        case .saveFailed: "Failed to save image"
        case .accessDenied: "Cannot access save location. Please choose a new folder."
        }
    }
}
