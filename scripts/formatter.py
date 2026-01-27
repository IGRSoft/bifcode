#!/usr/bin/env python3
"""
Swift Code Formatter

Formats Swift files using SwiftFormat and adds proper indentation to blank lines.
By default, only formats files that have been modified (git staged + unstaged changes).

Usage:
    python3 formatter.py                  # Format modified files only
    python3 formatter.py --all [path]     # Format all files in path
    python3 formatter.py --check [path]   # Check only, exit 1 if changes needed
    python3 formatter.py --staged         # Format only staged files (for pre-commit)
    python3 formatter.py --help           # Show help
"""

from __future__ import annotations

import os
import sys
import subprocess
import shutil
from pathlib import Path
from typing import Optional

# File patterns to exclude
EXCLUDE_PATTERNS = [
    '.build',
    'DerivedData',
    'build',
    '.generated.swift',
    '.xcodeproj',
    '.xcworkspace',
    'Pods',
]

# Cache for SwiftFormat availability check
_swiftformat_available: Optional[bool] = None


def is_swiftformat_available() -> bool:
    """Check if SwiftFormat is installed and available."""
    global _swiftformat_available
    if _swiftformat_available is None:
        _swiftformat_available = shutil.which('swiftformat') is not None
    return _swiftformat_available


def should_exclude(path: Path) -> bool:
    """Check if path should be excluded."""
    path_str = str(path)
    return any(pattern in path_str for pattern in EXCLUDE_PATTERNS)


def get_git_root() -> Optional[Path]:
    """Get the git repository root directory."""
    try:
        result = subprocess.run(
            ['git', 'rev-parse', '--show-toplevel'],
            capture_output=True,
            text=True,
            check=True
        )
        return Path(result.stdout.strip())
    except subprocess.CalledProcessError:
        return None


def get_modified_files(staged_only: bool = False) -> list[Path]:
    """Get list of modified Swift files from git."""
    git_root = get_git_root()
    if not git_root:
        return []

    swift_files = []

    # Get staged files
    try:
        result = subprocess.run(
            ['git', 'diff', '--cached', '--name-only', '--diff-filter=ACM'],
            capture_output=True,
            text=True,
            check=True,
            cwd=git_root
        )
        for line in result.stdout.strip().split('\n'):
            if line.endswith('.swift'):
                filepath = git_root / line
                if filepath.exists() and not should_exclude(filepath):
                    swift_files.append(filepath)
    except subprocess.CalledProcessError:
        pass

    # Get unstaged modified files (unless staged_only)
    if not staged_only:
        try:
            result = subprocess.run(
                ['git', 'diff', '--name-only', '--diff-filter=ACM'],
                capture_output=True,
                text=True,
                check=True,
                cwd=git_root
            )
            for line in result.stdout.strip().split('\n'):
                if line.endswith('.swift'):
                    filepath = git_root / line
                    if filepath.exists() and not should_exclude(filepath) and filepath not in swift_files:
                        swift_files.append(filepath)
        except subprocess.CalledProcessError:
            pass

    return sorted(swift_files)


def get_indent_level(line: str) -> int:
    """Get the number of leading spaces in a line."""
    return len(line) - len(line.lstrip(' '))


def calculate_scope_indent(lines: list[str], index: int) -> int:
    """
    Calculate what indentation a blank line should have based on context.
    Look at surrounding non-blank lines to determine the scope level.
    """
    # Look backwards for the previous non-blank line
    prev_indent = 0
    for i in range(index - 1, -1, -1):
        line = lines[i]
        stripped = line.strip()
        if stripped:
            prev_indent = get_indent_level(line)
            # If previous line opens a scope, add 4 spaces
            if stripped.endswith('{') or stripped.endswith(':'):
                prev_indent += 4
            break

    # Look forwards for the next non-blank line
    next_indent = 0
    for i in range(index + 1, len(lines)):
        line = lines[i]
        stripped = line.strip()
        if stripped:
            next_indent = get_indent_level(line)
            # If next line closes a scope, it's at a lower level
            if stripped.startswith('}'):
                next_indent += 4
            break

    # Use the minimum of prev and next indent
    # This handles cases where blank line is between scopes
    return min(prev_indent, next_indent)


