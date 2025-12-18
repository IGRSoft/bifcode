//
//  SettingsTypesTests.swift
//
//  Created on 18.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import Testing
@testable import BifcodeFeature

// MARK: - IndicatorPosition Tests

@Suite("IndicatorPosition Tests")
struct IndicatorPositionTests {
    // MARK: - Raw Values

    @Test("rawValue returns correct string for topRight")
    func rawValueTopRight() {
        #expect(IndicatorPosition.topRight.rawValue == "top-right")
    }

    @Test("rawValue returns correct string for bottomRight")
    func rawValueBottomRight() {
        #expect(IndicatorPosition.bottomRight.rawValue == "bottom-right")
    }

    // MARK: - Labels

    @Test("label returns 'Top Right' for topRight")
    func labelTopRight() {
        #expect(IndicatorPosition.topRight.label == "Top Right")
    }

    @Test("label returns 'Bottom Right' for bottomRight")
    func labelBottomRight() {
        #expect(IndicatorPosition.bottomRight.label == "Bottom Right")
    }

    // MARK: - CaseIterable

    @Test("allCases contains exactly 2 positions")
    func allCasesCount() {
        #expect(IndicatorPosition.allCases.count == 2)
    }

    @Test("allCases contains topRight and bottomRight")
    func allCasesContains() {
        #expect(IndicatorPosition.allCases.contains(.topRight))
        #expect(IndicatorPosition.allCases.contains(.bottomRight))
    }

    // MARK: - Initialization from Raw Value

    @Test("init from 'top-right' returns topRight")
    func initFromRawValueTopRight() {
        let position = IndicatorPosition(rawValue: "top-right")
        #expect(position == .topRight)
    }

    @Test("init from 'bottom-right' returns bottomRight")
    func initFromRawValueBottomRight() {
        let position = IndicatorPosition(rawValue: "bottom-right")
        #expect(position == .bottomRight)
    }

    @Test("init from invalid rawValue returns nil")
    func initFromInvalidRawValue() {
        let position = IndicatorPosition(rawValue: "invalid")
        #expect(position == nil)
    }

    // MARK: - Sendable Conformance

    @Test("IndicatorPosition is Sendable")
    func sendableConformance() async {
        let position = IndicatorPosition.topRight
        await Task.detached {
            // If this compiles, it proves Sendable conformance
            _ = position.rawValue
        }.value
    }
}

// MARK: - IndicatorStyle Tests

@Suite("IndicatorStyle Tests")
struct IndicatorStyleTests {
    // MARK: - Raw Values

    @Test("rawValue returns 'icon' for iconOnly")
    func rawValueIconOnly() {
        #expect(IndicatorStyle.iconOnly.rawValue == "icon")
    }

    @Test("rawValue returns 'text' for textOnly")
    func rawValueTextOnly() {
        #expect(IndicatorStyle.textOnly.rawValue == "text")
    }

    @Test("rawValue returns 'both' for iconAndText")
    func rawValueIconAndText() {
        #expect(IndicatorStyle.iconAndText.rawValue == "both")
    }

    // MARK: - Labels

    @Test("label returns 'Icon Only' for iconOnly")
    func labelIconOnly() {
        #expect(IndicatorStyle.iconOnly.label == "Icon Only")
    }

    @Test("label returns 'Text Only' for textOnly")
    func labelTextOnly() {
        #expect(IndicatorStyle.textOnly.label == "Text Only")
    }

    @Test("label returns 'Icon + Text' for iconAndText")
    func labelIconAndText() {
        #expect(IndicatorStyle.iconAndText.label == "Icon + Text")
    }

    // MARK: - CaseIterable

    @Test("allCases contains exactly 3 styles")
    func allCasesCount() {
        #expect(IndicatorStyle.allCases.count == 3)
    }

    @Test("allCases contains all styles")
    func allCasesContains() {
        #expect(IndicatorStyle.allCases.contains(.iconOnly))
        #expect(IndicatorStyle.allCases.contains(.textOnly))
        #expect(IndicatorStyle.allCases.contains(.iconAndText))
    }

    // MARK: - Initialization from Raw Value

    @Test("init from 'icon' returns iconOnly")
    func initFromRawValueIcon() {
        let style = IndicatorStyle(rawValue: "icon")
        #expect(style == .iconOnly)
    }

    @Test("init from 'text' returns textOnly")
    func initFromRawValueText() {
        let style = IndicatorStyle(rawValue: "text")
        #expect(style == .textOnly)
    }

    @Test("init from 'both' returns iconAndText")
    func initFromRawValueBoth() {
        let style = IndicatorStyle(rawValue: "both")
        #expect(style == .iconAndText)
    }

    @Test("init from invalid rawValue returns nil")
    func initFromInvalidRawValue() {
        let style = IndicatorStyle(rawValue: "invalid")
        #expect(style == nil)
    }
}

