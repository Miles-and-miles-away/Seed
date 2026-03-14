# iOS Development Setup Guide

This guide walks you through setting up and running the Seed app on iOS.

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

### 2. Install Xcode

Download from the Mac App Store or [developer.apple.com/xcode](https://developer.apple.com/xcode/)

After installation, run:
```bash
# Install Xcode command-line tools
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept
```

### 3. Install CocoaPods

CocoaPods is required for iOS dependency management:

```bash
# Using Homebrew (recommended)
brew install cocoapods

# Or using gem
sudo gem install cocoapods
```

Verify:
```bash
pod --version
```

### 4. Configure Xcode Simulators

Open Xcode at least once to download iOS simulators:

1. Open Xcode
2. Go to **Xcode > Settings > Platforms**
3. Download desired iOS versions (iOS 17+ recommended)

--------------------------------------------------------------------------

## Project Setup

### 1. Navigate to Project

```bash
cd /Users/milesd/GitRepos/Seed
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Install iOS Pods

```bash
cd ios && pod install && cd ..
```

### 4. Run Code Generation

Required for Riverpod and Freezed classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Generate Localization Files

```bash
flutter gen-l10n
```

--------------------------------------------------------------------------

## Running the App

**Development Device:** iPhone 17 Pro (iOS Simulator)

### Option A: Using CLI

```bash
# List available simulators
xcrun simctl list devices available

# Boot a simulator
xcrun simctl boot "iPhone 17 Pro"

# Open the Simulator app
open -a Simulator

# Run the app (auto-detects booted simulator)
flutter run

# Run on specific device
flutter run -d "iPhone 17 Pro"
```

### Option B: Using VS Code

1. Open the project in VS Code
2. Install the Flutter extension
3. Boot a simulator: `xcrun simctl boot "iPhone 17 Pro"`
4. Select the simulator from the status bar (bottom right)
5. Press `F5` or **Run > Start Debugging**

### Option C: Using a Physical Device

For testing on real hardware:

1. **Connect your iPhone via USB**

2. **Trust the computer on your device**

3. **Open Xcode and configure signing**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the Runner project in the navigator
   - Go to **Signing & Capabilities**
   - Select your Team (requires Apple Developer account)
   - Ensure a valid Bundle Identifier is set

4. **Verify device is connected**
   ```bash
   flutter devices
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

--------------------------------------------------------------------------

## Simulator Management

### Common Simulator Commands

```bash
# List all available simulators
xcrun simctl list devices available

# Boot a specific simulator
xcrun simctl boot "iPhone 17 Pro"

# Open the Simulator app (shows booted devices)
open -a Simulator

# List currently booted simulators
xcrun simctl list devices booted

# Shutdown a specific simulator
xcrun simctl shutdown "iPhone 17 Pro"

# Shutdown all simulators
xcrun simctl shutdown all

# Erase a simulator (reset to factory)
xcrun simctl erase "iPhone 17 Pro"

# Delete an app from simulator
xcrun simctl uninstall booted com.seedapp.seed_app
```

### Available Simulators (iOS 26.2)

| Device | Description |
|--------|-------------|
| iPhone 17 Pro | Primary development device |
| iPhone 17 Pro Max | Larger screen testing |
| iPhone 17 | Standard size testing |
| iPhone Air | Thin form factor |
| iPhone 16e | Budget model testing |
| iPad Pro 13-inch (M5) | Tablet testing |
| iPad Air 11-inch (M3) | Tablet testing |

--------------------------------------------------------------------------

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
| `cd ios && pod install && cd ..` | After adding iOS-specific dependencies |
| `dart run build_runner build` | After modifying `@riverpod` or `@freezed` classes |
| `flutter gen-l10n` | After modifying ARB localization files |
| `flutter clean` | Only when you have weird build issues (rare) |
| `flutter build ios` | Only for release builds |

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

# Run on specific device
flutter run -d "iPhone 17 Pro"

# Hot reload (while running)
# Press 'r' in terminal

# Hot restart (while running)
# Press 'R' in terminal

# Build iOS app (requires signing)
flutter build ios

# Clean build (only when having issues)
flutter clean && flutter pub get && cd ios && pod install && cd ..
```

--------------------------------------------------------------------------

## Troubleshooting

### Flutter Doctor

Run this to check your setup:
```bash
flutter doctor -v
```

Fix any issues shown with ✗ or !

### Common Issues

#### "CocoaPods not installed"
```bash
brew install cocoapods
cd ios && pod install && cd ..
```

#### Pod Install Failures
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install
cd ..
```

#### Code Signing Issues
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project > Signing & Capabilities
3. Select a valid Team
4. Let Xcode manage signing automatically

#### Simulator Not Showing
```bash
# Reset simulators
xcrun simctl shutdown all
xcrun simctl erase all

# Or create a new simulator
xcrun simctl create "My iPhone" "iPhone 17 Pro"
```

#### Build Cache Issues
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData
pod install
cd ..
flutter pub get
flutter run
```

#### Firebase Issues
Ensure `ios/Runner/GoogleService-Info.plist` exists (it should already be configured).

### Performance Tips

- Use release mode for testing actual performance: `flutter run --release`
- Use a physical device for accurate performance testing
- Impeller is enabled by default on iOS for better graphics

--------------------------------------------------------------------------

## Project Configuration Reference

| Setting | Value |
|---------|-------|
| iOS Deployment Target | 14.0 |
| Bundle Identifier | com.seedapp.seed_app |
| Swift Version | 5.0 |

--------------------------------------------------------------------------

## Next Steps

After running the app:
1. Sign in with email, Google, or Apple
2. Explore the SDG feature on the home screen
3. Check out the mascot system
4. Log eco-friendly actions to earn points
