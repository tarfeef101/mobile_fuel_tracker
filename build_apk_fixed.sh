#!/bin/bash
# Fixed Build script for Fuel Tracker APK
# This script should work in an environment with Flutter and Android SDK properly configured

set -e  # Exit on any error

echo "Building Fuel Tracker APK with fixed configuration..."

# Set up the environment properly
export JAVA_HOME="$HOME/.local/share/mise/installs/java/17"
export PATH="$HOME/.local/share/mise/installs/java/17/bin:$PATH"
export FLUTTER_HOME="$HOME/.local/share/mise/installs/flutter/3.47.6"
export PATH="$HOME/.local/share/mise/installs/flutter/3.47.6/bin:$PATH"

echo "Setting up environment..."
echo "JAVA_HOME: $JAVA_HOME"
echo "PATH: $PATH"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found in PATH"
    exit 1
fi

# Check Flutter version
echo "Flutter version:"
flutter --version

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found. Are you in the correct directory?"
    exit 1
fi

# Check if main activity file exists
if [ ! -f "android/app/src/main/java/com/example/fuel_tracker/MainActivity.java" ]; then
    echo "Creating MainActivity.java..."
    mkdir -p android/app/src/main/java/com/example/fuel_tracker
    cat > android/app/src/main/java/com/example/fuel_tracker/MainActivity.java << 'EOF'
package com.example.fuel_tracker;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
}
EOF
fi

# Check if settings.gradle exists
if [ ! -f "android/settings.gradle" ]; then
    echo "Creating settings.gradle..."
    cat > android/settings.gradle << 'EOF'
rootProject.name = 'fuel_tracker'
include ':app'
EOF
fi

# Build APK
echo "Building release APK..."
flutter build apk --release --build-number=1

echo "APK build completed!"
echo "APK location: build/app/outputs/flutter_apk/app-release.apk"

# Show APK size
if [ -f "build/app/outputs/flutter_apk/app-release.apk" ]; then
    echo "APK size: $(du -h build/app/outputs/flutter_apk/app-release.apk)"
fi

echo "Build script completed successfully!"