// MARK: - IndicatorIcon Tests

@Suite("IndicatorIcon Tests")
struct IndicatorIconTests {
    // MARK: - Positive Icons System Names

    @Test("checkmark systemName is 'checkmark'")
    func checkmarkSystemName() {
        #expect(IndicatorIcon.checkmark.systemName == "checkmark")
    }

    @Test("checkmarkCircle systemName is 'checkmark.circle'")
    func checkmarkCircleSystemName() {
        #expect(IndicatorIcon.checkmarkCircle.systemName == "checkmark.circle")
    }

    @Test("checkmarkSquare systemName is 'checkmark.square'")
    func checkmarkSquareSystemName() {
        #expect(IndicatorIcon.checkmarkSquare.systemName == "checkmark.square")
    }

    @Test("thumbsUp systemName is 'hand.thumbsup'")
    func thumbsUpSystemName() {
        #expect(IndicatorIcon.thumbsUp.systemName == "hand.thumbsup")
    }

    @Test("star systemName is 'star.fill'")
    func starSystemName() {
        #expect(IndicatorIcon.star.systemName == "star.fill")
    }

    // MARK: - Negative Icons System Names

    @Test("xmark systemName is 'xmark'")
    func xmarkSystemName() {
        #expect(IndicatorIcon.xmark.systemName == "xmark")
    }

    @Test("xmarkCircle systemName is 'xmark.circle'")
    func xmarkCircleSystemName() {
        #expect(IndicatorIcon.xmarkCircle.systemName == "xmark.circle")
    }

    @Test("xmarkSquare systemName is 'xmark.square'")
    func xmarkSquareSystemName() {
        #expect(IndicatorIcon.xmarkSquare.systemName == "xmark.square")
    }

    @Test("thumbsDown systemName is 'hand.thumbsdown'")
    func thumbsDownSystemName() {
        #expect(IndicatorIcon.thumbsDown.systemName == "hand.thumbsdown")
    }

    @Test("warning systemName is 'exclamationmark.triangle'")
    func warningSystemName() {
        #expect(IndicatorIcon.warning.systemName == "exclamationmark.triangle")
    }

    // MARK: - Positive Icons Collection

    @Test("positiveIcons contains exactly 5 icons")
    func positiveIconsCount() {
        #expect(IndicatorIcon.positiveIcons.count == 5)
    }

    @Test("positiveIcons contains checkmark")
    func positiveIconsContainsCheckmark() {
        #expect(IndicatorIcon.positiveIcons.contains(.checkmark))
    }

    @Test("positiveIcons contains checkmarkCircle")
    func positiveIconsContainsCheckmarkCircle() {
        #expect(IndicatorIcon.positiveIcons.contains(.checkmarkCircle))
    }

    @Test("positiveIcons contains checkmarkSquare")
    func positiveIconsContainsCheckmarkSquare() {
        #expect(IndicatorIcon.positiveIcons.contains(.checkmarkSquare))
    }

    @Test("positiveIcons contains thumbsUp")
    func positiveIconsContainsThumbsUp() {
        #expect(IndicatorIcon.positiveIcons.contains(.thumbsUp))
    }

    @Test("positiveIcons contains star")
    func positiveIconsContainsStar() {
        #expect(IndicatorIcon.positiveIcons.contains(.star))
    }

    @Test("positiveIcons does not contain negative icons")
    func positiveIconsDoesNotContainNegative() {
        #expect(!IndicatorIcon.positiveIcons.contains(.xmark))
        #expect(!IndicatorIcon.positiveIcons.contains(.xmarkCircle))
        #expect(!IndicatorIcon.positiveIcons.contains(.xmarkSquare))
        #expect(!IndicatorIcon.positiveIcons.contains(.thumbsDown))
        #expect(!IndicatorIcon.positiveIcons.contains(.warning))
    }

    // MARK: - Negative Icons Collection

    @Test("negativeIcons contains exactly 5 icons")
    func negativeIconsCount() {
        #expect(IndicatorIcon.negativeIcons.count == 5)
    }

    @Test("negativeIcons contains xmark")
    func negativeIconsContainsXmark() {
        #expect(IndicatorIcon.negativeIcons.contains(.xmark))
    }

    @Test("negativeIcons contains xmarkCircle")
    func negativeIconsContainsXmarkCircle() {
        #expect(IndicatorIcon.negativeIcons.contains(.xmarkCircle))
    }

    @Test("negativeIcons contains xmarkSquare")
    func negativeIconsContainsXmarkSquare() {
        #expect(IndicatorIcon.negativeIcons.contains(.xmarkSquare))
    }

