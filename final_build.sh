#!/bin/bash
# Final Build Script for Fuel Tracker APK

echo "=== FUEL TRACKER APK BUILD SCRIPT ==="

# Set up the environment properly
export JAVA_HOME="$HOME/.local/share/mise/installs/java/17"
export PATH="$HOME/.local/share/mise/installs/java/17/bin:$PATH"
export FLUTTER_HOME="$HOME/.local/share/mise/installs/flutter/3.47.6"
export PATH="$HOME/.local/share/mise/installs/flutter/3.47.6/bin:$PATH"

echo "Setting up environment..."
echo "JAVA_HOME: $JAVA_HOME"
echo "PATH: $PATH"

echo ""
echo "Checking Java installation..."
java -version

echo ""
echo "Checking Flutter installation..."
flutter --version

echo ""
echo "Installing Dart packages..."
flutter pub get

echo ""
echo "Attempting to build APK..."
flutter build apk --release --build-number=1

echo ""
echo "=== BUILD PROCESS COMPLETE ==="