def add_blank_line_indentation(filepath: Path, check_only: bool = False) -> bool:
    """
    Add indentation to blank lines in a Swift file.
    Returns True if file was modified (or would be modified in check mode).
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except (IOError, UnicodeDecodeError) as e:
        print(f"Error reading {filepath}: {e}", file=sys.stderr)
        return False

    lines = content.split('\n')
    modified = False
    new_lines = []

    for i, line in enumerate(lines):
        # Check if line is blank (empty or whitespace only)
        if not line.strip():
            # Calculate what indent this blank line should have
            target_indent = calculate_scope_indent(lines, i)

            # Create the indented blank line
            new_line = ' ' * target_indent if target_indent > 0 else ''

            if line != new_line:
                modified = True
                new_lines.append(new_line)
            else:
                new_lines.append(line)
        else:
            new_lines.append(line)

    if modified and not check_only:
        new_content = '\n'.join(new_lines)
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
        except IOError as e:
            print(f"Error writing {filepath}: {e}", file=sys.stderr)
            return False

    return modified


def run_swiftformat(filepath: Path, check_only: bool = False) -> bool:
    """
    Run SwiftFormat on a single file.
    Returns True if file passes (or was formatted successfully).
    Returns True if SwiftFormat is not installed (skip gracefully).
    """
    if not is_swiftformat_available():
        return True  # Skip if not installed

    cmd = ['swiftformat']
    if check_only:
        cmd.append('--lint')
    cmd.append(str(filepath))

    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0 and check_only:
            return False
        return True
    except Exception:
        return True  # Skip on error


def format_file(filepath: Path, check_only: bool = False) -> bool:
    """
    Format a single Swift file: run SwiftFormat then add blank line indentation.
    Returns True if file needed formatting.
    """
    needed_formatting = False

    # Step 1: Run SwiftFormat (if available)
    if not run_swiftformat(filepath, check_only):
        needed_formatting = True

    # Step 2: Add blank line indentation
    if add_blank_line_indentation(filepath, check_only):
        needed_formatting = True
        if not check_only:
            print(f"Formatted: {filepath}")

    return needed_formatting


def find_swift_files(path: Path) -> list[Path]:
    """Find all Swift files in the given path."""
    if path.is_file():
        if path.suffix == '.swift' and not should_exclude(path):
            return [path]
        return []

    swift_files = []
    for filepath in path.rglob('*.swift'):
        if not should_exclude(filepath):
            swift_files.append(filepath)

    return sorted(swift_files)


def main():
    # Parse arguments
    args = sys.argv[1:]
    check_only = False
    format_all = False
    staged_only = False
    target_path = None

    if '--help' in args or '-h' in args:
        print(__doc__)
        sys.exit(0)

    if '--check' in args:
        check_only = True
        args.remove('--check')

    if '--all' in args:
        format_all = True
        args.remove('--all')

    if '--staged' in args:
        staged_only = True
        args.remove('--staged')

    if args:
        target_path = Path(args[0])

    # Check SwiftFormat availability once at startup
    if not is_swiftformat_available():
        print("Note: SwiftFormat not installed, skipping SwiftFormat rules.")

    # Determine which files to format
    if format_all:
        # Format all files in path
        path = target_path or Path('.')
        if not path.exists():
            print(f"Error: Path does not exist: {path}", file=sys.stderr)
            sys.exit(1)
        swift_files = find_swift_files(path)
    elif target_path and target_path.is_file():
        # Single file specified
        swift_files = [target_path] if target_path.suffix == '.swift' else []
    else:
        # Default: modified files only
        swift_files = get_modified_files(staged_only)

    if not swift_files:
        if format_all:
            print("No Swift files found.")
        else:
            print("No modified Swift files found.")
        sys.exit(0)

    # Format files
    modified_count = 0
    for filepath in swift_files:
        if format_file(filepath, check_only):
            modified_count += 1

    # Summary
    total = len(swift_files)
    if check_only:
        if modified_count > 0:
            print(f"\n{modified_count}/{total} files need formatting.")
            sys.exit(1)
        else:
            print(f"All {total} files are properly formatted.")
            sys.exit(0)
    else:
        if modified_count > 0:
            print(f"\nFormatted {modified_count}/{total} files.")
        else:
            print(f"All {total} files already formatted.")
        sys.exit(0)


if __name__ == '__main__':
    main()