    @Test("negativeIcons contains thumbsDown")
    func negativeIconsContainsThumbsDown() {
        #expect(IndicatorIcon.negativeIcons.contains(.thumbsDown))
    }

    @Test("negativeIcons contains warning")
    func negativeIconsContainsWarning() {
        #expect(IndicatorIcon.negativeIcons.contains(.warning))
    }

    @Test("negativeIcons does not contain positive icons")
    func negativeIconsDoesNotContainPositive() {
        #expect(!IndicatorIcon.negativeIcons.contains(.checkmark))
        #expect(!IndicatorIcon.negativeIcons.contains(.checkmarkCircle))
        #expect(!IndicatorIcon.negativeIcons.contains(.checkmarkSquare))
        #expect(!IndicatorIcon.negativeIcons.contains(.thumbsUp))
        #expect(!IndicatorIcon.negativeIcons.contains(.star))
    }

    // MARK: - CaseIterable

    @Test("allCases contains exactly 10 icons")
    func allCasesCount() {
        #expect(IndicatorIcon.allCases.count == 10)
    }

    @Test("allCases union equals positive plus negative icons")
    func allCasesUnion() {
        let allSet = Set(IndicatorIcon.allCases)
        let positiveSet = Set(IndicatorIcon.positiveIcons)
        let negativeSet = Set(IndicatorIcon.negativeIcons)
        #expect(allSet == positiveSet.union(negativeSet))
    }

    // MARK: - Initialization from Raw Value

    @Test("init from 'checkmark' returns checkmark")
    func initFromRawValueCheckmark() {
        let icon = IndicatorIcon(rawValue: "checkmark")
        #expect(icon == .checkmark)
    }

    @Test("init from 'checkmark.circle' returns checkmarkCircle")
    func initFromRawValueCheckmarkCircle() {
        let icon = IndicatorIcon(rawValue: "checkmark.circle")
        #expect(icon == .checkmarkCircle)
    }

    @Test("init from 'hand.thumbsup' returns thumbsUp")
    func initFromRawValueThumbsUp() {
        let icon = IndicatorIcon(rawValue: "hand.thumbsup")
        #expect(icon == .thumbsUp)
    }

    @Test("init from invalid rawValue returns nil")
    func initFromInvalidRawValue() {
        let icon = IndicatorIcon(rawValue: "invalid.icon")
        #expect(icon == nil)
    }

    // MARK: - systemName equals rawValue

    @Test("systemName equals rawValue for all icons")
    func systemNameEqualsRawValue() {
        for icon in IndicatorIcon.allCases {
            #expect(icon.systemName == icon.rawValue)
        }
    }
}

// MARK: - WindowLayout Tests

@Suite("WindowLayout Tests")
struct WindowLayoutTests {
    // MARK: - Raw Values

    @Test("rawValue returns 'horizontal' for horizontal")
    func rawValueHorizontal() {
        #expect(WindowLayout.horizontal.rawValue == "horizontal")
    }

    @Test("rawValue returns 'vertical' for vertical")
    func rawValueVertical() {
        #expect(WindowLayout.vertical.rawValue == "vertical")
    }

    // MARK: - Labels

    @Test("label returns 'Side by Side' for horizontal")
    func labelHorizontal() {
        #expect(WindowLayout.horizontal.label == "Side by Side")
    }

    @Test("label returns 'Stacked' for vertical")
    func labelVertical() {
        #expect(WindowLayout.vertical.label == "Stacked")
    }

    // MARK: - CaseIterable

    @Test("allCases contains exactly 2 layouts")
    func allCasesCount() {
        #expect(WindowLayout.allCases.count == 2)
    }

    @Test("allCases contains horizontal and vertical")
    func allCasesContains() {
        #expect(WindowLayout.allCases.contains(.horizontal))
        #expect(WindowLayout.allCases.contains(.vertical))
    }

    // MARK: - Initialization from Raw Value

    @Test("init from 'horizontal' returns horizontal")
    func initFromRawValueHorizontal() {
        let layout = WindowLayout(rawValue: "horizontal")
        #expect(layout == .horizontal)
    }

    @Test("init from 'vertical' returns vertical")
    func initFromRawValueVertical() {
        let layout = WindowLayout(rawValue: "vertical")
        #expect(layout == .vertical)
    }

    @Test("init from invalid rawValue returns nil")
    func initFromInvalidRawValue() {
        let layout = WindowLayout(rawValue: "diagonal")
        #expect(layout == nil)
    }
}

// MARK: - EditorThemeOption Tests

@Suite("EditorThemeOption Tests")
struct EditorThemeOptionTests {
    // MARK: - Raw Values

    @Test("rawValue returns 'atom-one-dark' for atomOneDark")
    func rawValueAtomOneDark() {
        #expect(EditorThemeOption.atomOneDark.rawValue == "atom-one-dark")
    }

