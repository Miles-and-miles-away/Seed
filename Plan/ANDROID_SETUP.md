# Android Development Setup Guide

This guide walks you through setting up and running the Seed app on Android.

## Prerequisites

### 1. Install Flutter

Download and install Flutter SDK (version 3.38.7 or later):

```bash
# macOS (Homebrew)
brew install flutter

# Or download from https://docs.flutter.dev/get-started/install
```

Verify installation:
```bash
flutter --version
# Expected: Flutter 3.38.7 or later
```

### 2. Install Android Studio

Download from [developer.android.com/studio](https://developer.android.com/studio)

During installation, ensure you install:
- Android SDK
- Android SDK Command-line Tools
- Android SDK Build-Tools
- Android SDK Platform-Tools

### 3. Install Java 17

The project requires Java 17:

```bash
# macOS (Homebrew)
brew install openjdk@17

# Add to PATH (add to ~/.zshrc or ~/.bashrc)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"
```

Verify:
```bash
java -version
# Expected: openjdk version "17.x.x"
```

### 4. Accept Android Licenses

```bash
flutter doctor --android-licenses
```

Press `y` to accept all licenses.

--------------------------------------------------------------------------

## Project Setup

### 1. Clone and Navigate to Project

```bash
cd /Users/milesd/GitRepos/Seed
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Code Generation

Required for Riverpod and Freezed classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Generate Localization Files

```bash
flutter gen-l10n
```
--------------------------------------------------------------------------

## Running the App

**Development Device:** Medium Phone API 36.1 (Android emulator)

### Option A: Using CLI

```bash
# List available devices
flutter devices
# OR
# List available emulators
flutter emulators

# Run the app (auto-selects if one device available)
flutter run

# Run on specific device
flutter run -d <device_id>

# Run on emulator
flutter emulators --launch Medium_Phone_API_36.1
```

### Option B: Using VS Code

1. Open the project in VS Code
2. Install the Flutter extension
3. Select **Medium Phone API 36.1** from the status bar (bottom right)
4. Press `F5` or **Run > Start Debugging**

### Option C: Using a Physical Device (Later)

For testing on real hardware once development progresses:

1. **Enable Developer Options on your Android device**
   - Go to **Settings > About Phone**
   - Tap **Build Number** 7 times
   - Go back to **Settings > Developer Options**
   - Enable **USB Debugging**

2. **Connect your device via USB**

3. **Verify device is connected**
   ```bash
   flutter devices
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## Common Commands

### Development Workflow

For seeing changes during development, you typically only need:

```bash
flutter run
```

Hot reload (`r`) and hot restart (`R`) handle most changes automatically.

### When to Run Specific Commands

| Command | When Needed |
|---------|-------------|
| `flutter pub get` | After modifying `pubspec.yaml` (adding/removing packages) |
| `dart run build_runner build` | After modifying `@riverpod` or `@freezed` classes |
| `flutter gen-l10n` | After modifying ARB localization files |
| `flutter clean` | Only when you have weird build issues (rare) |
| `flutter build apk` | Only for release builds to distribute |
| `flutter build appbundle` | Only for Play Store uploads |

### Typical Development Cycle

1. Make code changes
2. Hot reload happens automatically (or press `r`)
3. If hot reload doesn't work, press `R` for hot restart
4. If that doesn't work, stop and `flutter run` again

### All Commands Reference
```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Run in profile mode (for performance profiling)
flutter run --profile

# Run with specific device
flutter run -d <device_id>

# Hot reload (while running)
# Press 'r' in terminal

# Hot restart (while running)
# Press 'R' in terminal

# Build APK (for distribution, not needed for development)
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle

# Clean build (only when having issues)
flutter clean && flutter pub get
```

## Troubleshooting

### Flutter Doctor

Run this to check your setup:
```bash
flutter doctor -v
```

Fix any issues shown with ✗ or !

### Common Issues

#### "flutter.sdk not set in local.properties"
```bash
# Create/update android/local.properties with your Flutter SDK path
echo "flutter.sdk=$(which flutter | xargs dirname | xargs dirname)" > android/local.properties
```

#### Gradle Build Failures
```bash
# Clean and rebuild
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
flutter run
```

#### Java Version Mismatch
```bash
# Check current Java version
java -version

# Ensure JAVA_HOME points to Java 17
echo $JAVA_HOME
```

#### Firebase Issues
Ensure `android/app/google-services.json` exists (it should already be configured).

### Performance Tips

- Use release mode for testing actual performance: `flutter run --release`
- Use a physical device for accurate performance testing
- Enable Impeller renderer for better graphics: already enabled by default on Android

## Project Configuration Reference

| Setting | Value |
|---------|-------|
| Min SDK | Flutter default (21) |
| Target SDK | Flutter default (36) |
| Compile SDK | Flutter default |
| Java Version | 17 |
| Kotlin Version | 2.2.20 |
| Gradle Plugin | 8.11.1 |
| Package Name | com.seedapp.seed_app |

## Next Steps

After running the app:
1. Sign in with email, Google, or Apple
2. Explore the SDG feature on the home screen
3. Check out the mascot system
4. Log eco-friendly actions to earn points
