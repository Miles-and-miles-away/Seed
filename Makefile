.PHONY: gen watch l10n test lint format ci clean setup release-android release-ios symbols-android symbols-ios

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

# Release builds. Dart symbols are uploaded right after the build so no
# obfuscated build ever ships without them. The Crashlytics uploader
# needs a JDK; the seed conda env holds the only one on the machine.
DEBUG_INFO = build/debug-info
JAVA_HOME ?= $(HOME)/miniconda3/envs/seed/lib/jvm
FIREBASE = JAVA_HOME="$(JAVA_HOME)" PATH="$(JAVA_HOME)/bin:$$PATH" npm run firebase --
ANDROID_APP_ID = 1:49522523534:android:5191fb3210e7f88fadf8df
IOS_APP_ID = 1:49522523534:ios:680280a3eb42d871adf8df

release-android:
	flutter build appbundle --release --obfuscate --split-debug-info=$(DEBUG_INFO)
	$(MAKE) symbols-android

release-ios:
	flutter build ipa --release --obfuscate --split-debug-info=$(DEBUG_INFO)
	$(MAKE) symbols-ios

symbols-android:
	$(FIREBASE) crashlytics:symbols:upload --app=$(ANDROID_APP_ID) $(DEBUG_INFO)

symbols-ios:
	$(FIREBASE) crashlytics:symbols:upload --app=$(IOS_APP_ID) $(DEBUG_INFO)
