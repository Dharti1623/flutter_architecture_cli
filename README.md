# Flutter Architecture CLI

[![pub package](https://img.shields.io/pub/v/flutter_architecture_cli.svg)](https://pub.dev/packages/flutter_architecture_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20macos%20%7C%20web%20%7C%20linux%20%7C%20windows-blue.svg)](#)

A production-grade command-line tool designed to generate and scale clean architecture codebases in Flutter. It eliminates repetitive setup, enforcing a modular, highly scalable, and team-friendly project structure powered by RxDart streams and Provider.

> [!TIP]
> Read the complete setup and detailed architectural guide on Medium: **[Stop Writing Boilerplate: Scaffold a Flutter Clean Architecture App in 60 Seconds!](https://medium.com/@dharti6196/stop-writing-boilerplate-scaffold-a-flutter-clean-architecture-app-in-60-seconds-4b1df80397b0)**

---

## Table of Contents
- [Installation & Setup](#installation--setup)
  - [Method 1: Project Dev Dependency (Recommended)](#method-1-project-dev-dependency-recommended)
  - [Method 2: Global Installation](#method-2-global-installation)
- [FVM (Flutter Version Management) Support](#fvm-flutter-version-management-support)
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Usage Guide](#usage-guide)
  - [1. Creating a New Application](#1-creating-a-new-application)
  - [2. Creating a Feature](#2-creating-a-feature)
  - [3. Creating a Screen](#3-creating-a-screen)
  - [4. Creating Models](#4-creating-models)
  - [5. Creating Data Sources](#5-creating-data-sources)
  - [6. Creating Repositories](#6-creating-repositories)
  - [7. Creating Core Services](#7-creating-core-services)
  - [8. Changing Bundle ID / Package Name](#8-changing-bundle-id--package-name)
- [Architecture Flow](#architecture-flow)
- [Roadmap / Future Goals](#roadmap--future-goals)
- [Contributing](#contributing)
- [Support & Donations](#support--donations)

---

## Installation & Setup

You can use `flutter_architecture_cli` in two convenient ways:

### Method 1: Project Dev Dependency (Recommended)

This method ensures everyone on your team has access to the CLI with matching versions, without requiring machine-wide global installs.

#### A. New Projects Created via the CLI
When you scaffold an application using `flutter_architecture_cli create <app_name>`, the tool **automatically adds `flutter_architecture_cli` to your `dev_dependencies`** inside `pubspec.yaml`!

You can immediately navigate into your project folder and run commands:

```bash
# Standard Flutter
dart run flutter_architecture_cli <command>

# Or with FVM
fvm dart run flutter_architecture_cli <command>
```

#### B. Adding to Existing Projects
To add the CLI to an existing Flutter codebase:

```bash
# Standard Flutter
flutter pub add --dev flutter_architecture_cli

# Or with FVM
fvm flutter pub add --dev flutter_architecture_cli
```

Once installed, run any command from your project root:
```bash
dart run flutter_architecture_cli <command>
# (or with FVM: fvm dart run flutter_architecture_cli <command>)
```

---

### Method 2: Global Installation

If you prefer having the CLI globally accessible from any terminal window without prefixing `dart run`:

#### Standard Flutter:
```bash
dart pub global activate flutter_architecture_cli
```

#### With FVM:
```bash
fvm dart pub global activate flutter_architecture_cli
```

> **Note**: Make sure your global pub cache bin directory is in your system's `PATH`:
> - macOS/Linux: `export PATH="$PATH":"$HOME/.pub-cache/bin"`
> - Windows: `%USERPROFILE%\AppData\Local\Pub\Cache\bin`

Once activated globally, execute commands directly:
```bash
flutter_architecture_cli <command>
```

---

## FVM (Flutter Version Management) Support

`flutter_architecture_cli` includes complete, first-class support for **FVM** out of the box.

### Why FVM Support Was Added (v1.0.4)
Previously, developers who set up FVM using shell aliases (e.g., `alias flutter="fvm flutter"`) encountered `command not found (exit code 127)` because non-interactive subshells do not source `.zshrc` / `.bashrc` aliases. In `v1.0.4+`, the CLI natively detects FVM binaries and routes all Flutter and Dart operations through `fvm flutter` and `fvm dart` seamlessly.

### How FVM Works in this CLI

1. **Smart Auto-Detection**:
   - **Missing Global Flutter**: If `flutter` is missing from your system `PATH` but `fvm` is installed, the CLI automatically detects FVM and switches to `fvm flutter` without requiring any manual flags.
   - **Workspace Detection**: If an `.fvm/` directory or `.fvmrc` file exists in your workspace, FVM is automatically preferred for all operations.
2. **Explicit Flags (`--fvm` and `--fvm-version`)**:
   - Pass `--fvm` to explicitly force FVM execution:
     ```bash
     flutter_architecture_cli create my_app --fvm
     ```
   - Optionally pin a specific Flutter version during creation:
     ```bash
     flutter_architecture_cli create my_app --fvm --fvm-version 3.22.0
     ```
3. **Automated IDE & Git Configuration**:
   - Automatically adds `.fvm/flutter_sdk` to the generated `.gitignore`.
   - Automatically creates `.vscode/settings.json` with `"dart.flutterSdkPath": ".fvm/flutter_sdk"` so VS Code immediately binds the correct Flutter SDK.
4. **All Subcommands Support FVM**:
   - When running feature, screen, or model generation inside an FVM project, code formatting automatically uses `fvm dart format`.

### Quick FVM Cheat Sheet

| Task | Standard Flutter | With FVM |
| :--- | :--- | :--- |
| **Global Install** | `dart pub global activate flutter_architecture_cli` | `fvm dart pub global activate flutter_architecture_cli` |
| **Add as Dev Dependency** | `flutter pub add --dev flutter_architecture_cli` | `fvm flutter pub add --dev flutter_architecture_cli` |
| **Create Project** | `flutter_architecture_cli create my_app` | `flutter_architecture_cli create my_app --fvm` |
| **Create with Pinned SDK** | N/A | `flutter_architecture_cli create my_app --fvm --fvm-version 3.22.0` |
| **Create Feature** | `dart run flutter_architecture_cli create_feature auth` | `fvm dart run flutter_architecture_cli create_feature auth` |
| **Create Screen** | `dart run flutter_architecture_cli create_screen home -f auth` | `fvm dart run flutter_architecture_cli create_screen home -f auth` |
| **Create Model** | `dart run flutter_architecture_cli create_model user -f auth` | `fvm dart run flutter_architecture_cli create_model user -f auth` |
| **Create Service** | `dart run flutter_architecture_cli create_service api` | `fvm dart run flutter_architecture_cli create_service api` |

---

## Features

* **Zero-Configuration Architecture Setup**: Instant scaffolding covering storage, networking, localizations, utility helpers, and dependency injection.
* **Stream-Based State Management**: Seamless state handling inside Blocs using RxDart's `BehaviorSubject` and `CompositeSubscription`.
* **Centralized Networking**: Custom `ApiClient` powered by `Dio` with automatic logging, secure token handling, and robust exception-handling interceptors.
* **Unified UI State**: Standardized `BaseUiState` class for mapping screen loading, success, and error states.
* **Common Widget Toolkit**: Reusable components such as `AppText`, `AppImage`, `AppTextField`, `AppButton`, `AppLoader`, `AppShimmer`, and `AppNetworkStatusWidget`.
* **JSON-Based Localization**: Fully configured translations with convenient context translation extensions (`context.tr(...)`).
* **FVM Compatible**: Effortless compatibility for teams managing Flutter versions with FVM.

---

## Folder Structure

Generating a project produces this clean, production-ready tree:

```text
lib/
├── common/
│   ├── extensions/       # BuildContext, String, DateTime and Widget extensions
│   ├── helpers/          # Bottom sheets, dialogs, snackbars, and navigation helpers
│   └── widgets/          # Highly reusable common widgets (AppButton, AppLoader, etc.)
├── core/
│   ├── base/             # BaseBloc, BaseMapper, and BaseUiState
│   ├── constants/        # Api endpoints, dimensions, route names, regex, etc.
│   ├── localization/     # Localization service and JSON delegates
│   ├── network/          # ApiClient configurations, interceptors, and custom exceptions
│   ├── storage/          # SharedPreferences manager and secure storage
│   ├── theme/            # AppThemeData, custom borders, shadows, and text styles
│   └── utils/            # Validators, connectivity helpers, pickers, and logger
├── src/
│   └── users/            # Pre-generated dummy feature showcasing architecture
│       ├── bloc/         # RxDart user_bloc.dart
│       ├── data_source/  # user_datasource.dart
│       ├── mapper/       # user_mapper.dart (BaseMapper implementation)
│       ├── model/
│       │   ├── request/  # Empty folder placeholder for request parameters
│       │   ├── response/ # user_response.dart (Raw network DTO)
│       │   └── ui_entity/# user_ui_entity.dart (UI data model)
│       ├── presentation/
│       │   ├── view/     # user_screen.dart
│       │   └── widget/   # Feature-specific sub-widgets
│       ├── repository/   # user_repository.dart
│       └── state/        # user_state.dart & user_provider.dart
└── main.dart             # Application root bootstrapper
```

---

## Usage Guide

> If using as a dev dependency, prefix commands with `dart run` (or `fvm dart run`). If globally activated, run `flutter_architecture_cli` directly.

### 1. Creating a New Application
Generate a fully bootstrapped Flutter project matching the architecture style:

```bash
# Standard
flutter_architecture_cli create <app_name>

# With custom organization domain
flutter_architecture_cli create <app_name> --org com.company

# With FVM
flutter_architecture_cli create <app_name> --fvm

# With FVM and pinned SDK version
flutter_architecture_cli create <app_name> --fvm --fvm-version 3.22.0
```
*Example:*
```bash
flutter_architecture_cli create my_awesome_app
```

### 2. Creating a Feature
Instantly scaffold a complete feature directory with all sub-layers (`bloc`, `data_source`, `mapper`, `model/request`, `model/response`, `model/ui_entity`, `presentation/view`, `presentation/widget`, `repository`, `state`):

```bash
flutter_architecture_cli create_feature <feature_name>
```
*Example:*
```bash
flutter_architecture_cli create_feature products
```

### 3. Creating a Screen
Add a new screen to the presentation layer of a specific feature:

```bash
flutter_architecture_cli create_screen <screen_name> -f <feature_name>
```
*Example:*
```bash
flutter_architecture_cli create_screen product_detail -f products
```

### 4. Creating Models
Generate model response DTOs and matching UI Entity classes:

```bash
flutter_architecture_cli create_model <model_name> -f <feature_name>
```
*Example:*
```bash
flutter_architecture_cli create_model category -f products
```

### 5. Creating Data Sources
Generate a data source class in the specified feature:

```bash
flutter_architecture_cli create_datasource <name> -f <feature_name>
```
*Example:*
```bash
flutter_architecture_cli create_datasource product -f products
```

### 6. Creating Repositories
Generate a repository class to bridge your data source and domain layer (automatically links to existing feature data sources):

```bash
flutter_architecture_cli create_repository <name> -f <feature_name>
```
*Example:*
```bash
flutter_architecture_cli create_repository product -f products
```

### 7. Creating Core Services
Generate a singleton service in `lib/core/services/`:

```bash
flutter_architecture_cli create_service <service_name>
```
*Example:*
```bash
flutter_architecture_cli create_service auth
```

### 8. Changing Bundle ID / Package Name
Change the Android package name and iOS bundle identifier across `build.gradle`, `build.gradle.kts`, `AndroidManifest.xml`, `MainActivity`, and `project.pbxproj`:

```bash
flutter_architecture_cli change_bundle_id <new_bundle_id>
```
*Example:*
```bash
flutter_architecture_cli change_bundle_id com.company.myapp
```

---

## Architecture Flow

The generated structure focuses on a single directional data flow:

1. **DataSource**: Fetches raw JSON data using `ApiClient` and parses it into a Response DTO (`model/response/`).
2. **Mapper**: Inherits from `BaseMapper` to transform the Response DTO into a clean UI Entity (`model/ui_entity/`).
3. **Repository**: Requests data from `DataSource` and runs the mapped results up to the Bloc layer.
4. **Bloc**: Standardizes UI state management by converting repository streams into `BaseUiState` (Loading -> Completed/Error) emitted via `BehaviorSubject`.
5. **Presentation (View)**: Listens to the Bloc subjects using `StreamBuilder` and renders loading, success, or error screens automatically.

---

## Roadmap / Future Goals

We plan to expand the CLI tool to support multiple popular state management architectures:
* **flutter_bloc**: Support for Bloc/Cubit architectures.
* **Riverpod**: Support for modern declarative state management and providers.
* **GetX**: Support for lightweight and high-performance reactive programming.
* **Custom templates**: Ability to load user-defined boilerplate structures.

---

## Contributing

Contributions are welcome! If you want to suggest an improvement, report a bug, or add new command options:

1. **Fork** the repository: `https://github.com/Dharti1623/flutter_architecture_cli`
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a **Pull Request** detailing your changes.

---

## Support & Donations

If this CLI generator saved you time and made your Flutter development easier, consider supporting the project:

* ☕ **Buy Me A Coffee**: [https://buymeacoffee.com/dhartichauhan](https://buymeacoffee.com/dhartichauhan)
* ⭐ **Star the Repository**: Show your support by giving our Github repository a star!