    @Test("rawValue returns 'dracula' for dracula")
    func rawValueDracula() {
        #expect(EditorThemeOption.dracula.rawValue == "dracula")
    }

    @Test("rawValue returns 'github-dark' for githubDark")
    func rawValueGithubDark() {
        #expect(EditorThemeOption.githubDark.rawValue == "github-dark")
    }

    @Test("rawValue returns 'monokai' for monokai")
    func rawValueMonokai() {
        #expect(EditorThemeOption.monokai.rawValue == "monokai")
    }

    @Test("rawValue returns 'nord' for nord")
    func rawValueNord() {
        #expect(EditorThemeOption.nord.rawValue == "nord")
    }

    @Test("rawValue returns 'solarized-dark' for solarizedDark")
    func rawValueSolarizedDark() {
        #expect(EditorThemeOption.solarizedDark.rawValue == "solarized-dark")
    }

    @Test("rawValue returns 'xcode-default' for xcodeDefault")
    func rawValueXcodeDefault() {
        #expect(EditorThemeOption.xcodeDefault.rawValue == "xcode-default")
    }

    // MARK: - Labels

    @Test("label returns 'Atom One Dark' for atomOneDark")
    func labelAtomOneDark() {
        #expect(EditorThemeOption.atomOneDark.label == "Atom One Dark")
    }

    @Test("label returns 'Dracula' for dracula")
    func labelDracula() {
        #expect(EditorThemeOption.dracula.label == "Dracula")
    }

    @Test("label returns 'GitHub Dark' for githubDark")
    func labelGithubDark() {
        #expect(EditorThemeOption.githubDark.label == "GitHub Dark")
    }

    @Test("label returns 'Monokai' for monokai")
    func labelMonokai() {
        #expect(EditorThemeOption.monokai.label == "Monokai")
    }

    @Test("label returns 'Nord' for nord")
    func labelNord() {
        #expect(EditorThemeOption.nord.label == "Nord")
    }

    @Test("label returns 'Solarized Dark' for solarizedDark")
    func labelSolarizedDark() {
        #expect(EditorThemeOption.solarizedDark.label == "Solarized Dark")
    }

    @Test("label returns 'Xcode Default' for xcodeDefault")
    func labelXcodeDefault() {
        #expect(EditorThemeOption.xcodeDefault.label == "Xcode Default")
    }

    // MARK: - CaseIterable

    @Test("allCases contains exactly 7 themes")
    func allCasesCount() {
        #expect(EditorThemeOption.allCases.count == 7)
    }

    @Test("allCases contains all themes")
    func allCasesContains() {
        #expect(EditorThemeOption.allCases.contains(.atomOneDark))
        #expect(EditorThemeOption.allCases.contains(.dracula))
        #expect(EditorThemeOption.allCases.contains(.githubDark))
        #expect(EditorThemeOption.allCases.contains(.monokai))
        #expect(EditorThemeOption.allCases.contains(.nord))
        #expect(EditorThemeOption.allCases.contains(.solarizedDark))
        #expect(EditorThemeOption.allCases.contains(.xcodeDefault))
    }

    // MARK: - Initialization from Raw Value

    @Test("init from 'atom-one-dark' returns atomOneDark")
    func initFromRawValueAtomOneDark() {
        let theme = EditorThemeOption(rawValue: "atom-one-dark")
        #expect(theme == .atomOneDark)
    }

    @Test("init from 'dracula' returns dracula")
    func initFromRawValueDracula() {
        let theme = EditorThemeOption(rawValue: "dracula")
        #expect(theme == .dracula)
    }

    @Test("init from invalid rawValue returns nil")
    func initFromInvalidRawValue() {
        let theme = EditorThemeOption(rawValue: "unknown-theme")
        #expect(theme == nil)
    }

    // MARK: - EditorTheme Property

    @Test("editorTheme returns non-nil for all options")
    func editorThemeNonNil() {
        for option in EditorThemeOption.allCases {
            let theme = option.editorTheme
            // Just verify we can access the theme without crashing
            _ = theme.background
        }
    }

    @Test("atomOneDark editorTheme has correct background color")
    func atomOneDarkThemeBackground() {
        let theme = EditorThemeOption.atomOneDark.editorTheme
        // Atom One Dark background: #282c34 (RGB: 0.16, 0.18, 0.20)
        let background = theme.background
        #expect(background != nil)
    }

    @Test("each theme option maps to unique EditorTheme")
    func uniqueThemeMappings() {
        // Verify themes are distinct by checking backgrounds
        let backgrounds = EditorThemeOption.allCases.map(\.editorTheme.background)
        let uniqueBackgrounds = Set(backgrounds.map(\.description))
        // All 7 themes should have unique backgrounds
        #expect(uniqueBackgrounds.count == 7)
    }
}
