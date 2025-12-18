//
//  CodePanelTests.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import CodeEditLanguages
import Foundation
import Testing
@testable import BifcodeFeature

// MARK: - PanelType Tests

@Suite("PanelType Tests")
struct PanelTypeTests {
    // MARK: - Raw Values

    @Test("rawValue returns 'do' for doPanel")
    func rawValueDoPanel() {
        #expect(PanelType.doPanel.rawValue == "do")
    }

    @Test("rawValue returns 'dont' for dontPanel")
    func rawValueDontPanel() {
        #expect(PanelType.dontPanel.rawValue == "dont")
    }

    // MARK: - Initialization from Raw Value

    @Test("init from 'do' returns doPanel")
    func initFromRawValueDo() {
        let type = PanelType(rawValue: "do")
        #expect(type == .doPanel)
    }

    @Test("init from 'dont' returns dontPanel")
    func initFromRawValueDont() {
        let type = PanelType(rawValue: "dont")
        #expect(type == .dontPanel)
    }

    @Test("init from invalid rawValue returns nil")
    func initFromInvalidRawValue() {
        let type = PanelType(rawValue: "maybe")
        #expect(type == nil)
    }

    // MARK: - Sendable Conformance

    @Test("PanelType is Sendable")
    func sendableConformance() async {
        let type = PanelType.doPanel
        await Task.detached {
            // If this compiles, it proves Sendable conformance
            _ = type.rawValue
        }.value
    }

    // MARK: - Equality

    @Test("doPanel equals doPanel")
    func doPanelEquality() {
        #expect(PanelType.doPanel == PanelType.doPanel)
    }

    @Test("dontPanel equals dontPanel")
    func dontPanelEquality() {
        #expect(PanelType.dontPanel == PanelType.dontPanel)
    }

    @Test("doPanel does not equal dontPanel")
    func doPanelNotEqualDontPanel() {
        #expect(PanelType.doPanel != PanelType.dontPanel)
    }
}

// MARK: - CodePanel Tests

@Suite("CodePanel Tests")
@MainActor
struct CodePanelTests {
    // MARK: - Initialization

    @Test("init creates panel with specified type")
    func initWithType() {
        let doPanel = CodePanel(type: .doPanel)
        let dontPanel = CodePanel(type: .dontPanel)

        #expect(doPanel.type == .doPanel)
        #expect(dontPanel.type == .dontPanel)
    }

    @Test("init creates panel with default empty title")
    func initWithDefaultTitle() {
        let panel = CodePanel(type: .doPanel)

        #expect(panel.title == "")
    }

    @Test("init creates panel with specified title")
    func initWithTitle() {
        let panel = CodePanel(type: .doPanel, title: "Best Practices")

        #expect(panel.title == "Best Practices")
    }

    @Test("init creates panel with default Swift language")
    func initWithDefaultLanguage() {
        let panel = CodePanel(type: .doPanel)

        #expect(panel.language == .swift)
    }

    @Test("init creates panel with specified language")
    func initWithLanguage() {
        let panel = CodePanel(type: .doPanel, language: .python)

        #expect(panel.language == .python)
    }

    @Test("init creates panel with all parameters")
    func initWithAllParameters() {
        let panel = CodePanel(type: .dontPanel, title: "Anti-Patterns", language: .javascript)

        #expect(panel.type == .dontPanel)
        #expect(panel.title == "Anti-Patterns")
        #expect(panel.language == .javascript)
    }

    @Test("init creates panel with empty code")
    func initWithEmptyCode() {
        let panel = CodePanel(type: .doPanel)

        #expect(panel.code == "")
    }

    @Test("init creates panel with unique id")
    func initWithUniqueId() {
        let panel1 = CodePanel(type: .doPanel)
        let panel2 = CodePanel(type: .doPanel)

        #expect(panel1.id != panel2.id)
    }

    @Test("init creates panel with initialized editorState")
    func initWithEditorState() {
        let panel = CodePanel(type: .doPanel)

        // EditorState should be initialized (not nil)
        _ = panel.editorState
    }

    // MARK: - Property Updates

    @Test("code property can be updated")
    func codeUpdate() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "let x = 1"

