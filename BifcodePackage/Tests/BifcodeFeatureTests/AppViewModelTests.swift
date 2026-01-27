//
//  AppViewModelTests.swift
//
//  Created on 18.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import Foundation
import Testing
@testable import BifcodeFeature

// MARK: - AppViewModel Tests

@Suite("AppViewModel Tests")
@MainActor
struct AppViewModelTests {
    // MARK: - Initialization
    
    @Test("init creates doPanel with doPanel type")
    func initCreatesDoPanelWithCorrectType() {
        let viewModel = AppViewModel()
        
        #expect(viewModel.doPanel.type == .doPanel)
    }
    
    @Test("init creates dontPanel with dontPanel type")
    func initCreatesDontPanelWithCorrectType() {
        let viewModel = AppViewModel()
        
        #expect(viewModel.dontPanel.type == .dontPanel)
    }
    
    @Test("init creates panels with empty code")
    func initCreatesPanelsWithEmptyCode() {
        let viewModel = AppViewModel()
        
        #expect(viewModel.doPanel.code.isEmpty)
        #expect(viewModel.dontPanel.code.isEmpty)
    }
    
    @Test("init creates panels with default Swift language")
    func initCreatesPanelsWithSwiftLanguage() {
        let viewModel = AppViewModel()
        
        #expect(viewModel.doPanel.language == .swift)
        #expect(viewModel.dontPanel.language == .swift)
    }
    
    @Test("init creates distinct panels")
    func initCreatesDistinctPanels() {
        let viewModel = AppViewModel()
        
        #expect(viewModel.doPanel.id != viewModel.dontPanel.id)
    }
    
    // MARK: - setLanguage
    
    @Test("setLanguage updates doPanel language")
    func setLanguageUpdatesDoPanelLanguage() {
        let viewModel = AppViewModel()
        
        viewModel.setLanguage(.python)
        
        #expect(viewModel.doPanel.language == .python)
    }
    
    @Test("setLanguage updates dontPanel language")
    func setLanguageUpdatesDontPanelLanguage() {
        let viewModel = AppViewModel()
        
        viewModel.setLanguage(.python)
        
        #expect(viewModel.dontPanel.language == .python)
    }
    
    @Test("setLanguage updates both panels simultaneously")
    func setLanguageUpdatesBothPanels() {
        let viewModel = AppViewModel()
        
        viewModel.setLanguage(.javascript)
        
        #expect(viewModel.doPanel.language == .javascript)
        #expect(viewModel.dontPanel.language == .javascript)
    }
    
    @Test("setLanguage can be called multiple times")
    func setLanguageMultipleTimes() {
        let viewModel = AppViewModel()
        
        viewModel.setLanguage(.python)
        #expect(viewModel.doPanel.language == .python)
        
        viewModel.setLanguage(.rust)
        #expect(viewModel.doPanel.language == .rust)
        
        viewModel.setLanguage(.swift)
        #expect(viewModel.doPanel.language == .swift)
    }
    
    @Test("setLanguage supports common programming languages")
    func setLanguageSupportsCommonLanguages() {
        let viewModel = AppViewModel()
        let languages: [CodeLanguage] = [
            .swift, .python, .javascript, .typescript,
            .java, .kotlin, .rust, .go, .c, .cpp
        ]
        
        for language in languages {
            viewModel.setLanguage(language)
            #expect(viewModel.doPanel.language == language)
            #expect(viewModel.dontPanel.language == language)
        }
    }
    
    @Test("setLanguage does not affect panel code")
    func setLanguageDoesNotAffectCode() {
        let viewModel = AppViewModel()
        viewModel.doPanel.code = "let x = 1"
        viewModel.dontPanel.code = "let y = 2"
        
        viewModel.setLanguage(.python)
        
        #expect(viewModel.doPanel.code == "let x = 1")
        #expect(viewModel.dontPanel.code == "let y = 2")
    }
    
    @Test("setLanguage does not affect panel titles")
    func setLanguageDoesNotAffectTitles() {
        let viewModel = AppViewModel()
        viewModel.doPanel.title = "Do Title"
        viewModel.dontPanel.title = "Dont Title"
        
        viewModel.setLanguage(.python)
        
        #expect(viewModel.doPanel.title == "Do Title")
        #expect(viewModel.dontPanel.title == "Dont Title")
    }
    
    // MARK: - update(doTitle:dontTitle:)
    
    @Test("update updates doPanel title")
    func updateUpdatesDoPanelTitle() {
        let viewModel = AppViewModel()
        
        viewModel.update(doTitle: "New Do Title", dontTitle: "New Dont Title")
        
        #expect(viewModel.doPanel.title == "New Do Title")
    }
    
