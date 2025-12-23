//
//  ToastView.swift
//
//  Created on 23.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

/// The result of an export operation.
///
/// Used to communicate export outcomes to the UI for displaying
/// appropriate toast notifications.
public enum ExportResult: Sendable {
    /// Export completed successfully with the file saved at the given URL.
    case success(URL)

    /// Export failed with the given error.
    case failure(Error)

    /// Whether the export was successful.
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    /// The exported file URL if successful, nil otherwise.
    var fileURL: URL? {
        if case .success(let url) = self { return url }
        return nil
    }

    /// The error if failed, nil otherwise.
    var error: Error? {
        if case .failure(let error) = self { return error }
        return nil
    }
}

/// A toast notification view for displaying export status.
///
/// `ToastView` displays a brief, non-blocking notification at the top of the
/// toolbar area. It shows export success or failure status and provides
/// an interactive action for successful exports.
///
/// ## Overview
///
/// The toast appears with a smooth slide-in animation from the top and
/// automatically dismisses after a configurable timeout. For successful
/// exports, tapping the toast reveals the exported file in Finder.
///
/// ## Usage
///
/// ```swift
/// @State private var exportResult: ExportResult?
///
/// var body: some View {
///     ZStack(alignment: .top) {
///         // Main content...
///
///         if let result = exportResult {
///             ToastView(result: result) {
///                 exportResult = nil
///             }
///         }
///     }
/// }
/// ```
///
/// ## Accessibility
///
/// The toast includes VoiceOver support with descriptive labels and hints.
/// Success toasts announce the action available (reveal in Finder), while
/// error toasts read the error description.
public struct ToastView: View {
    /// The export result to display.
    let result: ExportResult

    /// Callback when the toast should be dismissed.
    let onDismiss: () -> Void

    /// Auto-dismiss timeout in seconds.
    private let dismissTimeout: TimeInterval = 5.0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(result: ExportResult, onDismiss: @escaping () -> Void) {
        self.result = result
        self.onDismiss = onDismiss
    }

    public var body: some View {
        Button(action: handleTap) {
            HStack(spacing: 8) {
                Image(systemName: result.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 16, weight: .medium))

                Text(message)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)

                if result.isSuccess {
                    Image(systemName: "arrow.right.circle")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(result.isSuccess ? "Double-tap to reveal in Finder" : "Double-tap to dismiss")
        .accessibilityAddTraits(result.isSuccess ? .isButton : [])
        .transition(.move(edge: .top).combined(with: .opacity))
        .task {
            try? await Task.sleep(for: .seconds(dismissTimeout))
            onDismiss()
        }
    }

    // MARK: - Computed Properties

    private var message: String {
        if result.isSuccess {
            "Exported successfully"
        } else if let error = result.error {
            error.localizedDescription
        } else {
            "Export failed"
        }
    }

    private var backgroundColor: Color {
        result.isSuccess ? Color.toastSuccess : Color.toastError
    }

    private var foregroundColor: Color {
        .white
    }

    private var accessibilityLabel: String {
        if result.isSuccess {
            "Export successful. Click to reveal file in Finder."
        } else if let error = result.error {
            "Export failed: \(error.localizedDescription)"
        } else {
            "Export failed"
        }
    }

    // MARK: - Actions

    private func handleTap() {
        if let url = result.fileURL {
            revealInFinder(url)
        }
        onDismiss()
    }

    private func revealInFinder(_ url: URL) {
        NSWorkspace.shared.selectFile(
            url.path,
            inFileViewerRootedAtPath: url.deletingLastPathComponent().path
        )
    }
}

// MARK: - Preview

#Preview("Success Toast") {
    VStack {
        Spacer()
        ToastView(
            result: .success(URL(fileURLWithPath: "/Users/test/Desktop/bifcode.png")),
            onDismiss: {}
        )
        Spacer()
    }
    .frame(width: 400, height: 200)
    .background(Color.gray.opacity(0.2))
}

#Preview("Error Toast") {
    VStack {
        Spacer()
        ToastView(
            result: .failure(ExportError.conversionFailed),
            onDismiss: {}
        )
        Spacer()
    }
    .frame(width: 400, height: 200)
    .background(Color.gray.opacity(0.2))
}
