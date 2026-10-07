# Fuel Tracker App

A fuel tracking application for Android with local encryption and optional AWS backup.

## Features

- Local database encryption with SQLCipher
- AWS DynamoDB cloud synchronization
- Tire size offset calculations
- Modern Flutter UI with Material 3
- Android v2 embedding support

## Build Instructions

### Prerequisites
- mise (for environment management)
- Android SDK

### Building APK

To build the APK in a headless environment:

1. Install dependencies with mise:
   ```bash
   mise install
   ```

2. Set up the environment:
   ```bash
   export PATH="$HOME/.local/share/mise/installs/flutter/3.47.6/bin:$PATH"
   export JAVA_HOME="$HOME/.local/share/mise/installs/java/17"
   export PATH="$HOME/.local/share/mise/installs/java/17/bin:$PATH"
   ```

3. Build the APK:
   ```bash
   flutter build apk --release --build-number=1
   ```

The APK will be generated at `build/app/outputs/flutter_apk/app-release.apk`.

## Project Structure

- `lib/` - Flutter application code
- `android/` - Android-specific code and configuration
- `lib/data/` - Database and data services
- `lib/screens/` - UI screens
- `lib/widgets/` - Reusable UI components

## Technology Stack

- Flutter 3.47.6
- Dart 3.13.5
- SQLCipher for local encryption
- AWS DynamoDB for cloud backup