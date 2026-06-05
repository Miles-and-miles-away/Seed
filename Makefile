.PHONY: gen watch l10n test lint format ci clean setup

gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

l10n:
	flutter gen-l10n

test:
	flutter test

lint:
	flutter analyze --fatal-infos

format:
	dart format lib test

ci: gen l10n lint test

clean:
	flutter clean
	dart run build_runner clean

setup:
	bash scripts/setup.sh
