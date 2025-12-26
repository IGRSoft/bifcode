#!/bin/bash
set -e

# Allow automatic package resolution
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile || true
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution || true

# Trust SPM build plugins (required for SwiftLintPlugin from CodeEditSourceEditor)
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
