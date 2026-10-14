# Flutter Architecture CLI

[![pub package](https://img.shields.io/pub/v/flutter_architecture_cli.svg)](https://pub.dev/packages/flutter_architecture_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20macos%20%7C%20web%20%7C%20linux%20%7C%20windows-blue.svg)](#)

A production-grade command-line tool designed to generate and scale clean architecture codebases in Flutter. It eliminates repetitive setup, enforcing a modular, highly scalable, and team-friendly project structure with your choice of state management: **flutter_bloc** (Event & State-driven) or **RxDart + Provider** (Stream-driven).

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
- [Form Validation Helper](#form-validation-helper)
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
* **Dual State Management Support**: Full out-of-the-box support for both **flutter_bloc** (`Bloc<Event, State>`, `BlocProvider`, `BlocBuilder`) and **RxDart + Provider** (`BehaviorSubject` stream pipelines).
* **Smart Architecture Auto-Detection**: Commands like `create_feature` automatically inspect your project's `pubspec.yaml` to detect whether you're using BLoC or RxDart and generate matching code with 0 configuration.
* **Centralized Networking**: Custom `ApiClient` powered by `Dio` with automatic logging, secure token handling, and robust exception-handling interceptors.
* **Common Widget Toolkit**: Reusable components such as `AppText`, `AppImage`, `AppTextField`, `AppButton`, `AppLoader`, `AppShimmer`, and `AppNetworkStatusWidget`.
* **Built-in Validation Engine**: Comprehensive `Validators` utility covering `required`, `email`, `phone`, `minLength`, `maxLength`, `password`, `numeric`, `url`, and `compose(...)` validation chains.
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

You can run commands in two ways depending on how you installed the package:
* **As a project dev dependency (Recommended)**: Prefix with `dart run flutter_architecture_cli` (or `fvm dart run flutter_architecture_cli`).
* **Globally activated**: Run `flutter_architecture_cli <command>` directly.

Below is the detailed reference for all **8 available commands**.

---

### 1. `create` — Scaffold a New Clean Architecture App

Creates a complete, production-ready Flutter application with all architectural layers, common widgets, networking, storage, localization, and a working smoke test. Supports both **flutter_bloc** and **RxDart + Provider**.

#### Interactive State Management Selection:
When running in an interactive terminal, the CLI prompts you to select your preferred architecture:
```text
Select State Management Architecture:
  [1] RxDart + Provider (Stream-based) [Default]
  [2] flutter_bloc (Event & State based BLoC)
Choose an option (1 or 2) [default: 1]:
```

#### Syntax & Options:
```bash
# Basic syntax
flutter_architecture_cli create <app_name> [options]

# Options:
#   --state         State management architecture: 'rxdart' or 'bloc' (default: rxdart)
#   --bloc          Shortcut flag to scaffold using flutter_bloc
#   --org           Organization reverse-domain (default: com.example)
#   --fvm           Use FVM (Flutter Version Management) for creation & formatting
#   --fvm-version   Pin a specific Flutter SDK version in FVM (e.g., 3.22.0)
```

#### Examples:
```bash
# Interactive creation (prompts for architecture selection)
flutter_architecture_cli create my_shop_app

# Scaffold with flutter_bloc directly (skips prompt)
flutter_architecture_cli create my_shop_app --state bloc
# or
flutter_architecture_cli create my_shop_app --bloc

# Scaffold with RxDart + Provider directly
flutter_architecture_cli create my_shop_app --state rxdart

# With custom package / bundle ID domain
flutter_architecture_cli create my_shop_app --org com.mycompany --bloc

# With FVM
flutter_architecture_cli create my_shop_app --fvm

# With FVM and pinned Flutter version
flutter_architecture_cli create my_shop_app --fvm --fvm-version 3.24.0 --bloc
```

#### What it generates:
- Full Clean Architecture folder structure (`lib/common/`, `lib/core/`, `lib/src/users/`).
- `lib/main.dart` with pre-configured DI, Localization, and Theme.
- A functional dummy `users` feature showcasing the full Bloc + DataSource + Repository + Mapper + UI Entity data flow (using `flutter_bloc` or `RxDart` based on your choice).
- A passing `test/widget_test.dart` smoke test.
- Automatically adds `flutter_architecture_cli: ^1.0.5` to `dev_dependencies` inside `pubspec.yaml`.

---

### 2. `create_feature` — Generate a Complete Feature Layer

Instantly creates an entire feature-first folder structure with state management, data, and presentation layers wired together.

> [!TIP]
> **Smart Architecture Auto-Detection**: `create_feature` inspects your `pubspec.yaml`. If your project includes `flutter_bloc`, it automatically generates a complete BLoC pattern (`_event.dart`, `_state.dart`, `_bloc.dart`, and `BlocBuilder` view). Otherwise, it generates the RxDart stream pattern! You can also explicitly pass `--state bloc` or `--bloc`.

#### Syntax & Options:
```bash
flutter_architecture_cli create_feature <feature_name> [options]

# Options:
#   --state         State management override ('rxdart' or 'bloc')
#   --bloc          Shortcut flag to force flutter_bloc feature generation
#   --fvm           Format generated code using FVM
```

#### Examples:
```bash
# Auto-detects architecture from pubspec.yaml:
dart run flutter_architecture_cli create_feature products

# Explicitly create as flutter_bloc:
dart run flutter_architecture_cli create_feature products --bloc

# Explicitly create as RxDart:
dart run flutter_architecture_cli create_feature products --state rxdart

# With FVM
fvm dart run flutter_architecture_cli create_feature products
```

#### Generated Structure with `flutter_bloc`:
```text
lib/src/products/
├── bloc/
│   ├── products_bloc.dart          # Bloc<ProductsEvent, ProductsState>
│   ├── products_event.dart         # FetchProductsEvent, etc.
│   └── products_state.dart         # BaseUiState subclass with initial/loading/completed/error
├── data_source/
│   └── products_datasource.dart    # ApiClient data layer
├── mapper/
│   └── products_mapper.dart        # Transforms Response DTO -> UiEntity
├── model/
│   ├── request/                    # Request parameter models placeholder
│   ├── response/
│   │   └── products_response.dart  # Raw JSON network DTO with fromJson/toJson
│   └── ui_entity/
│       └── products_ui_entity.dart # Clean UI domain entity
├── presentation/
│   ├── view/
│   │   └── products_screen.dart    # BlocProvider + BlocBuilder view with Loader & Error
│   └── widget/                     # Custom widgets for this feature
└── repository/
    └── products_repository.dart    # Bridge between DataSource & Bloc
```

#### Generated Structure with `RxDart + Provider`:
```text
lib/src/products/
├── bloc/
│   └── products_bloc.dart          # RxDart BehaviorSubject state emitter
├── data_source/
│   └── products_datasource.dart    # ApiClient data layer
├── mapper/
│   └── products_mapper.dart        # Transforms Response DTO -> UiEntity
├── model/
│   ├── request/                    # Request parameter models placeholder
│   ├── response/
│   │   └── products_response.dart  # Raw JSON network DTO with fromJson/toJson
│   └── ui_entity/
│       └── products_ui_entity.dart # Clean UI domain entity
├── presentation/
│   ├── view/
│   │   └── products_screen.dart    # StreamBuilder view with AppText, Loader & ErrorWidget
│   └── widget/                     # Custom widgets for this feature
├── repository/
│   └── products_repository.dart    # Bridge between DataSource & Bloc
└── state/
    ├── products_state.dart         # BaseUiState subclass (loading, completed, error)
    └── products_provider.dart      # Provider DI wire-up
```

---

### 3. `create_screen` — Add a Presentation Screen

Adds a new screen widget to an existing or new feature's presentation layer.

#### Syntax & Options:
```bash
flutter_architecture_cli create_screen <screen_name> -f <feature_name> [--fvm]

# Options:
#   -f, --feature   The target feature folder inside lib/src/ (defaults to screen name)
#   --fvm           Format generated code using FVM
```

#### Examples:
```bash
# Create "checkout_screen.dart" inside lib/src/cart/presentation/view/
flutter_architecture_cli create_screen checkout -f cart

# Using dart run
dart run flutter_architecture_cli create_screen profile_settings -f profile

# Using FVM
fvm dart run flutter_architecture_cli create_screen product_details -f products
```

#### What it generates:
- Generates `lib/src/<feature>/presentation/view/<screen_name>_screen.dart`.
- Includes a clean `StatelessWidget` with `Scaffold`, `AppBar`, `AppText`, and a static `routeName`.

---

### 4. `create_model` — Generate UI Entity and Response DTO

Generates both the UI Entity (domain model) and the Response Model (with JSON serialization).

#### Syntax & Options:
```bash
flutter_architecture_cli create_model <model_name> -f <feature_name> [--fvm]

# Options:
#   -f, --feature   The target feature folder inside lib/src/
#   --fvm           Format generated code using FVM
```

#### Examples:
```bash
# Generate product_ui_entity.dart and product_response.dart
flutter_architecture_cli create_model product -f products

# Using dart run
dart run flutter_architecture_cli create_model order -f orders
```

#### What it generates:
1. `lib/src/<feature>/model/ui_entity/<model_name>_ui_entity.dart` — Clean model for UI consumption.
2. `lib/src/<feature>/model/response/<model_name>_response.dart` — Network DTO with `fromJson()` and `toJson()` methods.

---

### 5. `create_datasource` — Generate an API Data Source

Creates an API data source class wired with the singleton `ApiClient`.

#### Syntax & Options:
```bash
flutter_architecture_cli create_datasource <name> -f <feature_name> [--fvm]

# Options:
#   -f, --feature   The target feature folder inside lib/src/
#   --fvm           Format generated code using FVM
```

#### Examples:
```bash
# Generate payment_datasource.dart in lib/src/payment/data_source/
flutter_architecture_cli create_datasource payment -f payment

# Using dart run
dart run flutter_architecture_cli create_datasource order -f orders
```

#### What it generates:
- `lib/src/<feature>/data_source/<name>_datasource.dart` with `final ApiClient _apiClient = ApiClient.instance;`.

---

### 6. `create_repository` — Generate a Repository

Generates a repository class bridging your DataSource and Bloc. It automatically scans your feature directory and links to any existing data sources to avoid manual import wiring.

#### Syntax & Options:
```bash
flutter_architecture_cli create_repository <name> -f <feature_name> [--fvm]

# Options:
#   -f, --feature   The target feature folder inside lib/src/
#   --fvm           Format generated code using FVM
```

#### Examples:
```bash
# Generate cart_repository.dart in lib/src/cart/repository/
flutter_architecture_cli create_repository cart -f cart

# Using dart run
dart run flutter_architecture_cli create_repository order -f orders
```

#### What it generates:
- `lib/src/<feature>/repository/<name>_repository.dart`
- Automatically discovers and injects the feature's data source:
  ```dart
  import 'package:my_app/src/cart/data_source/cart_datasource.dart';

  class CartRepository {
    final CartDataSource _dataSource = CartDataSource();
    // Add repository operations
  }
  ```

---

### 7. `create_service` — Generate a Core Singleton Service

Generates a core application service using the thread-safe singleton pattern in `lib/core/services/`.

#### Syntax & Options:
```bash
flutter_architecture_cli create_service <service_name> [--fvm]

# Options:
#   --fvm   Format generated code using FVM
```

#### Examples:
```bash
# Create auth_service.dart in lib/core/services/
flutter_architecture_cli create_service auth

# Create analytics_service.dart using dart run
dart run flutter_architecture_cli create_service analytics

# Using FVM
fvm dart run flutter_architecture_cli create_service notification
```

#### What it generates:
`lib/core/services/<service_name>_service.dart`:
```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<void> init() async {
    // Service initialization logic
  }
}
```

---

### 8. `change_bundle_id` — Rename Package Name / Bundle ID

Safely updates the Android application ID/namespace and iOS bundle identifier across the entire project in one step.

#### Syntax & Options:
```bash
flutter_architecture_cli change_bundle_id <new_bundle_id>
```

#### Examples:
```bash
# Global CLI
flutter_architecture_cli change_bundle_id com.mycompany.shopapp

# As Dev Dependency (Standard)
dart run flutter_architecture_cli change_bundle_id com.mycompany.shopapp

# As Dev Dependency (FVM)
fvm dart run flutter_architecture_cli change_bundle_id com.mycompany.shopapp
```

#### What it updates automatically:
- **Android**:
  - `android/app/build.gradle` (`applicationId`, `namespace`).
  - `android/app/build.gradle.kts` (Kotlin DSL support).
  - `android/app/src/main/AndroidManifest.xml` (`package="..."`).
  - Moves `MainActivity.kt` or `MainActivity.java` to the new package directory structure and cleans up old empty folders.
- **iOS**:
  - `ios/Runner.xcodeproj/project.pbxproj` (`PRODUCT_BUNDLE_IDENTIFIER`).

---

## Architecture Flow

The generated structure focuses on a single directional data flow:

1. **DataSource**: Fetches raw JSON data using `ApiClient` and parses it into a Response DTO (`model/response/`).
2. **Mapper**: Inherits from `BaseMapper` to transform the Response DTO into a clean UI Entity (`model/ui_entity/`).
3. **Repository**: Requests data from `DataSource` and runs the mapped results up to the Bloc layer.
4. **Bloc**: Standardizes UI state management by converting repository streams into `BaseUiState` (Loading -> Completed/Error) emitted via `BehaviorSubject`.
5. **Presentation (View)**: Listens to the Bloc subjects using `StreamBuilder` and renders loading, success, or error screens automatically.

---

## Form Validation Helper

Every scaffolded application includes `lib/core/utils/validators.dart`, providing a robust, pre-built validation engine. It integrates seamlessly with `AppTextField` and Flutter's standard `TextFormField`:

```dart
import 'package:my_app/core/utils/validators.dart';

// 1. Direct validation functions
AppTextField(
  label: 'Email',
  validator: Validators.email,
)

// 2. Custom error messages
AppTextField(
  label: 'Username',
  validator: (val) => Validators.required(val, 'Username is required'),
)

// 3. Length constraints
AppTextField(
  label: 'Bio',
  validator: (val) => Validators.maxLength(val, 150),
)

// 4. Password validation (with optional number & special character checks)
AppTextField(
  label: 'Password',
  isPassword: true,
  validator: (val) => Validators.password(
    val,
    minLength: 8,
    requireNumber: true,
    requireSpecialChar: true,
  ),
)

// 5. Password Confirmation Matching
AppTextField(
  label: 'Confirm Password',
  isPassword: true,
  validator: (val) => Validators.match(val, passwordController.text, 'Passwords do not match'),
)

// 6. Chained validation rules (executes sequentially)
AppTextField(
  label: 'Work Email',
  validator: Validators.compose([
    Validators.required,
    Validators.email,
  ]),
)
```

### Available Validator Methods:
* `Validators.required(value, [message])` — Validates non-empty input.
* `Validators.email(value, [message])` — Validates RFC-compliant email address format.
* `Validators.phone(value, [message])` — Validates 10-12 digit phone numbers.
* `Validators.minLength(value, min, [message])` — Enforces minimum character length.
* `Validators.maxLength(value, max, [message])` — Enforces maximum character length limit.
* `Validators.password(value, {minLength, requireNumber, requireSpecialChar, message})` — Validates password complexity.
* `Validators.match(value, target, [message])` — Validates that two inputs match (e.g. password confirmation).
* `Validators.numeric(value, [message])` — Ensures input contains only numeric digits.
* `Validators.url(value, [message])` — Ensures valid HTTP/HTTPS URL syntax.
* `Validators.compose([...])` — Sequentially executes a list of validator functions and returns the first error encountered.

---

## Roadmap / Future Goals

We plan to expand the CLI tool to support multiple popular state management architectures:
* [x] **flutter_bloc**: Support for Bloc/Event/State architecture with `BlocBuilder` and `BlocProvider` *(Added in v1.0.5)*.
* [ ] **Riverpod**: Support for modern declarative state management and providers.
* [ ] **GetX**: Support for lightweight and high-performance reactive programming.
* [ ] **Custom templates**: Ability to load user-defined boilerplate structures.

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
