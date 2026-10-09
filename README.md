# Fuel Economy Tracker

An Android app (Flutter) for tracking fuel and EV charging across vehicles: cost per fill, consumption metrics, and tire-size-adjusted mileage. Data is stored in a local SQLCipher-encrypted database, with optional cloud sync to AWS DynamoDB.

See `DESIGN.md` for the architecture and data model.

## Repo layout

- `lib/` — application code
  - `lib/screens/` — UI screens (dashboard, entry/vehicle forms, settings)
  - `lib/widgets/` — reusable UI components
  - `lib/models/` — data models
  - `lib/data/` — local database (drift/SQLCipher) and the signed-request DynamoDB client
  - `lib/services/` — settings, cloud sync, and background sync scheduling
- `android/` — Android platform configuration
- `test/` — unit tests
- `terraform/` — drop-in Terraform resources (DynamoDB table + scoped IAM user/key) for provisioning the cloud sync backend

## Building

The toolchain (Flutter, JDK, Android SDK) is managed by [mise](https://mise.jdx.dev/) — see `mise.toml`.

```bash
mise install
mise run build-apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.

Other tasks:

```bash
mise run test                        # unit tests
mise x flutter -- flutter analyze    # static analysis
```

## Installing

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Cloud sync (optional)

The app signs its own DynamoDB requests (SigV4) — no AWS SDK. If you want the sync backend, `terraform/fuel_tracker.tf` is a drop-in resource file for your existing Terraform setup: it creates the on-demand table (encrypted with the AWS default key) and an IAM user + access key scoped to exactly the API calls the app makes. Enter the user's key in the app under Settings → AWS Configuration.
