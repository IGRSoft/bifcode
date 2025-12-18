//
//  BookmarkManager.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation

/// Manages security-scoped URL bookmarks for persistent file access across app launches.
///
/// `BookmarkManager` enables a sandboxed macOS app to maintain access to user-selected
/// directories across app restarts. It handles the creation, storage, and resolution of
/// security-scoped bookmarks using macOS security APIs.
///
/// ## Overview
///
/// In sandboxed apps, users must explicitly grant access to directories outside the
/// app's container. Security-scoped bookmarks preserve this access between sessions.
///
/// ## Usage
///
/// The typical workflow for using `BookmarkManager`:
///
/// ```swift
/// // 1. User selects a folder via NSOpenPanel
/// let panel = NSOpenPanel()
/// panel.canChooseDirectories = true
/// if panel.runModal() == .OK, let url = panel.url {
///     // 2. Store the bookmark
///     try BookmarkManager.shared.storeBookmark(for: url)
/// }
///
/// // 3. Later, resolve the bookmark to get the URL
/// if let savedURL = BookmarkManager.shared.resolveBookmark() {
///     // 4. Start security-scoped access
///     guard savedURL.startAccessingSecurityScopedResource() else {
///         throw SomeError.accessDenied
///     }
///
///     defer {
///         // 5. Stop access when done
///         savedURL.stopAccessingSecurityScopedResource()
///     }
///
///     // Perform file operations...
/// }
/// ```
///
/// ## Topics
///
/// ### Accessing the Shared Instance
///
/// - ``shared``
///
/// ### Managing Bookmarks
///
/// - ``storeBookmark(for:)``
/// - ``resolveBookmark()``
/// - ``clearBookmark()``
///
/// ### Querying State
///
/// - ``hasBookmark``
/// - ``bookmarkedLocationName``
@MainActor
public final class BookmarkManager: Sendable {
    // MARK: - Singleton

    /// Shared instance for app-wide bookmark management
    public static let shared = BookmarkManager()

    // MARK: - Constants

    private let bookmarkKey = "saveLocationBookmark"

    // MARK: - Initialization

    private init() {}

    // MARK: - Public Methods

    /// Store bookmark data for a user-selected URL.
    ///
    /// Creates a security-scoped bookmark that persists access rights across app launches.
    /// The bookmark is stored in UserDefaults.
    ///
    /// - Parameter url: The URL selected by the user via NSOpenPanel
    /// - Throws: An error if bookmark creation fails
    public func storeBookmark(for url: URL) throws {
        let bookmarkData = try url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        UserDefaults.standard.set(bookmarkData, forKey: bookmarkKey)
    }

    /// Resolve stored bookmark to get a security-scoped URL.
    ///
    /// Returns the URL from the stored bookmark, automatically refreshing the bookmark
    /// if it has become stale. If the bookmark is invalid or doesn't exist, returns nil.
    ///
    /// - Returns: The resolved URL, or nil if no valid bookmark exists
    public func resolveBookmark() -> URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmarkKey) else {
            return nil
        }

        var isStale = false
        do {
            let url = try URL(
                resolvingBookmarkData: bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )

            // Refresh stale bookmark to maintain access
            if isStale {
                try? storeBookmark(for: url)
            }

            return url
        } catch {
            // Bookmark is invalid - clear it so we fall back to default
            clearBookmark()
            return nil
        }
    }

    /// Clear the stored bookmark.
    ///
    /// Call this when the bookmarked location is no longer valid or when
    /// the user wants to reset to the default save location.
    public func clearBookmark() {
        UserDefaults.standard.removeObject(forKey: bookmarkKey)
    }

    /// Check if a bookmark is currently stored.
    public var hasBookmark: Bool {
        UserDefaults.standard.data(forKey: bookmarkKey) != nil
    }

    /// Get the display name of the bookmarked location.
    ///
    /// - Returns: The last path component of the bookmarked URL, or nil if no bookmark exists
    public var bookmarkedLocationName: String? {
        resolveBookmark()?.lastPathComponent
    }
}
