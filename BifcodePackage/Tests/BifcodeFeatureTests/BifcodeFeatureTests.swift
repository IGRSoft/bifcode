//
//  BifcodeFeatureTests.swift
//
//  Created on 17.12.2025.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import Testing
@testable import BifcodeFeature

// MARK: - Module Import Tests

@Suite("BifcodeFeature Module Tests")
struct BifcodeFeatureModuleTests {
    @Test("BifcodeFeature module imports successfully")
    func moduleImports() {
        // If this test runs, the module is importable
        #expect(true)
    }
    
    @Test("All public types are accessible")
    func publicTypesAccessible() {
        // Models
        _ = PanelType.doPanel
        _ = IndicatorPosition.topRight
        _ = IndicatorStyle.iconAndText
        _ = IndicatorIcon.checkmark
        _ = WindowLayout.horizontal
        _ = EditorThemeOption.atomOneDark
        
        // Errors
        _ = ExportError.conversionFailed
        
        #expect(true)
    }
    
    @Test("All enum allCases are accessible")
    func allCasesAccessible() {
        #expect(!IndicatorPosition.allCases.isEmpty)
        #expect(!IndicatorStyle.allCases.isEmpty)
        #expect(!IndicatorIcon.allCases.isEmpty)
        #expect(!WindowLayout.allCases.isEmpty)
        #expect(!EditorThemeOption.allCases.isEmpty)
    }
}

// MARK: - Edge Case Tests

@Suite("Edge Case Tests")
@MainActor
struct EdgeCaseTests {
    // MARK: - Empty String Handling
    
    @Test("CodePanel handles empty code")
    func emptyCodeHandling() {
        let panel = CodePanel(type: .doPanel)
        
        #expect(panel.code.isEmpty)
        panel.code = ""
        #expect(panel.code.isEmpty)
    }
    
    @Test("CodePanel handles empty title")
    func emptyTitleHandling() {
        let panel = CodePanel(type: .doPanel, title: "")
        
        #expect(panel.title.isEmpty)
    }
    
    @Test("AppViewModel handles empty titles in update")
    func emptyTitlesInUpdate() {
        let viewModel = AppViewModel()
        viewModel.update(doTitle: "", dontTitle: "")
        
        #expect(viewModel.doPanel.title.isEmpty)
        #expect(viewModel.dontPanel.title.isEmpty)
    }
    
    // MARK: - Unicode and Special Characters
    
    @Test("CodePanel handles unicode in code")
    func unicodeInCode() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "let greeting = \"こんにちは\""
        
        #expect(panel.code.contains("こんにちは"))
    }
    
    @Test("CodePanel handles emoji in code")
    func emojiInCode() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "let emoji = \"🎉🚀💻\""
        
        #expect(panel.code.contains("🎉"))
        #expect(panel.code.contains("🚀"))
        #expect(panel.code.contains("💻"))
    }
    
    @Test("CodePanel handles unicode in title")
    func unicodeInTitle() {
        let panel = CodePanel(type: .doPanel, title: "例: 日本語タイトル")
        
        #expect(panel.title.contains("日本語"))
    }
    
    @Test("AppViewModel handles unicode in titles")
    func unicodeInTitles() {
        let viewModel = AppViewModel()
        viewModel.update(doTitle: "做正確的事", dontTitle: "避免這個")
        
        #expect(viewModel.doPanel.title == "做正確的事")
        #expect(viewModel.dontPanel.title == "避免這個")
    }
    
    // MARK: - Whitespace Handling
    
    @Test("CodePanel preserves leading/trailing whitespace in code")
    func whitespaceInCode() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "  let x = 1  "
        
        #expect(panel.code.hasPrefix("  "))
        #expect(panel.code.hasSuffix("  "))
    }
    
    @Test("CodePanel preserves newlines in code")
    func newlinesInCode() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "line1\nline2\nline3"
        
        let lines = panel.code.components(separatedBy: "\n")
        #expect(lines.count == 3)
    }
    
    @Test("CodePanel preserves tabs in code")
    func tabsInCode() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "func test() {\n\tlet x = 1\n}"
        
        #expect(panel.code.contains("\t"))
    }
    
    // MARK: - Boundary Values
    
    @Test("IndicatorIcon collections have no overlap")
    func iconCollectionsNoOverlap() {
        let positiveSet = Set(IndicatorIcon.positiveIcons)
        let negativeSet = Set(IndicatorIcon.negativeIcons)
        
        let intersection = positiveSet.intersection(negativeSet)
        #expect(intersection.isEmpty)
    }
    
    @Test("All IndicatorIcon cases are in either positive or negative")
    func allIconsCategorized() {
        let allSet = Set(IndicatorIcon.allCases)
        let positiveSet = Set(IndicatorIcon.positiveIcons)
        let negativeSet = Set(IndicatorIcon.negativeIcons)
        
        #expect(allSet == positiveSet.union(negativeSet))
    }
    
    // MARK: - State Consistency
    
    @Test("CodePanel type is immutable")
    func panelTypeImmutable() {
        let doPanel = CodePanel(type: .doPanel)
        let dontPanel = CodePanel(type: .dontPanel)
        
        // Type should not change regardless of other property changes
        doPanel.code = "test"
        doPanel.title = "test"
        
        #expect(doPanel.type == .doPanel)
        #expect(dontPanel.type == .dontPanel)
    }
    
    @Test("AppViewModel panels are distinct objects")
    func viewModelPanelsDistinct() {
        let viewModel = AppViewModel()
        
        // Verify they are different objects
        viewModel.doPanel.code = "do code"
        #expect(viewModel.dontPanel.code != "do code")
        
        viewModel.dontPanel.title = "dont title"
        #expect(viewModel.doPanel.title != "dont title")
    }
}

// MARK: - Performance Characteristic Tests

@Suite("Performance Characteristic Tests")
@MainActor
struct PerformanceTests {
    @Test("Large code content handling")
    func largeCodeContent() {
        let panel = CodePanel(type: .doPanel)
        
        // Create a large code string (1000 lines)
        let largeCode = (1...1000).map { "let line\($0) = \($0)" }.joined(separator: "\n")
        panel.code = largeCode
        
        // Should handle without issues
        #expect(panel.code.contains("line1"))
        #expect(panel.code.contains("line500"))
        #expect(panel.code.contains("line1000"))
    }
    
    @Test("Rapid language changes")
    func rapidLanguageChanges() {
        let viewModel = AppViewModel()
        let languages: [CodeLanguage] = [
            .swift, .python, .javascript, .typescript, .java,
            .kotlin, .rust, .go, .c, .cpp
        ]
        
        // Rapidly change languages
        for _ in 1...100 {
            for language in languages {
                viewModel.setLanguage(language)
            }
        }
        
        // Final state should be consistent
        #expect(viewModel.doPanel.language == .cpp)
        #expect(viewModel.dontPanel.language == .cpp)
    }
    
    @Test("Rapid title updates")
    func rapidTitleUpdates() {
        let viewModel = AppViewModel()
        
        // Rapidly update titles
        for i in 1...100 {
            viewModel.update(doTitle: "Do \(i)", dontTitle: "Dont \(i)")
        }
        
        // Final state should be consistent
        #expect(viewModel.doPanel.title == "Do 100")
        #expect(viewModel.dontPanel.title == "Dont 100")
    }
}
