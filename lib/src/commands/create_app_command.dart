import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../templates/core_templates.dart';
import '../templates/common_templates.dart';
import '../templates/feature_templates.dart';
import '../templates/main_template.dart';
import '../templates/pubspec_template.dart';
import '../templates/localization_json_template.dart';
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';

class CreateAppCommand extends Command {
  @override
  final String name = 'create';

  @override
  final String description = 'Generates a clean production-ready architecture inside the target folder.';

  CreateAppCommand();

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print('Error: Please specify the app name. Usage: clean_architecture_generator create <app_name>');
      return;
    }

    final appName = StringUtils.toSnakeCase(rest.first);
    final targetDir = p.join(Directory.current.path, appName);

    print('Generating Flutter architecture in: $targetDir');

    print('Creating base Flutter project for all platforms using "flutter create"...');
    final createResult = Process.runSync(
      'flutter',
      ['create', '--org', 'com.example', appName],
      workingDirectory: Directory.current.path,
      runInShell: true,
    );

    if (createResult.stdout != null && createResult.stdout.toString().trim().isNotEmpty) {
      print(createResult.stdout);
    }
    if (createResult.stderr != null && createResult.stderr.toString().trim().isNotEmpty) {
      print(createResult.stderr);
    }

    if (createResult.exitCode != 0) {
      print('Error: "flutter create" failed with exit code ${createResult.exitCode}.');
      return;
    }

    void write(String path, String content) {
      final replaced = content.replaceAll('{{package_name}}', appName);
      FileHelper.writeFile(path, replaced);
    }

    // 1. Write pubspec.yaml
    write(
      p.join(targetDir, 'pubspec.yaml'),
      PubspecTemplate.buildPubspec(appName),
    );

    // 2. Write localization JSON
    write(
      p.join(targetDir, 'assets/translations/intl_en.json'),
      LocalizationJsonTemplate.enJson,
    );

    // Create empty directories for images and icons to prevent Flutter asset loading errors
    final imagesDir = Directory(p.join(targetDir, 'assets/images'));
    if (!imagesDir.existsSync()) imagesDir.createSync(recursive: true);
    final iconsDir = Directory(p.join(targetDir, 'assets/icons'));
    if (!iconsDir.existsSync()) iconsDir.createSync(recursive: true);

    // 3. Write core constants
    write(p.join(targetDir, 'lib/core/constants/api_endpoints.dart'), CoreTemplates.apiEndpoints);
    write(p.join(targetDir, 'lib/core/constants/app_constants.dart'), CoreTemplates.appConstants);
    write(p.join(targetDir, 'lib/core/constants/app_strings.dart'), CoreTemplates.appStrings);
    write(p.join(targetDir, 'lib/core/constants/app_images.dart'), CoreTemplates.appImages);
    write(p.join(targetDir, 'lib/core/constants/app_icons.dart'), CoreTemplates.appIcons);
    write(p.join(targetDir, 'lib/core/constants/app_fonts.dart'), CoreTemplates.appFonts);
    write(p.join(targetDir, 'lib/core/constants/app_dimensions.dart'), CoreTemplates.appDimensions);
    write(p.join(targetDir, 'lib/core/constants/app_spacing.dart'), CoreTemplates.appSpacing);
    write(p.join(targetDir, 'lib/core/constants/app_radius.dart'), CoreTemplates.appRadius);
    write(p.join(targetDir, 'lib/core/constants/app_durations.dart'), CoreTemplates.appDurations);
    write(p.join(targetDir, 'lib/core/constants/app_regex.dart'), CoreTemplates.appRegex);
    write(p.join(targetDir, 'lib/core/constants/app_keys.dart'), CoreTemplates.appKeys);
    write(p.join(targetDir, 'lib/core/constants/shared_pref_keys.dart'), CoreTemplates.sharedPrefKeys);
    write(p.join(targetDir, 'lib/core/constants/hive_boxes.dart'), CoreTemplates.hiveBoxes);
    write(p.join(targetDir, 'lib/core/constants/network_constants.dart'), CoreTemplates.networkConstants);
    write(p.join(targetDir, 'lib/core/constants/api_headers.dart'), CoreTemplates.apiHeaders);
    write(p.join(targetDir, 'lib/core/constants/asset_paths.dart'), CoreTemplates.assetPaths);
    write(p.join(targetDir, 'lib/core/constants/validation_messages.dart'), CoreTemplates.validationMessages);
    write(p.join(targetDir, 'lib/core/constants/error_messages.dart'), CoreTemplates.errorMessages);
    write(p.join(targetDir, 'lib/core/constants/route_names.dart'), CoreTemplates.routeNames);
    write(p.join(targetDir, 'lib/core/constants/environment.dart'), CoreTemplates.environment);
    write(p.join(targetDir, 'lib/core/constants/constants.dart'), CoreTemplates.constantsExport);

    // 4. Write core theme
    write(p.join(targetDir, 'lib/core/theme/app_colors.dart'), CoreTemplates.themeColors);
    write(p.join(targetDir, 'lib/core/theme/app_text_styles.dart'), CoreTemplates.themeTextStyles);
    write(p.join(targetDir, 'lib/core/theme/app_theme.dart'), CoreTemplates.themeTheme);
    write(p.join(targetDir, 'lib/core/theme/app_shadows.dart'), CoreTemplates.themeShadows);
    write(p.join(targetDir, 'lib/core/theme/app_borders.dart'), CoreTemplates.themeBorders);
    write(p.join(targetDir, 'lib/core/theme/theme.dart'), CoreTemplates.themeExport);

    // 5. Write core storage
    write(p.join(targetDir, 'lib/core/storage/storage_service.dart'), CoreTemplates.storageService);
    write(p.join(targetDir, 'lib/core/storage/secure_storage_service.dart'), CoreTemplates.secureStorageService);
    write(p.join(targetDir, 'lib/core/storage/app_preferences.dart'), CoreTemplates.appPreferences);
    write(p.join(targetDir, 'lib/core/storage/storage.dart'), CoreTemplates.storageExport);

    // 6. Write base & state classes
    write(p.join(targetDir, 'lib/core/base/base_bloc.dart'), CoreTemplates.baseBloc);
    write(p.join(targetDir, 'lib/core/base/base_mapper.dart'), CoreTemplates.baseMapper);
    write(p.join(targetDir, 'lib/core/base/base_ui_state.dart'), CoreTemplates.baseUiState);

    // 7. Write network layer
    write(p.join(targetDir, 'lib/core/network/api_response.dart'), CoreTemplates.apiResponse);
    write(p.join(targetDir, 'lib/core/network/api_exceptions.dart'), CoreTemplates.apiException);
    write(p.join(targetDir, 'lib/core/network/api_logger.dart'), CoreTemplates.apiLogger);
    write(p.join(targetDir, 'lib/core/network/logger_interceptor.dart'), CoreTemplates.loggerInterceptor);
    write(p.join(targetDir, 'lib/core/network/token_interceptor.dart'), CoreTemplates.tokenInterceptor);
    write(p.join(targetDir, 'lib/core/network/error_interceptor.dart'), CoreTemplates.errorInterceptor);
    write(p.join(targetDir, 'lib/core/network/api_client.dart'), CoreTemplates.apiClient);

    // 8. Write routing, localization, DI
    write(p.join(targetDir, 'lib/core/routes/app_routes.dart'), CoreTemplates.appRouter);
    write(p.join(targetDir, 'lib/core/localization/app_localizations.dart'), CoreTemplates.appLocalizations);
    write(p.join(targetDir, 'lib/core/localization/localization_service.dart'), CoreTemplates.localizationService);
    write(p.join(targetDir, 'lib/core/di/dependency_injection.dart'), CoreTemplates.di);

    // 9. Write common widgets
    write(p.join(targetDir, 'lib/common/widgets/app_text.dart'), CommonTemplates.appText);
    write(p.join(targetDir, 'lib/common/widgets/app_image.dart'), CommonTemplates.appImage);
    write(p.join(targetDir, 'lib/common/widgets/app_text_field.dart'), CommonTemplates.appTextField);
    write(p.join(targetDir, 'lib/common/widgets/app_button.dart'), CommonTemplates.appButton);
    write(p.join(targetDir, 'lib/common/widgets/app_container.dart'), CommonTemplates.appContainer);
    write(p.join(targetDir, 'lib/common/widgets/app_background.dart'), CommonTemplates.appBackground);
    write(p.join(targetDir, 'lib/common/widgets/app_loader.dart'), CommonTemplates.appLoader);
    write(p.join(targetDir, 'lib/common/widgets/app_empty_state.dart'), CommonTemplates.appEmptyState);
    write(p.join(targetDir, 'lib/common/widgets/app_error_widget.dart'), CommonTemplates.appErrorWidget);
    write(p.join(targetDir, 'lib/common/widgets/app_divider.dart'), CommonTemplates.appDivider);
    write(p.join(targetDir, 'lib/common/widgets/app_shimmer.dart'), CommonTemplates.appShimmer);
    write(p.join(targetDir, 'lib/common/widgets/app_network_status_widget.dart'), CommonTemplates.appNetworkStatusWidget);
    write(p.join(targetDir, 'lib/common/widgets/widgets.dart'), CommonTemplates.widgetsExport);

    // 10. Write common helpers & extensions
    write(p.join(targetDir, 'lib/common/helpers/dialog_helper.dart'), CommonTemplates.helperDialog);
    write(p.join(targetDir, 'lib/common/helpers/bottom_sheet_helper.dart'), CommonTemplates.helperBottomSheet);
    write(p.join(targetDir, 'lib/common/helpers/toast_helper.dart'), CommonTemplates.helperToast);
    write(p.join(targetDir, 'lib/common/helpers/snackbar_helper.dart'), CommonTemplates.helperSnackbar);
    write(p.join(targetDir, 'lib/common/helpers/navigation_helper.dart'), CommonTemplates.helperNavigation);
    write(p.join(targetDir, 'lib/common/helpers/url_launcher_helper.dart'), CommonTemplates.helperUrlLauncher);
    write(p.join(targetDir, 'lib/common/helpers/helpers.dart'), CommonTemplates.helpersExport);

    write(p.join(targetDir, 'lib/common/extensions/string_extensions.dart'), CommonTemplates.extString);
    write(p.join(targetDir, 'lib/common/extensions/date_time_extensions.dart'), CommonTemplates.extDateTime);
    write(p.join(targetDir, 'lib/common/extensions/context_extensions.dart'), CommonTemplates.extContext);
    write(p.join(targetDir, 'lib/common/extensions/widget_extensions.dart'), CommonTemplates.extWidget);
    write(p.join(targetDir, 'lib/common/extensions/iterable_extensions.dart'), CommonTemplates.extIterable);
    write(p.join(targetDir, 'lib/common/extensions/extensions.dart'), CommonTemplates.extensionsExport);

    // 11. Write common utilities
    write(p.join(targetDir, 'lib/core/utils/date_formatter.dart'), CommonTemplates.utilDateFormatter);
    write(p.join(targetDir, 'lib/core/utils/validators.dart'), CommonTemplates.utilValidators);
    write(p.join(targetDir, 'lib/core/utils/debouncer.dart'), CommonTemplates.utilDebouncer);
    write(p.join(targetDir, 'lib/core/utils/logger.dart'), CommonTemplates.utilLogger);
    write(p.join(targetDir, 'lib/core/utils/device_helper.dart'), CommonTemplates.utilDeviceHelper);
    write(p.join(targetDir, 'lib/core/utils/permission_helper.dart'), CommonTemplates.utilPermissionHelper);
    write(p.join(targetDir, 'lib/core/utils/connectivity_helper.dart'), CommonTemplates.utilConnectivityHelper);
    write(p.join(targetDir, 'lib/core/utils/internet_checker.dart'), CommonTemplates.utilInternetChecker);
    write(p.join(targetDir, 'lib/core/utils/file_picker_helper.dart'), CommonTemplates.utilFilePickerHelper);
    write(p.join(targetDir, 'lib/core/utils/image_picker_helper.dart'), CommonTemplates.utilImagePickerHelper);

    // 12. Write main.dart
    write(p.join(targetDir, 'lib/main.dart'), MainTemplate.mainDart);

    // 13. Write dummy users feature
    write(p.join(targetDir, 'lib/src/users/model/ui_entity/user_ui_entity.dart'), FeatureTemplates.userModel);
    write(p.join(targetDir, 'lib/src/users/model/response/user_response.dart'), FeatureTemplates.userDto);
    write(p.join(targetDir, 'lib/src/users/mapper/user_mapper.dart'), FeatureTemplates.userMapper);
    write(p.join(targetDir, 'lib/src/users/data_source/user_datasource.dart'), FeatureTemplates.userDataSource);
    write(p.join(targetDir, 'lib/src/users/repository/user_repository.dart'), FeatureTemplates.userRepository);
    
    write(p.join(targetDir, 'lib/src/users/state/user_state.dart'), FeatureTemplates.userState);
    write(p.join(targetDir, 'lib/src/users/bloc/user_bloc.dart'), FeatureTemplates.userController);
    write(p.join(targetDir, 'lib/src/users/state/user_provider.dart'), FeatureTemplates.userProvider);
    write(p.join(targetDir, 'lib/src/users/presentation/view/user_screen.dart'), FeatureTemplates.userScreen);

    // Create additional presentation placeholder & request directories
    final widgetsDir = Directory(p.join(targetDir, 'lib/src/users/presentation/widget'));
    if (!widgetsDir.existsSync()) widgetsDir.createSync(recursive: true);
    final requestDir = Directory(p.join(targetDir, 'lib/src/users/model/request'));
    if (!requestDir.existsSync()) requestDir.createSync(recursive: true);
    // Clean up .iml and .idea configuration files to prevent IntelliJ/Android Studio from loading it as a Java/Android package project
    try {
      final imlFile = File(p.join(targetDir, '$appName.iml'));
      if (imlFile.existsSync()) {
        var imlContent = imlFile.readAsStringSync();
        imlContent = imlContent
            .replaceAll('<sourceFolder url="file://\$MODULE_DIR\$/lib" isTestSource="false" />', '')
            .replaceAll('<sourceFolder url="file://\$MODULE_DIR\$/test" isTestSource="true" />', '');
        imlFile.writeAsStringSync(imlContent);
      }

      final modulesXmlFile = File(p.join(targetDir, '.idea/modules.xml'));
      if (modulesXmlFile.existsSync()) {
        var modulesContent = modulesXmlFile.readAsStringSync();
        final lines = modulesContent.split('\n');
        lines.removeWhere((line) => line.contains('_android.iml'));
        modulesXmlFile.writeAsStringSync(lines.join('\n'));
      }

      final androidImlFile = File(p.join(targetDir, 'android/${appName}_android.iml'));
      if (androidImlFile.existsSync()) {
        androidImlFile.deleteSync();
      }
    } catch (e) {
      print('Warning: Failed to clean up IDE module files: $e');
    }

    print('Running "flutter pub get" in $targetDir...');
    final result = Process.runSync(
      'flutter',
      ['pub', 'get'],
      workingDirectory: targetDir,
      runInShell: true,
    );

    if (result.stdout != null && result.stdout.toString().trim().isNotEmpty) {
      print(result.stdout);
    }
    if (result.stderr != null && result.stderr.toString().trim().isNotEmpty) {
      print(result.stderr);
    }

    if (result.exitCode == 0) {
      print('"flutter pub get" completed successfully.');
    } else {
      print('Warning: "flutter pub get" failed with exit code ${result.exitCode}.');
    }

    print('Running "dart format ." in $targetDir...');
    final formatResult = Process.runSync(
      'dart',
      ['format', '.'],
      workingDirectory: targetDir,
      runInShell: true,
    );

    if (formatResult.stdout != null && formatResult.stdout.toString().trim().isNotEmpty) {
      print(formatResult.stdout);
    }
    if (formatResult.stderr != null && formatResult.stderr.toString().trim().isNotEmpty) {
      print(formatResult.stderr);
    }

    if (formatResult.exitCode == 0) {
      print('"dart format" completed successfully.');
    } else {
      print('Warning: "dart format" failed with exit code ${formatResult.exitCode}.');
    }

    print('Project structure successfully created inside: $appName');
  }
}
