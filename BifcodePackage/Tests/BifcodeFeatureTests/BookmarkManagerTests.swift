//
//  BookmarkManagerTests.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Foundation
import Testing
@testable import BifcodeFeature

// MARK: - BookmarkManager Tests

@Suite("BookmarkManager Tests")
@MainActor
struct BookmarkManagerTests {
    // MARK: - Setup/Teardown

    init() {
        // Clear any existing bookmark before each test
        BookmarkManager.shared.clearBookmark()
    }

    // MARK: - Singleton

    @Test("shared returns singleton instance")
    func sharedReturnsSingleton() {
        let instance1 = BookmarkManager.shared
        let instance2 = BookmarkManager.shared

        #expect(instance1 === instance2)
    }

    // MARK: - hasBookmark

    @Test("hasBookmark returns false when no bookmark stored")
    func hasBookmarkFalseWhenEmpty() {
        BookmarkManager.shared.clearBookmark()

        #expect(BookmarkManager.shared.hasBookmark == false)
    }

    @Test("hasBookmark returns true after storing bookmark")
    func hasBookmarkTrueAfterStore() throws {
        // Use temp directory which should be accessible
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        #expect(BookmarkManager.shared.hasBookmark == true)
    }

    // MARK: - clearBookmark

    @Test("clearBookmark removes stored bookmark")
    func clearBookmarkRemovesBookmark() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        BookmarkManager.shared.clearBookmark()

        #expect(BookmarkManager.shared.hasBookmark == false)
    }

    @Test("clearBookmark is safe to call when no bookmark exists")
    func clearBookmarkSafeWhenEmpty() {
        BookmarkManager.shared.clearBookmark()
        BookmarkManager.shared.clearBookmark()

        #expect(BookmarkManager.shared.hasBookmark == false)
    }

    // MARK: - resolveBookmark

    @Test("resolveBookmark returns nil when no bookmark stored")
    func resolveBookmarkNilWhenEmpty() {
        BookmarkManager.shared.clearBookmark()

        let resolved = BookmarkManager.shared.resolveBookmark()

        #expect(resolved == nil)
    }

    @Test("resolveBookmark returns URL after storing bookmark")
    func resolveBookmarkReturnsURLAfterStore() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        let resolved = BookmarkManager.shared.resolveBookmark()

        #expect(resolved != nil)
        // Use standardizedFileURL to resolve symlinks for path comparison
        #expect(resolved?.standardizedFileURL.path == tempURL.standardizedFileURL.path)
    }

    // MARK: - bookmarkedLocationName

    @Test("bookmarkedLocationName returns nil when no bookmark stored")
    func bookmarkedLocationNameNilWhenEmpty() {
        BookmarkManager.shared.clearBookmark()

        #expect(BookmarkManager.shared.bookmarkedLocationName == nil)
    }

    @Test("bookmarkedLocationName returns last path component")
    func bookmarkedLocationNameReturnsLastComponent() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        let name = BookmarkManager.shared.bookmarkedLocationName

        // Temporary directory usually named something like "tmp" or has a UUID
        #expect(name != nil)
        #expect(name == tempURL.lastPathComponent)
    }

    // MARK: - storeBookmark

    @Test("storeBookmark persists across accesses")
    func storeBookmarkPersists() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // Access through singleton multiple times
        #expect(BookmarkManager.shared.hasBookmark)
        #expect(BookmarkManager.shared.resolveBookmark() != nil)
        #expect(BookmarkManager.shared.hasBookmark)
    }

    @Test("storeBookmark replaces existing bookmark")
    func storeBookmarkReplaces() throws {
        let tempURL1 = FileManager.default.temporaryDirectory
        let tempURL2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

        try BookmarkManager.shared.storeBookmark(for: tempURL1)
        try BookmarkManager.shared.storeBookmark(for: tempURL2)

        let resolved = BookmarkManager.shared.resolveBookmark()
        #expect(resolved?.path == tempURL2.path)
    }

    // MARK: - Thread Safety (Sendable)

    @Test("BookmarkManager.shared is accessible from MainActor")
    func accessibleFromMainActor() {
        // This test runs on MainActor
        let manager = BookmarkManager.shared
        _ = manager.hasBookmark
    }

    // MARK: - UserDefaults Integration

    @Test("bookmark is stored in UserDefaults")
    func storedInUserDefaults() throws {
        BookmarkManager.shared.clearBookmark()

        // Verify cleared
        let beforeStore = UserDefaults.standard.data(forKey: "saveLocationBookmark")
        #expect(beforeStore == nil)

        // Store bookmark
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // Verify stored
        let afterStore = UserDefaults.standard.data(forKey: "saveLocationBookmark")
        #expect(afterStore != nil)
    }

    @Test("clearBookmark removes from UserDefaults")
    func clearRemovesFromUserDefaults() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        BookmarkManager.shared.clearBookmark()

        let data = UserDefaults.standard.data(forKey: "saveLocationBookmark")
        #expect(data == nil)
    }

    // MARK: - Edge Cases

    @Test("resolveBookmark handles invalid bookmark data")
    func resolveHandlesInvalidData() {
        // Manually set invalid data
        UserDefaults.standard.set(Data([0x00, 0x01, 0x02]), forKey: "saveLocationBookmark")

        let resolved = BookmarkManager.shared.resolveBookmark()

        // Should return nil for invalid data and clear the bookmark
        #expect(resolved == nil)
        #expect(BookmarkManager.shared.hasBookmark == false)
    }
}

// MARK: - BookmarkManager Integration Tests

@Suite("BookmarkManager Integration Tests")
@MainActor
struct BookmarkManagerIntegrationTests {
    init() {
        BookmarkManager.shared.clearBookmark()
    }

    @Test("full bookmark lifecycle: store, resolve, clear")
    func fullLifecycle() throws {
        // Initial state
        #expect(BookmarkManager.shared.hasBookmark == false)
        #expect(BookmarkManager.shared.resolveBookmark() == nil)
        #expect(BookmarkManager.shared.bookmarkedLocationName == nil)

        // Store
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // After store
        #expect(BookmarkManager.shared.hasBookmark == true)
        #expect(BookmarkManager.shared.resolveBookmark() != nil)
        #expect(BookmarkManager.shared.bookmarkedLocationName != nil)

        // Clear
        BookmarkManager.shared.clearBookmark()

        // After clear
        #expect(BookmarkManager.shared.hasBookmark == false)
        #expect(BookmarkManager.shared.resolveBookmark() == nil)
        #expect(BookmarkManager.shared.bookmarkedLocationName == nil)
    }

    @Test("AppViewModel uses BookmarkManager correctly")
    func appViewModelIntegration() throws {
        BookmarkManager.shared.clearBookmark()

        let viewModel = AppViewModel()

        // Default state
        #expect(viewModel.hasCustomSaveLocation == false)
        #expect(viewModel.saveLocationName == "Desktop")

        // Store bookmark
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // After bookmark stored
        #expect(viewModel.hasCustomSaveLocation == true)
        #expect(viewModel.saveLocationName == tempURL.lastPathComponent)
        // Use standardizedFileURL to resolve symlinks for path comparison
        #expect(viewModel.saveLocation.standardizedFileURL.path == tempURL.standardizedFileURL.path)

        // Clear for cleanup
        BookmarkManager.shared.clearBookmark()
    }
}
