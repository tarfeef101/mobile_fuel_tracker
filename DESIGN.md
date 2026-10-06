# Fuel Tracker Application Design Document

## Overview
This document provides a comprehensive design specification for the Fuel Tracker application, outlining its architecture, data model, UI components, and system behavior. The application is built with Flutter and Dart, designed for Android devices with support for foldable and flip phones.

## Application Features

### Core Functionality
1. **Fuel Entry Management**: Add, edit, and delete fuel fill entries with detailed information
2. **Local Data Storage**: Secure encrypted database using SQLCipher
3. **Cloud Synchronization**: Optional AWS DynamoDB backup and sync
4. **Data Analysis**: Consumption metrics and cost tracking
5. **Battery Tracking**: For electric vehicles, record battery levels and energy consumption during charging

### Key Features
- Local encryption with SQLCipher
- AWS DynamoDB cloud synchronization
- Tire size offset calculations for accurate mileage
- Modern Flutter UI with Material 3 design
- Android v2 embedding support
- Secure credential storage
- Complete fuel entry management

## Data Model and Schema

### Database Schema

The application uses a SQLite database with SQLCipher encryption for local storage. The main data models are:

#### Vehicle Table
```dart
class Vehicle {
  final String id;                    // Unique identifier
  final String name;                 // User-defined name for the vehicle (mandatory)
  final String fuelType;             // Type of fuel (liquid, electric, etc.)
  final String? make;                // Vehicle make (optional)
  final String? model;               // Vehicle model (optional)
  final int? year;                   // Vehicle year (optional)
  final String? vin;                 // Vehicle Identification Number (optional)
  final String? licensePlate;        // License plate number (optional)
  final DateTime createdAt;          // When the vehicle was added
  final DateTime? updatedAt;         // When the vehicle was last updated
}
```

