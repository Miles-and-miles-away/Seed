.PHONY: gen watch l10n test lint format ci clean setup release-android release-apk release-ios symbols-android

gen:
	dart run build_runner build

watch:
	dart run build_runner watch

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

# Release builds. Android Dart symbols are uploaded right after the build so
# no obfuscated build ships without them; iOS uploads them as dSYMs from the
# FlutterFire Xcode build phase. The Crashlytics uploader needs a JDK; the
# seed conda env holds the only one on the machine.
ANDROID_DEBUG_INFO = build/debug-info/android
JAVA_HOME ?= /opt/homebrew/Caskroom/miniforge/base/envs/seed/lib/jvm
FIREBASE = JAVA_HOME="$(JAVA_HOME)" PATH="$(JAVA_HOME)/bin:$$PATH" npm run firebase --
ANDROID_APP_ID = 1:49522523534:android:5191fb3210e7f88fadf8df

release-android:
	flutter build appbundle --release --obfuscate --split-debug-info=$(ANDROID_DEBUG_INFO)
	$(MAKE) symbols-android

VERSION = $(shell sed -n 's/^version: //p' pubspec.yaml | tr + -)

release-apk:
	flutter build apk --release --split-per-abi --obfuscate --split-debug-info=$(ANDROID_DEBUG_INFO)
	cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk build/seed-$(VERSION)-arm64.apk
	$(MAKE) symbols-android

release-ios:
	flutter build ipa --release --obfuscate --split-debug-info=build/debug-info/ios

symbols-android:
	$(FIREBASE) crashlytics:symbols:upload --app=$(ANDROID_APP_ID) $(ANDROID_DEBUG_INFO)