        #expect(panel.code == "let x = 1")
    }

    @Test("title property can be updated")
    func titleUpdate() {
        let panel = CodePanel(type: .doPanel)
        panel.title = "New Title"

        #expect(panel.title == "New Title")
    }

    @Test("language property can be updated")
    func languageUpdate() {
        let panel = CodePanel(type: .doPanel)
        panel.language = .rust

        #expect(panel.language == .rust)
    }

    @Test("code can contain multiline text")
    func multilineCode() {
        let panel = CodePanel(type: .doPanel)
        let multilineCode = """
        func hello() {
            print("Hello, World!")
        }
        """
        panel.code = multilineCode

        #expect(panel.code.contains("func hello()"))
        #expect(panel.code.contains("print"))
    }

    @Test("code can contain special characters")
    func codeWithSpecialCharacters() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "let emoji = \"🎉\"; // comment"

        #expect(panel.code.contains("🎉"))
        #expect(panel.code.contains("//"))
    }

    @Test("title can contain special characters")
    func titleWithSpecialCharacters() {
        let panel = CodePanel(type: .doPanel)
        panel.title = "Examples: Swift & Kotlin™"

        #expect(panel.title.contains("&"))
        #expect(panel.title.contains("™"))
    }

    // MARK: - Type Immutability

    @Test("type property is immutable after init")
    func typeImmutable() {
        let panel = CodePanel(type: .doPanel)

        // type is let, so this should not compile:
        // panel.type = .dontPanel

        #expect(panel.type == .doPanel)
    }

    @Test("id property is immutable after init")
    func idImmutable() {
        let panel = CodePanel(type: .doPanel)
        let originalId = panel.id

        // id is let, so this should not compile:
        // panel.id = UUID()

        #expect(panel.id == originalId)
    }

    // MARK: - Identifiable Conformance

    @Test("CodePanel conforms to Identifiable")
    func identifiableConformance() {
        let panel = CodePanel(type: .doPanel)

        // Access id property to verify Identifiable conformance
        let _: UUID = panel.id
    }

    // MARK: - Language Support

    @Test("panel supports common programming languages")
    func languageSupportCommon() {
        let languages: [CodeLanguage] = [
            .swift, .python, .javascript, .typescript,
            .java, .kotlin, .rust, .go, .c, .cpp
        ]

        for language in languages {
            let panel = CodePanel(type: .doPanel, language: language)
            #expect(panel.language == language)
        }
    }

    // MARK: - Edge Cases

    @Test("code can be set to very long string")
    func veryLongCode() {
        let panel = CodePanel(type: .doPanel)
        let longCode = String(repeating: "let x = 1\n", count: 100)
        panel.code = longCode

        #expect(panel.code.count >= 1000)  // 100 * 10 = 1000 chars
    }

    @Test("title can be set to very long string")
    func veryLongTitle() {
        let panel = CodePanel(type: .doPanel)
        let longTitle = String(repeating: "A", count: 200)
        panel.title = longTitle

        #expect(panel.title.count == 200)
    }

    @Test("code can be cleared")
    func clearCode() {
        let panel = CodePanel(type: .doPanel)
        panel.code = "let x = 1"
        panel.code = ""

        #expect(panel.code.isEmpty)
    }

    @Test("title can be cleared")
    func clearTitle() {
        let panel = CodePanel(type: .doPanel)
        panel.title = "Title"
        panel.title = ""

        #expect(panel.title.isEmpty)
    }

    // MARK: - Multiple Panels

    @Test("multiple panels maintain independent state")
    func independentPanels() {
        let panel1 = CodePanel(type: .doPanel, title: "Panel 1")
        let panel2 = CodePanel(type: .dontPanel, title: "Panel 2")

        panel1.code = "Code 1"
        panel2.code = "Code 2"
        panel1.language = .python
        panel2.language = .rust

        #expect(panel1.code == "Code 1")
        #expect(panel2.code == "Code 2")
        #expect(panel1.language == .python)
        #expect(panel2.language == .rust)
        #expect(panel1.title == "Panel 1")
        #expect(panel2.title == "Panel 2")
    }
}
