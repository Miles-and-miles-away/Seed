# Emulator & Simulator Testing Guide

Quick reference for running the Seed app on Android emulators and iOS simulators.

## Key Concept

**Booting an emulator/simulator does NOT install the app.** You must run `flutter run` to build and deploy the latest code.

--------------------------------------------------------------------------

## Quick Start

### Android

```bash
# 1. Launch the emulator
flutter emulators --launch Medium_Phone_API_36.1

# 2. Build and run the app
flutter run
```

### iOS

```bash
# 1. Boot the simulator
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator

# 2. Build and run the app
flutter run
```

--------------------------------------------------------------------------

## Complete Testing Workflow

### Step 1: Prepare the Code

Before testing, ensure your code is ready:

```bash
# Install dependencies (if pubspec.yaml changed)
flutter pub get

# Run code generation (if @riverpod or @freezed classes changed)
dart run build_runner build

# Generate localizations (if ARB files changed)
flutter gen-l10n

# Check for analysis issues
flutter analyze
```

### Step 2: Launch Emulator/Simulator

**Android:**
```bash
# List available emulators
flutter emulators

# Launch your emulator
flutter emulators --launch Medium_Phone_API_36.1
```

**iOS:**
```bash
# List available simulators
xcrun simctl list devices available

# Boot your simulator
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator
```

### Step 3: Run the App

```bash
# Auto-detects running emulator/simulator
flutter run

# Or specify a device
flutter run -d emulator-5554   # Android
flutter run -d "iPhone 17 Pro" # iOS
```

### Step 4: Development Cycle

While the app is running:

| Key | Action |
|-----|--------|
| `r` | Hot reload (applies most code changes instantly) |
| `R` | Hot restart (restarts app, preserves emulator state) |
| `q` | Quit the app |

**Hot reload** works for:
- UI changes
- Business logic changes
- Most code changes

**Hot restart** needed for:
- Changes to `main()`
- Changes to global state initialization
- Adding new dependencies

**Full restart** (`flutter run` again) needed for:
- Native code changes
- New plugins
- Build configuration changes

--------------------------------------------------------------------------

## Running on Both Platforms Simultaneously

You can test on both Android and iOS at the same time:

```bash
# Terminal 1: Launch Android
flutter emulators --launch Medium_Phone_API_36.1
flutter run -d "Medium_Phone_API_36.1"

# Terminal 2: Launch iOS
xcrun simctl boot "iPhone 17 Pro"
flutter run -d "iPhone 17 Pro"
```

Or run on all connected devices:
```bash
flutter run -d all
```

--------------------------------------------------------------------------

## Testing Scenarios

### Debug Mode (Default)
```bash
flutter run
```
- Full debugging capabilities
- Hot reload enabled
- Slower performance

### Release Mode
```bash
flutter run --release
```
- Production-like performance
- No debugging tools
- Use for performance testing

### Profile Mode
```bash
flutter run --profile
```
- Performance profiling enabled
- Near-release performance
- DevTools accessible

--------------------------------------------------------------------------

## Device Management

### Check Connected Devices
```bash
flutter devices
```

### Android Emulator Commands
```bash
# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_name>

# Cold boot (if emulator is stuck)
# Use Android Studio > Device Manager > Cold Boot
```

### iOS Simulator Commands
```bash
# List simulators
xcrun simctl list devices available

# Boot simulator
xcrun simctl boot "iPhone 17 Pro"

# Shutdown simulator
xcrun simctl shutdown "iPhone 17 Pro"

# Shutdown all
xcrun simctl shutdown all

# Erase simulator (factory reset)
xcrun simctl erase "iPhone 17 Pro"
```

--------------------------------------------------------------------------

## Common Issues

### App Not Updating After Code Changes

1. Try hot reload: press `r`
2. Try hot restart: press `R`
3. Stop and run again: `q` then `flutter run`
4. If still not working:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Emulator/Simulator Not Detected

**Android:**
```bash
# Check if emulator is running
flutter devices

# If not listed, relaunch
flutter emulators --launch Medium_Phone_API_36.1
```

**iOS:**
```bash
# Check if simulator is booted
xcrun simctl list devices booted

# If not listed, boot it
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator
```

### Build Failures

**Android:**
```bash
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
flutter run
```

**iOS:**
```bash
cd ios && pod deintegrate && pod install && cd ..
flutter clean
flutter pub get
flutter run
```

--------------------------------------------------------------------------

## Quick Reference Card

| Task | Android | iOS |
|------|---------|-----|
| List devices | `flutter emulators` | `xcrun simctl list devices available` |
| Launch | `flutter emulators --launch Medium_Phone_API_36.1` | `xcrun simctl boot "iPhone 17 Pro"` |
| Run app | `flutter run` | `flutter run` |
| Shutdown | Close emulator window | `xcrun simctl shutdown all` |
| Clean build | `cd android && ./gradlew clean` | `cd ios && pod deintegrate && pod install` |

--------------------------------------------------------------------------

## Default Development Devices

| Platform | Device | Notes |
|----------|--------|-------|
| Android | Medium Phone API 36.1 | Android 15 emulator |
| iOS | iPhone 17 Pro | iOS 26.2 simulator |