#### FillEntry Table
```dart
class FillEntry {
  final String id;                    // Unique identifier
  final String vehicleId;            // Foreign key to Vehicle table
  final DateTime timestamp;          // When the entry was created
  final String fuelType;             // Type of fuel (liquid, electric, etc.)
  final double? odometer;            // Odometer reading at time of fill
  final double? fuelAmount;          // Amount of fuel added
  final double? batteryLevelBefore;  // Battery level before filling
  final double? batteryLevelAfter;   // Battery level after filling
  final double? energyAdded;         // Energy added (for electric vehicles)
  final double totalCost;            // Total cost of the fill
  final String currency;             // Currency used for cost
  final String? distanceUnit;        // Unit for distance measurements
  final String? capacityUnit;        // Unit for fuel capacity
  final String? notes;               // Additional notes
  final DateTime? syncedAt;          // Timestamp when last synced
  final String deviceId;             // Device identifier for tracking
}
```
```

### Database Tables
The application uses a single main table `FillEntries` with the following columns:
- `id` (primary key)
- `timestamp`
- `fuelType`
- `odometer`
- `fuelAmount`
- `batteryLevelBefore`
- `batteryLevelAfter`
- `energyAdded`
- `totalCost`
- `currency`
- `distanceUnit`
- `capacityUnit`
- `notes`
- `syncedAt`
- `deviceId`

## UI Components and Screens

### Main Screens

1. **Fuel Entry Screen (Primary Screen)**
   - Main screen for adding new fuel entries
   - Focus on data entry for current fill-up
   - Form for entering fuel details including:
     - Fuel type (liquid, electric, etc.)
     - Cost and amount
     - Odometer reading (for liquid fuel)
     - Battery levels (for electric vehicles)
     - Notes section
   - Quick access to vehicle selection (for future multi-vehicle support)
   - Summary statistics display for current entry

2. **Dashboard Screen (Secondary Screen)**
   - Primary focus on fuel economy calculations and cost analysis
   - Shows summary statistics and key metrics at the top (fuel economy, average cost per unit distance, etc.)
   - Fuel history list positioned at the bottom/below the fold
   - History period setting (persisted across app sessions)
   - Sync status indicator

3. **Settings Screen**
   - Cloud sync configuration
   - Currency settings
   - Device preferences
   - Vehicle management (add/edit/delete vehicles)
   - Data export options
   - Fuel economy calculation preferences

### UI Components

1. **Entry Card**
   - Displays individual fuel entry details
   - Shows summary information
   - Provides delete functionality

2. **Data Visualization**
   - Consumption trend charts
   - Cost analysis graphs
   - Battery usage tracking

## Data Lifecycle

### Data Creation
1. User creates a new fuel entry through the Add Entry screen
2. All required fields are validated
3. Entry is stored in local SQLite database with SQLCipher encryption
4. Entry is marked as unsynced if cloud sync is enabled

### Data Persistence
1. All data is stored locally in an encrypted SQLite database
2. Database uses SQLCipher for encryption
3. Data is automatically backed up to local storage
4. Timestamps are maintained for all entries

### Data Movement
1. When cloud sync is enabled, unsynced entries are sent to AWS DynamoDB
2. Sync status is tracked in the database
3. Successful sync updates the `syncedAt` timestamp
4. Failed sync attempts are retried automatically
5. Sync can be triggered manually through the sync button in the Dashboard
6. Sync can be configured to run automatically at regular intervals (e.g., daily or hourly)
7. Background sync operations occur when the app is in the background and network is available

### Data Retrieval
1. Dashboard loads all entries from local database
2. Data is sorted by timestamp (newest first)
3. Filter and search functionality available
4. Entry details displayed in cards

## Dependencies

### Core Dependencies

1. **Flutter SDK**: >=3.3.0 <4.0.0
2. **Drift**: Database ORM with SQLCipher support
3. **Drift SQLCipher**: SQLite encryption support
4. **SQLite3 Flutter Libs**: Native SQLite support for Flutter
5. **Path Provider**: File system access
6. **Shared Preferences**: Local storage for settings
7. **Flutter Secure Storage**: Secure credential storage
8. **UUID**: Unique identifier generation
9. **Intl**: Internationalization support
10. **HTTP**: Network communications
11. **AWS Signature V4**: AWS request signing
12. **Flutter Slidable**: Swipe to delete functionality
13. **Flutter ScreenUtil**: Responsive design support
14. **Dynamic Color**: Material Design color theming

### Development Dependencies
- Flutter Test: Testing framework
- Flutter Lints: Code quality rules

## Platform Support

### Android Support
- Minimum API Level: Android 21 (Android 5.0)
- Target SDK: Android 34
- Support for foldable and flip phones
- Android v2 embedding support

### Form Factors
- Standard phones (1080x2400 resolution and above)
- Foldable phones (dual-screen support)
- Flip phones (compact form factor)
- Tablets (larger screen sizes)

## Development Toolchain

### Framework and Language
- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **mise**: Dependency management tool

### Development Environment
- Flutter SDK 3.47.6
- Java 17
- Android SDK 34
- Android Studio (recommended IDE)
- VS Code with Flutter extensions

### Build Process
1. `mise install` - Install all development dependencies
2. `flutter pub get` - Install Dart packages
3. `flutter run` - Run the app
4. `flutter build apk --release --build-number=1` - Build the APK

## Application Settings

### User Configuration Options

1. **Cloud Synchronization**
   - Enable/disable cloud sync
   - AWS credentials management
   - Sync frequency settings

2. **Currency Settings**
   - Default currency selection
   - Currency conversion options

3. **Device Preferences**
   - Theme selection (light/dark)
   - Notification preferences
   - Data retention policies

4. **Data Management**
   - Export data options
   - Backup settings
   - Database maintenance

5. **Advanced Settings**
   - Battery level tracking
   - Energy consumption calculation
   - Tire size configuration

## Security Considerations

1. **Data Encryption**: All local data is encrypted using SQLCipher
2. **Credential Storage**: AWS credentials stored securely using flutter_secure_storage
3. **HTTPS Communication**: All cloud communications use HTTPS
4. **Access Control**: Local database access restricted to application only

## Performance and Optimization

1. **Database Performance**: 
   - Efficient queries with proper indexing
   - Pagination for large datasets
   - Background sync operations

2. **Memory Management**:
   - Efficient UI rendering
   - Lazy loading of data
   - Memory usage monitoring

3. **Network Efficiency**:
   - Batch sync operations
   - Retry mechanisms for failed requests
   - Connection pooling for cloud operations

## Future Considerations

1. **Cross-platform Support**: iOS and web support
2. **Advanced Analytics**: More detailed consumption reports
3. **Integration**: Third-party API integrations
4. **Offline Capabilities**: Enhanced offline functionality
5. **Data Visualization**: More sophisticated charting and reporting