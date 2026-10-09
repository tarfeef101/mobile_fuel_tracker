#!/bin/bash

# Simple script to run the fuel tracker app

echo "Starting Fuel Tracker App..."

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed. Please install Flutter SDK first."
    exit 1
fi

# Check if we're in the project directory
if [ ! -f "pubspec.yaml" ]; then
    echo "This doesn't appear to be a Flutter project directory."
    exit 1
fi

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Run the app
echo "Running the app..."
flutter run

echo "App closed."