    @Test("update updates dontPanel title")
    func updateUpdatesDontPanelTitle() {
        let viewModel = AppViewModel()
        
        viewModel.update(doTitle: "New Do Title", dontTitle: "New Dont Title")
        
        #expect(viewModel.dontPanel.title == "New Dont Title")
    }
    
    @Test("update can set empty titles")
    func updateCanSetEmptyTitles() {
        let viewModel = AppViewModel()
        viewModel.doPanel.title = "Existing"
        viewModel.dontPanel.title = "Existing"
        
        viewModel.update(doTitle: "", dontTitle: "")
        
        #expect(viewModel.doPanel.title.isEmpty)
        #expect(viewModel.dontPanel.title.isEmpty)
    }
    
    @Test("update can set long titles")
    func updateCanSetLongTitles() {
        let viewModel = AppViewModel()
        let longTitle = String(repeating: "A", count: 100)
        
        viewModel.update(doTitle: longTitle, dontTitle: longTitle)
        
        #expect(viewModel.doPanel.title == longTitle)
        #expect(viewModel.dontPanel.title == longTitle)
    }
    
    @Test("update can set titles with special characters")
    func updateCanSetTitlesWithSpecialCharacters() {
        let viewModel = AppViewModel()
        
        viewModel.update(doTitle: "Title with 🎉 emoji", dontTitle: "Title & <special> chars")
        
        #expect(viewModel.doPanel.title == "Title with 🎉 emoji")
        #expect(viewModel.dontPanel.title == "Title & <special> chars")
    }
    
    @Test("update does not affect panel code")
    func updateDoesNotAffectCode() {
        let viewModel = AppViewModel()
        viewModel.doPanel.code = "let x = 1"
        viewModel.dontPanel.code = "let y = 2"
        
        viewModel.update(doTitle: "New Title", dontTitle: "New Title")
        
        #expect(viewModel.doPanel.code == "let x = 1")
        #expect(viewModel.dontPanel.code == "let y = 2")
    }
    
    @Test("update does not affect panel language")
    func updateDoesNotAffectLanguage() {
        let viewModel = AppViewModel()
        viewModel.setLanguage(.python)
        
        viewModel.update(doTitle: "New Title", dontTitle: "New Title")
        
        #expect(viewModel.doPanel.language == .python)
        #expect(viewModel.dontPanel.language == .python)
    }
    
    // MARK: - Save Location
    
    @Test("saveLocation returns a valid URL")
    func saveLocationReturnsValidURL() {
        let viewModel = AppViewModel()
        
        let location = viewModel.saveLocation
        
        #expect(location.isFileURL)
    }
    
    @Test("saveLocation defaults to Desktop when no bookmark")
    func saveLocationDefaultsToDesktop() {
        // Clear any existing bookmark first
        BookmarkManager.shared.clearBookmark()
        
        let viewModel = AppViewModel()
        let location = viewModel.saveLocation
        
        // Should contain Desktop in path
        #expect(location.path.contains("Desktop"))
    }
    
    @Test("saveLocationName returns 'Desktop' by default")
    func saveLocationNameDefault() {
        BookmarkManager.shared.clearBookmark()
        
        let viewModel = AppViewModel()
        
        #expect(viewModel.saveLocationName == "Desktop")
    }
    
    @Test("hasCustomSaveLocation is false when no bookmark")
    func hasCustomSaveLocationFalseByDefault() {
        BookmarkManager.shared.clearBookmark()
        
        let viewModel = AppViewModel()
        
        #expect(viewModel.hasCustomSaveLocation == false)
    }
    
    // MARK: - Panel Independence
    
    @Test("modifying doPanel code does not affect dontPanel")
    func doPanelCodeIndependent() {
        let viewModel = AppViewModel()
        
        viewModel.doPanel.code = "modified"
        
        #expect(viewModel.dontPanel.code.isEmpty)
    }
    
    @Test("modifying dontPanel code does not affect doPanel")
    func dontPanelCodeIndependent() {
        let viewModel = AppViewModel()
        
        viewModel.dontPanel.code = "modified"
        
        #expect(viewModel.doPanel.code.isEmpty)
    }
    
    @Test("panels have independent titles when set individually")
    func panelTitlesIndependent() {
        let viewModel = AppViewModel()
        
        viewModel.doPanel.title = "Do Title Only"
        
        #expect(viewModel.doPanel.title == "Do Title Only")
        #expect(viewModel.dontPanel.title.isEmpty)
    }
    
    // MARK: - Observable Behavior
    
