//
//  ExportIntegrationTests.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Foundation
import Testing
@testable import BifcodeFeature

// MARK: - Export Integration Tests

@Suite("Export Integration Tests")
@MainActor
struct ExportIntegrationTests {
    // MARK: - Setup

    init() {
        BookmarkManager.shared.clearBookmark()
    }

    // MARK: - Save Image Tests

    @Test("saveImage throws conversionFailed for invalid image")
    func saveImageThrowsForInvalidImage() async throws {
        let viewModel = AppViewModel()

        // Create an empty/invalid NSImage
        let invalidImage = NSImage()

        do {
            try await viewModel.saveImage(invalidImage)
            Issue.record("Expected conversionFailed error")
        } catch let error as ExportError {
            #expect(error == .conversionFailed)
        }
    }

    @Test("saveImage succeeds with valid image")
    func saveImageSucceedsWithValidImage() async throws {
        let viewModel = AppViewModel()

        // Create a valid test image
        let image = createTestImage(width: 100, height: 100)

        // Use temp directory as save location
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // Should not throw
        try await viewModel.saveImage(image)

        // Cleanup - remove the saved file
        let files = try FileManager.default.contentsOfDirectory(
            at: tempURL,
            includingPropertiesForKeys: nil
        )
        for file in files where file.lastPathComponent.hasPrefix("bifcode-") {
            try? FileManager.default.removeItem(at: file)
        }

        BookmarkManager.shared.clearBookmark()
    }

    @Test("saveImage creates file with correct naming pattern")
    func saveImageCreatesFileWithCorrectName() async throws {
        let viewModel = AppViewModel()

        // Create a valid test image
        let image = createTestImage(width: 100, height: 100)

        // Use temp directory
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // Get files before
        let filesBefore = try FileManager.default.contentsOfDirectory(
            at: tempURL,
            includingPropertiesForKeys: nil
        )
        let bifcodeFilesBefore = filesBefore.filter { $0.lastPathComponent.hasPrefix("bifcode-") }

        // Save image
        try await viewModel.saveImage(image)

        // Get files after
        let filesAfter = try FileManager.default.contentsOfDirectory(
            at: tempURL,
            includingPropertiesForKeys: nil
        )
        let bifcodeFilesAfter = filesAfter.filter { $0.lastPathComponent.hasPrefix("bifcode-") }

        // Should have one more file
        #expect(bifcodeFilesAfter.count == bifcodeFilesBefore.count + 1)

        // Find the new file
        let newFiles = Set(bifcodeFilesAfter).subtracting(Set(bifcodeFilesBefore))
        #expect(newFiles.count == 1)

        if let newFile = newFiles.first {
            // Verify naming pattern: bifcode-{timestamp}.png
            #expect(newFile.lastPathComponent.hasPrefix("bifcode-"))
            #expect(newFile.pathExtension == "png")

            // Cleanup
            try? FileManager.default.removeItem(at: newFile)
        }

        BookmarkManager.shared.clearBookmark()
    }

    @Test("saveImage creates valid PNG file")
    func saveImageCreatesValidPNG() async throws {
        let viewModel = AppViewModel()

        // Create a valid test image
        let image = createTestImage(width: 200, height: 150)

        // Use temp directory
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        // Save image
        try await viewModel.saveImage(image)

        // Find the saved file
        let files = try FileManager.default.contentsOfDirectory(
            at: tempURL,
            includingPropertiesForKeys: nil
        )
        let bifcodeFile = files.first { $0.lastPathComponent.hasPrefix("bifcode-") }

        #expect(bifcodeFile != nil)

        if let file = bifcodeFile {
            // Read and verify PNG
            let data = try Data(contentsOf: file)
            #expect(!data.isEmpty)

            // PNG magic number: 89 50 4E 47 0D 0A 1A 0A
            let pngMagic: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
            let fileHeader = Array(data.prefix(8))
            #expect(fileHeader == pngMagic)

            // Cleanup
            try? FileManager.default.removeItem(at: file)
        }

        BookmarkManager.shared.clearBookmark()
    }

    @Test("saveImage uses default Desktop when no bookmark")
    func saveImageUsesDesktopByDefault() async throws {
        BookmarkManager.shared.clearBookmark()

        let viewModel = AppViewModel()

        // Verify save location is Desktop
        let location = viewModel.saveLocation
        #expect(location.path.contains("Desktop"))
    }

    // MARK: - Helper Methods

    private func createTestImage(width: Int, height: Int) -> NSImage {
        let image = NSImage(size: NSSize(width: width, height: height))
        image.lockFocus()

        // Draw a simple colored rectangle
        NSColor.blue.setFill()
        NSBezierPath.fill(NSRect(x: 0, y: 0, width: width, height: height))

        image.unlockFocus()
        return image
    }
}

