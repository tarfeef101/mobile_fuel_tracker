# Fuel Tracker - Fuel Tracking App

A comprehensive fuel tracking application for Android with local encryption and optional AWS backup.

## Features

- Local database encryption with SQLCipher
- AWS DynamoDB cloud synchronization
- Tire size offset calculations for accurate mileage
- Modern Flutter UI with Material 3 design
- Android v2 embedding support
- Secure credential storage
- Complete fuel entry management

## Development Setup

This project uses [mise](https://mise.jdx.dev/) for managing development dependencies. All required dependencies including Flutter, Java, and Android SDK are configured in the `mise.toml` file.

1. Install mise (https://mise.jdx.dev/)
2. Run `mise install` to install all dependencies
3. Run `flutter pub get` to install Dart packages
4. Run `flutter run` to start the app

## Build Instructions

To build the APK:
1. Ensure mise dependencies are installed
2. Run `flutter build apk --release --build-number=1`

## Project Structure

```
.
├── lib/                    # Main application code
├── android/                # Android configuration
├── test/                   # Test files
├── pubspec.yaml            # Dependencies and configuration
├── mise.toml               # Dependency management
├── README.md               # This file
└── CLAUDE.md               # Project-specific instructions
```

## Dependencies

This project uses mise for managing all development dependencies:
- Flutter SDK >=3.3.0 <4.0.0
- Java 17 (for Android builds)
- Android SDK 34

All dependencies are automatically managed by mise. See `mise.toml` for details.

## Security

- All AWS credentials stored securely using flutter_secure_storage
- Local database encryption with SQLCipher
- HTTPS communication with proper authentication

## License

This project is licensed under the MIT License.