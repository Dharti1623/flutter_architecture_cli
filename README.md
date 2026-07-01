# Clean Architecture Generator

[![pub package](https://img.shields.io/pub/v/clean_architecture_generator.svg)](https://pub.dev/packages/clean_architecture_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20macos%20%7C%20web%20%7C%20linux%20%7C%20windows-blue.svg)](#)

A production-grade command-line tool designed to generate and scale clean architecture codebases in Flutter. It eliminates repetitive setup, enforcing a modular, highly scalable, and team-friendly project structure powered by RxDart streams and Provider.

---

## Table of Contents
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Installation](#installation)
- [Usage Guide](#usage-guide)
  - [1. Creating a New Application](#1-creating-a-new-application)
  - [2. Creating a Feature](#2-creating-a-feature)
  - [3. Creating a Screen](#3-creating-a-screen)
  - [4. Creating Models](#4-creating-models)
  - [5. Creating Data Sources](#5-creating-data-sources)
  - [6. Creating Repositories](#6-creating-repositories)
- [Architecture Flow](#architecture-flow)
- [Contributing](#contributing)
- [Support & Donations](#support--donations)

---

## Features

* **Zero-Configuration Architecture Setup**: Instant scaffolding covering storage, networking, localizations, utility helpers, and dependency injection.
* **Stream-Based State Management**: Seamless state handling inside Blocs using RxDart's `BehaviorSubject` and `CompositeSubscription`.
* **Centralized Networking**: Custom `ApiClient` powered by `Dio` with automatic logging, secure token handling, and robust exception-handling interceptors.
* **Unified UI State**: Standardized `BaseUiState` class for mapping screen loading, success, and error states.
* **Common Widget Toolkit**: Reusable components such as `AppText`, `AppImage`, `AppTextField`, `AppButton`, `AppLoader`, `AppShimmer`, and `AppNetworkStatusWidget`.
* **JSON-Based Localization**: Fully configured translations with convenient context translation extensions (`context.tr(...)`).

---

## Folder Structure

Generating a project produces this structured, clean tree:

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

## Installation

Activate the package globally to make the command available system-wide:

```bash
dart pub global activate clean_architecture_generator
```

---

## Usage Guide

### 1. Creating a New Application
Generate a fully bootstrapped Flutter project matching the architecture style:

```bash
clean_architecture_generator create <app_name>
```
*Example:*
```bash
clean_architecture_generator create my_awesome_app
```

### 2. Creating a Feature
Instantly scaffold a complete feature directory with its nested folders (`bloc`, `data_source`, `mapper`, `model/request`, `model/response`, `model/ui_entity`, `presentation/view`, `presentation/widget`, `repository`, `state`):

```bash
clean_architecture_generator create_feature <feature_name>
```
*Example:*
```bash
clean_architecture_generator create_feature products
```

### 3. Creating a Screen
Add a new screen to the presentation layer of a specific feature:

```bash
clean_architecture_generator create_screen <screen_name> -f <feature_name>
```
*Example:*
```bash
clean_architecture_generator create_screen product_detail -f products
```

### 4. Creating Models
Generate model response DTOs and matching UI Entity classes:

```bash
clean_architecture_generator create_model <model_name> -f <feature_name>
```
*Example:*
```bash
clean_architecture_generator create_model category -f products
```

### 5. Creating Data Sources
Generate a data source class in the specified feature:

```bash
clean_architecture_generator create_datasource <name> -f <feature_name>
```

### 6. Creating Repositories
Generate a repository class to bridge your data source and domain layer:

```bash
clean_architecture_generator create_repository <name> -f <feature_name>
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

## Contributing

Contributions are welcome! If you want to suggest an improvement, report a bug, or add new command options:

1. **Fork** the repository: `https://github.com/Dharti1623/clean_architecture_generator`
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a **Pull Request** detailing your changes.

---

## Support & Donations

If this CLI generator saved you time and made your Flutter development easier, consider supporting the project:

* ☕ **Buy Me A Coffee**: [https://buymeacoffee.com/dhartichauhan](https://buymeacoffee.com/dhartichauhan)
* ⭐ **Star the Repository**: Show your support by giving our Github repository a star!