// MARK: - Save Location Tests

@Suite("Save Location Tests")
@MainActor
struct SaveLocationTests {
    init() {
        BookmarkManager.shared.clearBookmark()
    }

    @Test("saveLocation returns Desktop URL by default")
    func defaultSaveLocation() {
        let viewModel = AppViewModel()

        let location = viewModel.saveLocation

        #expect(location.isFileURL)
        #expect(location.path.contains("Desktop"))
    }

    @Test("saveLocation returns bookmarked URL when set")
    func bookmarkedSaveLocation() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        let viewModel = AppViewModel()

        // Use standardizedFileURL to resolve symlinks for path comparison
        #expect(viewModel.saveLocation.standardizedFileURL.path == tempURL.standardizedFileURL.path)

        BookmarkManager.shared.clearBookmark()
    }

    @Test("hasCustomSaveLocation reflects bookmark state")
    func hasCustomSaveLocationState() throws {
        let viewModel = AppViewModel()

        // Initially false
        #expect(viewModel.hasCustomSaveLocation == false)

        // After setting bookmark
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        #expect(viewModel.hasCustomSaveLocation == true)

        // After clearing
        BookmarkManager.shared.clearBookmark()

        #expect(viewModel.hasCustomSaveLocation == false)
    }

    @Test("saveLocationName returns folder name")
    func saveLocationNameReturnsName() throws {
        let tempURL = FileManager.default.temporaryDirectory
        try BookmarkManager.shared.storeBookmark(for: tempURL)

        let viewModel = AppViewModel()

        #expect(viewModel.saveLocationName == tempURL.lastPathComponent)

        BookmarkManager.shared.clearBookmark()
    }

    @Test("saveLocationName returns 'Desktop' by default")
    func saveLocationNameDefault() {
        let viewModel = AppViewModel()

        #expect(viewModel.saveLocationName == "Desktop")
    }
}

// MARK: - Panel State Integration Tests

@Suite("Panel State Integration Tests")
@MainActor
struct PanelStateIntegrationTests {
    @Test("panels maintain state through language changes")
    func panelsStateThroughLanguageChange() {
        let viewModel = AppViewModel()

        // Set panel state
        viewModel.doPanel.code = "let x = 1"
        viewModel.doPanel.title = "Do Title"
        viewModel.dontPanel.code = "var y = 2"
        viewModel.dontPanel.title = "Dont Title"

        // Change language
        viewModel.setLanguage(.python)
        viewModel.setLanguage(.javascript)
        viewModel.setLanguage(.swift)

        // Verify state preserved
        #expect(viewModel.doPanel.code == "let x = 1")
        #expect(viewModel.doPanel.title == "Do Title")
        #expect(viewModel.dontPanel.code == "var y = 2")
        #expect(viewModel.dontPanel.title == "Dont Title")
    }

    @Test("panels maintain state through title updates")
    func panelsStateThroughTitleUpdate() {
        let viewModel = AppViewModel()

        // Set panel state
        viewModel.doPanel.code = "let x = 1"
        viewModel.dontPanel.code = "var y = 2"
        viewModel.setLanguage(.python)

        // Update titles
        viewModel.update(doTitle: "New Do", dontTitle: "New Dont")

        // Verify code and language preserved
        #expect(viewModel.doPanel.code == "let x = 1")
        #expect(viewModel.dontPanel.code == "var y = 2")
        #expect(viewModel.doPanel.language == .python)
        #expect(viewModel.dontPanel.language == .python)
    }

    @Test("complete workflow: create, edit, save")
    func completeWorkflow() async throws {
        let viewModel = AppViewModel()

        // 1. Set up panels
        viewModel.doPanel.code = """
        // Good practice
        let userName = user.name
        """
        viewModel.doPanel.title = "Best Practice"
        viewModel.dontPanel.code = """
        // Avoid this
        let n = u.n
        """
        viewModel.dontPanel.title = "Anti-Pattern"
        viewModel.setLanguage(.swift)

        // 2. Verify state
        #expect(viewModel.doPanel.type == .doPanel)
        #expect(viewModel.dontPanel.type == .dontPanel)
        #expect(viewModel.doPanel.language == .swift)

        // 3. Titles can be updated
        viewModel.update(doTitle: "Updated Do", dontTitle: "Updated Dont")
        #expect(viewModel.doPanel.title == "Updated Do")
        #expect(viewModel.dontPanel.title == "Updated Dont")
    }
}