    @Test("panels are accessible properties")
    func panelsAccessible() {
        let viewModel = AppViewModel()
        
        // Verify panels are publicly accessible
        let _: CodePanel = viewModel.doPanel
        let _: CodePanel = viewModel.dontPanel
    }
    
    // MARK: - Multiple ViewModel Instances
    
    @Test("multiple viewModel instances are independent")
    func multipleInstancesIndependent() {
        let viewModel1 = AppViewModel()
        let viewModel2 = AppViewModel()
        
        viewModel1.doPanel.code = "Code 1"
        viewModel2.doPanel.code = "Code 2"
        viewModel1.setLanguage(.python)
        
        #expect(viewModel1.doPanel.code == "Code 1")
        #expect(viewModel2.doPanel.code == "Code 2")
        #expect(viewModel1.doPanel.language == .python)
        #expect(viewModel2.doPanel.language == .swift)
    }
}

// MARK: - ExportError Tests

@Suite("ExportError Tests")
struct ExportErrorTests {
    // MARK: - Error Cases
    
    @Test("conversionFailed is a valid case")
    func conversionFailedCase() {
        let error = ExportError.conversionFailed
        #expect(error == .conversionFailed)
    }
    
    @Test("saveFailed is a valid case")
    func saveFailedCase() {
        let error = ExportError.saveFailed
        #expect(error == .saveFailed)
    }
    
    @Test("accessDenied is a valid case")
    func accessDeniedCase() {
        let error = ExportError.accessDenied
        #expect(error == .accessDenied)
    }
    
    // MARK: - Error Descriptions
    
    @Test("conversionFailed has correct error description")
    func conversionFailedDescription() {
        let error = ExportError.conversionFailed
        
        #expect(error.errorDescription == "Failed to convert image to PNG")
    }
    
    @Test("saveFailed has correct error description")
    func saveFailedDescription() {
        let error = ExportError.saveFailed
        
        #expect(error.errorDescription == "Failed to save image")
    }
    
    @Test("accessDenied has correct error description")
    func accessDeniedDescription() {
        let error = ExportError.accessDenied
        
        #expect(error.errorDescription == "Cannot access save location. Please choose a new folder.")
    }
    
    // MARK: - LocalizedError Conformance
    
    @Test("ExportError conforms to LocalizedError")
    func localizedErrorConformance() {
        let error: any LocalizedError = ExportError.conversionFailed
        
        #expect(error.errorDescription != nil)
    }
    
    @Test("all error descriptions are non-empty")
    func allDescriptionsNonEmpty() {
        let errors: [ExportError] = [.conversionFailed, .saveFailed, .accessDenied]
        
        for error in errors {
            #expect(error.errorDescription?.isEmpty == false)
        }
    }
    
    // MARK: - Equality
    
    @Test("same error cases are equal")
    func sameErrorCasesEqual() {
        #expect(ExportError.conversionFailed == ExportError.conversionFailed)
        #expect(ExportError.saveFailed == ExportError.saveFailed)
        #expect(ExportError.accessDenied == ExportError.accessDenied)
    }
    
    @Test("different error cases are not equal")
    func differentErrorCasesNotEqual() {
        #expect(ExportError.conversionFailed != ExportError.saveFailed)
        #expect(ExportError.saveFailed != ExportError.accessDenied)
        #expect(ExportError.accessDenied != ExportError.conversionFailed)
    }
    
    // MARK: - Error can be thrown
    
    @Test("conversionFailed can be thrown and caught")
    func conversionFailedCanBeThrown() async {
        func throwingFunction() throws {
            throw ExportError.conversionFailed
        }
        
        var caughtError: ExportError?
        do {
            try throwingFunction()
        } catch let error as ExportError {
            caughtError = error
        } catch {
            // Other error type
        }
        
        #expect(caughtError == .conversionFailed)
    }
    
    @Test("saveFailed can be thrown and caught")
    func saveFailedCanBeThrown() async {
        func throwingFunction() throws {
            throw ExportError.saveFailed
        }
        
        var caughtError: ExportError?
        do {
            try throwingFunction()
        } catch let error as ExportError {
            caughtError = error
        } catch {
            // Other error type
        }
        
        #expect(caughtError == .saveFailed)
    }
    
    @Test("accessDenied can be thrown and caught")
    func accessDeniedCanBeThrown() async {
        func throwingFunction() throws {
            throw ExportError.accessDenied
        }
        
        var caughtError: ExportError?
        do {
            try throwingFunction()
        } catch let error as ExportError {
            caughtError = error
        } catch {
            // Other error type
        }
        
        #expect(caughtError == .accessDenied)
    }
}
