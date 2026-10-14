## 1.0.4

* Add full FVM (Flutter Version Management) support across all commands with `--fvm` and `--fvm-version` flags.
* Add smart auto-detection for FVM when `flutter` is missing from system PATH or in FVM workspaces.
* Auto-configure `.fvm/flutter_sdk` in `.gitignore` and `.vscode/settings.json` for newly created projects.
* Automatically include `flutter_architecture_cli: ^1.0.4` in `dev_dependencies` of newly generated projects.
* Add project root directory auto-detection so all commands work smoothly even from subdirectories.
* Add smart data source auto-detection in `create_repository` command.
* Support Kotlin DSL (`build.gradle.kts`) in `change_bundle_id`.
* Fix smoke test generation so `flutter test` succeeds out of the box in new projects.
* Fix `BaseUiState.isError()` to prevent uninitialized states from evaluating as errors.
* Make `AppLocalizations` null-safe with fallback in `AppText` for widget tests.
* Add comprehensive form validation helper (email, phone, password, minLength/maxLength, url, numeric, compose) in generated projects.

## 1.0.3

* Add Medium blog tutorial link to README.md.

## 1.0.2

* Update README.md with dev_dependency setup guide and future roadmap goals.

## 1.0.1

* Fix missing dartdoc comments for public API symbols.
* Add code example in example/example.dart.

## 1.0.0

* Initial release of Clean Architecture Generator.
* Scaffold clean architecture layers using RxDart and Provider.
* Generate constants, theme, storage, network, base classes, localization, DI, and routes.
* Generate pre-styled common widgets.
* Support CLI commands: `create`, `create_screen`, `create_feature`, `create_model`, `create_repository`, `create_datasource`, and `create_service`.
