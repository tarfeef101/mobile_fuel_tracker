#!/bin/bash
# Build script for Fuel Tracker APK
# This script should work in an environment with Flutter and Android SDK properly configured

set -e  # Exit on any error

echo "Building Fuel Tracker APK..."

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found in PATH, checking /opt/flutter..."
    if [ -x "/opt/flutter/flutter/bin/flutter" ]; then
        export PATH="/opt/flutter/flutter/bin:$PATH"
        echo "Added Flutter to PATH"
    else
        echo "Error: Flutter not found at /opt/flutter/flutter/bin/flutter"
        exit 1
    fi
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