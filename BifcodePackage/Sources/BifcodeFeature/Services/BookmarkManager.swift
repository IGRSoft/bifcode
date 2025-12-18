//
//  BookmarkManager.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation

/// Manages security-scoped URL bookmarks for persistent file access across app launches.
///
/// This manager handles the creation, storage, and resolution of security-scoped bookmarks
/// that allow a sandboxed macOS app to maintain access to user-selected directories.
///
/// Usage:
/// 1. When user selects a folder via NSOpenPanel, call `storeBookmark(for:)`
/// 2. To access the stored location, call `resolveBookmark()` and use the returned URL
/// 3. Before file operations, call `startAccessingSecurityScopedResource()` on the URL
/// 4. After file operations, call `stopAccessingSecurityScopedResource()` on the URL
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
