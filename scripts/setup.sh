#!/usr/bin/env bash
# One-time project setup
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "Enabling the tracked git hooks..."
git -C "$REPO_ROOT" config core.hooksPath .githooks

echo "Running flutter pub get..."
flutter pub get

echo "Running code generation..."
dart run build_runner build

echo "Generating localizations..."
flutter gen-l10n

echo "Setup complete."
