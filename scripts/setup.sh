#!/usr/bin/env bash
# One-time project setup
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "Installing pre-commit hook..."
cp "$REPO_ROOT/scripts/pre-commit" \
  "$REPO_ROOT/.git/hooks/pre-commit"
chmod +x "$REPO_ROOT/.git/hooks/pre-commit"

echo "Running flutter pub get..."
flutter pub get

echo "Running code generation..."
dart run build_runner build --delete-conflicting-outputs

echo "Generating localizations..."
flutter gen-l10n

echo "Setup complete."
