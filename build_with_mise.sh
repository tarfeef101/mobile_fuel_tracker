#!/bin/bash
# Simple build script using mise for proper environment setup

set -e  # Exit on any error

echo "Building Fuel Tracker APK with mise environment..."

# Ensure we're in the right directory
cd $HOME/fuel_app_scratch

# Check if mise is available
if ! command -v mise &> /dev/null; then
    echo "Error: mise not found. Please install mise first."
    exit 1
fi

# Verify mise environment
echo "Setting up mise environment..."
mise install

# Get dependencies using mise exec to ensure proper environment
echo "Getting Flutter dependencies..."
mise exec -- flutter pub get

# Verify Android files exist
echo "Checking Android files..."
if [ ! -f "android/app/src/main/java/com/example/fuel_tracker/MainActivity.java" ]; then
    echo "Error: MainActivity.java not found"
    exit 1
fi

if [ ! -f "android/settings.gradle" ]; then
    echo "Error: settings.gradle not found"
    exit 1
fi

# Build APK using mise exec
echo "Building release APK..."
mise exec -- flutter build apk --release --build-number=1

echo "APK build completed!"
echo "APK location: build/app/outputs/flutter_apk/app-release.apk"

# Show APK size
if [ -f "build/app/outputs/flutter_apk/app-release.apk" ]; then
    echo "APK size: $(du -h build/app/outputs/flutter_apk/app-release.apk)"
fi

echo "Build script completed successfully!"