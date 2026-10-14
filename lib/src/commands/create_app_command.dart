import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../templates/core_templates.dart';
import '../templates/common_templates.dart';
import '../templates/feature_templates.dart';
import '../templates/main_template.dart';
import '../templates/pubspec_template.dart';
import '../templates/localization_json_template.dart';
import '../templates/bloc_templates.dart';
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';
import '../utils/fvm_helper.dart';

class CreateAppCommand extends Command {
  @override
  final String name = 'create';

  @override
  final String description =
      'Generates a clean production-ready architecture inside the target folder.';

  CreateAppCommand() {
    argParser.addFlag(
      'fvm',
      negatable: false,
      help: 'Use FVM (Flutter Version Management) instead of system Flutter.',
    );
    argParser.addOption(
      'fvm-version',
      help:
          'Specify the Flutter SDK version to pin with FVM (e.g. stable, 3.22.0).',
    );
    argParser.addOption(
      'org',
      defaultsTo: 'com.example',
      help:
          'The organization responsible for your new Flutter project, in reverse domain name notation.',
    );
    argParser.addOption(
      'state',
      allowed: ['rxdart', 'bloc'],
      help: 'State management architecture (rxdart or bloc).',
    );
    argParser.addFlag(
      'bloc',
      negatable: false,
      help: 'Use flutter_bloc (Events & States) architecture.',
    );
  }

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print(
          'Error: Please specify the app name. Usage: flutter_architecture_cli create <app_name>');
      return;
    }

    final appName = StringUtils.toSnakeCase(rest.first);
    final targetDir = p.join(Directory.current.path, appName);
    final org = argResults?['org'] as String? ?? 'com.example';
    final explicitFvm = argResults?['fvm'] == true;
    final fvmVersion = argResults?['fvm-version'] as String?;

    String stateChoice =
        (argResults?['state'] as String?)?.toLowerCase() ?? '';
    if (argResults?['bloc'] == true) {
      stateChoice = 'bloc';
    }

    if (stateChoice.isEmpty) {
      if (stdin.hasTerminal) {
        print('');
        print('Select State Management Architecture:');
        print('  [1] RxDart + Provider (Stream-based) [Default]');
        print('  [2] flutter_bloc (Event & State based BLoC)');
        stdout.write('Choose an option (1 or 2) [default: 1]: ');
        final input = stdin.readLineSync()?.trim();
        if (input == '2' || input?.toLowerCase() == 'bloc') {
          stateChoice = 'bloc';
        } else {
          stateChoice = 'rxdart';
        }
        print(
            'Selected: ${stateChoice == "bloc" ? "flutter_bloc" : "RxDart + Provider"}\n');
      } else {
        stateChoice = 'rxdart';
      }
    }

    final isBloc = stateChoice == 'bloc';

    final isFlutterAvailable = FvmHelper.isCommandAvailable('flutter');
    final isFvmAvailable = FvmHelper.isCommandAvailable('fvm');

    bool useFvm = explicitFvm;
    if (!useFvm && FvmHelper.isFvmConfigured()) {
      if (isFvmAvailable) {
        print(
            'Notice: Detected .fvm directory in current workspace. Using FVM automatically.');
        useFvm = true;
      }
    } else if (!useFvm && !isFlutterAvailable && isFvmAvailable) {
      print(
          'Notice: "flutter" command not found in PATH, but "fvm" is available. Using FVM automatically.');
      useFvm = true;
    }

    if (useFvm && !isFvmAvailable) {
      print(
          'Error: FVM was requested, but "fvm" command was not found in your PATH.');
      print(
          'Please install FVM first: https://fvm.app/docs/getting_started/installation');
      return;
    }

    if (!useFvm && !isFlutterAvailable) {
      print('Error: "flutter" command was not found in your system PATH.');
      print(
          'If you use FVM, please run with the --fvm flag: flutter_architecture_cli create $appName --fvm');
      print(
          'Otherwise, ensure Flutter SDK is installed and added to your system PATH.');
      return;
    }

    print('Generating Flutter architecture in: $targetDir');

    final runnerLabel = useFvm ? 'fvm flutter' : 'flutter';
    print('Creating base Flutter project using "$runnerLabel create"...');

    final createResult = FvmHelper.runFlutter(
      ['create', '--org', org, appName],
      useFvm: useFvm,
      workingDirectory: Directory.current.path,
    );

    if (createResult.stdout != null &&
        createResult.stdout.toString().trim().isNotEmpty) {
      print(createResult.stdout);
    }
    if (createResult.stderr != null &&
        createResult.stderr.toString().trim().isNotEmpty) {
      print(createResult.stderr);
    }

    if (createResult.exitCode != 0) {
      print(
          'Error: "$runnerLabel create" failed with exit code ${createResult.exitCode}.');
      if (!useFvm && isFvmAvailable) {
        print(
            'Tip: Try running with --fvm if you use FVM: flutter_architecture_cli create $appName --fvm');
      }
      return;
    }

    void write(String path, String content) {
      final replaced = content.replaceAll('{{package_name}}', appName);
      FileHelper.writeFile(path, replaced);
    }

    // 1. Write pubspec.yaml
    write(
      p.join(targetDir, 'pubspec.yaml'),
      PubspecTemplate.buildPubspec(appName, isBloc: isBloc),
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
    write(p.join(targetDir, 'lib/core/constants/api_endpoints.dart'),
        CoreTemplates.apiEndpoints);
    write(p.join(targetDir, 'lib/core/constants/app_constants.dart'),
        CoreTemplates.appConstants);
    write(p.join(targetDir, 'lib/core/constants/app_strings.dart'),
        CoreTemplates.appStrings);
    write(p.join(targetDir, 'lib/core/constants/app_images.dart'),
        CoreTemplates.appImages);
    write(p.join(targetDir, 'lib/core/constants/app_icons.dart'),
        CoreTemplates.appIcons);
    write(p.join(targetDir, 'lib/core/constants/app_fonts.dart'),
        CoreTemplates.appFonts);
    write(p.join(targetDir, 'lib/core/constants/app_dimensions.dart'),
        CoreTemplates.appDimensions);
    write(p.join(targetDir, 'lib/core/constants/app_spacing.dart'),
        CoreTemplates.appSpacing);
    write(p.join(targetDir, 'lib/core/constants/app_radius.dart'),
        CoreTemplates.appRadius);
    write(p.join(targetDir, 'lib/core/constants/app_durations.dart'),
        CoreTemplates.appDurations);
    write(p.join(targetDir, 'lib/core/constants/app_regex.dart'),
        CoreTemplates.appRegex);
    write(p.join(targetDir, 'lib/core/constants/app_keys.dart'),
        CoreTemplates.appKeys);
    write(p.join(targetDir, 'lib/core/constants/shared_pref_keys.dart'),
        CoreTemplates.sharedPrefKeys);
    write(p.join(targetDir, 'lib/core/constants/hive_boxes.dart'),
        CoreTemplates.hiveBoxes);
    write(p.join(targetDir, 'lib/core/constants/network_constants.dart'),
        CoreTemplates.networkConstants);
    write(p.join(targetDir, 'lib/core/constants/api_headers.dart'),
        CoreTemplates.apiHeaders);
    write(p.join(targetDir, 'lib/core/constants/asset_paths.dart'),
        CoreTemplates.assetPaths);
    write(p.join(targetDir, 'lib/core/constants/validation_messages.dart'),
        CoreTemplates.validationMessages);
    write(p.join(targetDir, 'lib/core/constants/error_messages.dart'),
        CoreTemplates.errorMessages);
    write(p.join(targetDir, 'lib/core/constants/route_names.dart'),
        CoreTemplates.routeNames);
    write(p.join(targetDir, 'lib/core/constants/environment.dart'),
        CoreTemplates.environment);
    write(p.join(targetDir, 'lib/core/constants/constants.dart'),
        CoreTemplates.constantsExport);

    // 4. Write core theme
    write(p.join(targetDir, 'lib/core/theme/app_colors.dart'),
        CoreTemplates.themeColors);
    write(p.join(targetDir, 'lib/core/theme/app_text_styles.dart'),
        CoreTemplates.themeTextStyles);
    write(p.join(targetDir, 'lib/core/theme/app_theme.dart'),
        CoreTemplates.themeTheme);
    write(p.join(targetDir, 'lib/core/theme/app_shadows.dart'),
        CoreTemplates.themeShadows);
    write(p.join(targetDir, 'lib/core/theme/app_borders.dart'),
        CoreTemplates.themeBorders);
    write(p.join(targetDir, 'lib/core/theme/theme.dart'),
        CoreTemplates.themeExport);

    // 5. Write core storage
    write(p.join(targetDir, 'lib/core/storage/storage_service.dart'),
        CoreTemplates.storageService);
    write(p.join(targetDir, 'lib/core/storage/secure_storage_service.dart'),
        CoreTemplates.secureStorageService);
    write(p.join(targetDir, 'lib/core/storage/app_preferences.dart'),
        CoreTemplates.appPreferences);
    write(p.join(targetDir, 'lib/core/storage/storage.dart'),
        CoreTemplates.storageExport);

    // 6. Write base & state classes
    write(p.join(targetDir, 'lib/core/base/base_bloc.dart'),
        CoreTemplates.baseBloc);
    write(p.join(targetDir, 'lib/core/base/base_mapper.dart'),
        CoreTemplates.baseMapper);
    write(p.join(targetDir, 'lib/core/base/base_ui_state.dart'),
        CoreTemplates.baseUiState);

    // 7. Write network layer
    write(p.join(targetDir, 'lib/core/network/api_response.dart'),
        CoreTemplates.apiResponse);
    write(p.join(targetDir, 'lib/core/network/api_exceptions.dart'),
        CoreTemplates.apiException);
    write(p.join(targetDir, 'lib/core/network/api_logger.dart'),
        CoreTemplates.apiLogger);
    write(p.join(targetDir, 'lib/core/network/logger_interceptor.dart'),
        CoreTemplates.loggerInterceptor);
    write(p.join(targetDir, 'lib/core/network/token_interceptor.dart'),
        CoreTemplates.tokenInterceptor);
    write(p.join(targetDir, 'lib/core/network/error_interceptor.dart'),
        CoreTemplates.errorInterceptor);
    write(p.join(targetDir, 'lib/core/network/api_client.dart'),
        CoreTemplates.apiClient);

    // 8. Write routing, localization, DI
    write(p.join(targetDir, 'lib/core/routes/app_routes.dart'),
        CoreTemplates.appRouter);
    write(p.join(targetDir, 'lib/core/localization/app_localizations.dart'),
        CoreTemplates.appLocalizations);
    write(p.join(targetDir, 'lib/core/localization/localization_service.dart'),
        CoreTemplates.localizationService);
    write(p.join(targetDir, 'lib/core/di/dependency_injection.dart'),
        CoreTemplates.di);

    // 9. Write common widgets
    write(p.join(targetDir, 'lib/common/widgets/app_text.dart'),
        CommonTemplates.appText);
    write(p.join(targetDir, 'lib/common/widgets/app_image.dart'),
        CommonTemplates.appImage);
    write(p.join(targetDir, 'lib/common/widgets/app_text_field.dart'),
        CommonTemplates.appTextField);
    write(p.join(targetDir, 'lib/common/widgets/app_button.dart'),
        CommonTemplates.appButton);
    write(p.join(targetDir, 'lib/common/widgets/app_container.dart'),
        CommonTemplates.appContainer);
    write(p.join(targetDir, 'lib/common/widgets/app_background.dart'),
        CommonTemplates.appBackground);
    write(p.join(targetDir, 'lib/common/widgets/app_loader.dart'),
        CommonTemplates.appLoader);
    write(p.join(targetDir, 'lib/common/widgets/app_empty_state.dart'),
        CommonTemplates.appEmptyState);
    write(p.join(targetDir, 'lib/common/widgets/app_error_widget.dart'),
        CommonTemplates.appErrorWidget);
    write(p.join(targetDir, 'lib/common/widgets/app_divider.dart'),
        CommonTemplates.appDivider);
    write(p.join(targetDir, 'lib/common/widgets/app_shimmer.dart'),
        CommonTemplates.appShimmer);
    write(
        p.join(targetDir, 'lib/common/widgets/app_network_status_widget.dart'),
        CommonTemplates.appNetworkStatusWidget);
    write(p.join(targetDir, 'lib/common/widgets/widgets.dart'),
        CommonTemplates.widgetsExport);

    // 10. Write common helpers & extensions
    write(p.join(targetDir, 'lib/common/helpers/dialog_helper.dart'),
        CommonTemplates.helperDialog);
    write(p.join(targetDir, 'lib/common/helpers/bottom_sheet_helper.dart'),
        CommonTemplates.helperBottomSheet);
    write(p.join(targetDir, 'lib/common/helpers/toast_helper.dart'),
        CommonTemplates.helperToast);
    write(p.join(targetDir, 'lib/common/helpers/snackbar_helper.dart'),
        CommonTemplates.helperSnackbar);
    write(p.join(targetDir, 'lib/common/helpers/navigation_helper.dart'),
        CommonTemplates.helperNavigation);
    write(p.join(targetDir, 'lib/common/helpers/url_launcher_helper.dart'),
        CommonTemplates.helperUrlLauncher);
    write(p.join(targetDir, 'lib/common/helpers/helpers.dart'),
        CommonTemplates.helpersExport);

    write(p.join(targetDir, 'lib/common/extensions/string_extensions.dart'),
        CommonTemplates.extString);
    write(p.join(targetDir, 'lib/common/extensions/date_time_extensions.dart'),
        CommonTemplates.extDateTime);
    write(p.join(targetDir, 'lib/common/extensions/context_extensions.dart'),
        CommonTemplates.extContext);
    write(p.join(targetDir, 'lib/common/extensions/widget_extensions.dart'),
        CommonTemplates.extWidget);
    write(p.join(targetDir, 'lib/common/extensions/iterable_extensions.dart'),
        CommonTemplates.extIterable);
    write(p.join(targetDir, 'lib/common/extensions/extensions.dart'),
        CommonTemplates.extensionsExport);

    // 11. Write common utilities
    write(p.join(targetDir, 'lib/core/utils/date_formatter.dart'),
        CommonTemplates.utilDateFormatter);
    write(p.join(targetDir, 'lib/core/utils/validators.dart'),
        CommonTemplates.utilValidators);
    write(p.join(targetDir, 'lib/core/utils/debouncer.dart'),
        CommonTemplates.utilDebouncer);
    write(p.join(targetDir, 'lib/core/utils/logger.dart'),
        CommonTemplates.utilLogger);
    write(p.join(targetDir, 'lib/core/utils/device_helper.dart'),
        CommonTemplates.utilDeviceHelper);
    write(p.join(targetDir, 'lib/core/utils/permission_helper.dart'),
        CommonTemplates.utilPermissionHelper);
    write(p.join(targetDir, 'lib/core/utils/connectivity_helper.dart'),
        CommonTemplates.utilConnectivityHelper);
    write(p.join(targetDir, 'lib/core/utils/internet_checker.dart'),
        CommonTemplates.utilInternetChecker);
    write(p.join(targetDir, 'lib/core/utils/file_picker_helper.dart'),
        CommonTemplates.utilFilePickerHelper);
    write(p.join(targetDir, 'lib/core/utils/image_picker_helper.dart'),
        CommonTemplates.utilImagePickerHelper);

    // 12. Write main.dart and dummy users feature
    if (isBloc) {
      write(p.join(targetDir, 'lib/main.dart'), BlocTemplates.mainDart);
      write(
          p.join(targetDir, 'lib/src/users/model/ui_entity/user_ui_entity.dart'),
          FeatureTemplates.userModel);
      write(p.join(targetDir, 'lib/src/users/model/response/user_response.dart'),
          FeatureTemplates.userDto);
      write(p.join(targetDir, 'lib/src/users/mapper/user_mapper.dart'),
          FeatureTemplates.userMapper);
      write(p.join(targetDir, 'lib/src/users/data_source/user_datasource.dart'),
          FeatureTemplates.userDataSource);
      write(p.join(targetDir, 'lib/src/users/repository/user_repository.dart'),
          BlocTemplates.userRepository);
      write(p.join(targetDir, 'lib/src/users/bloc/user_event.dart'),
          BlocTemplates.userEvent);
      write(p.join(targetDir, 'lib/src/users/bloc/user_state.dart'),
          BlocTemplates.userState);
      write(p.join(targetDir, 'lib/src/users/bloc/user_bloc.dart'),
          BlocTemplates.userBloc);
      write(p.join(targetDir, 'lib/src/users/presentation/view/user_screen.dart'),
          BlocTemplates.userScreen);
    } else {
      write(p.join(targetDir, 'lib/main.dart'), MainTemplate.mainDart);
      write(
          p.join(targetDir, 'lib/src/users/model/ui_entity/user_ui_entity.dart'),
          FeatureTemplates.userModel);
      write(p.join(targetDir, 'lib/src/users/model/response/user_response.dart'),
          FeatureTemplates.userDto);
      write(p.join(targetDir, 'lib/src/users/mapper/user_mapper.dart'),
          FeatureTemplates.userMapper);
      write(p.join(targetDir, 'lib/src/users/data_source/user_datasource.dart'),
          FeatureTemplates.userDataSource);
      write(p.join(targetDir, 'lib/src/users/repository/user_repository.dart'),
          FeatureTemplates.userRepository);
      write(p.join(targetDir, 'lib/src/users/state/user_state.dart'),
          FeatureTemplates.userState);
      write(p.join(targetDir, 'lib/src/users/bloc/user_bloc.dart'),
          FeatureTemplates.userController);
      write(p.join(targetDir, 'lib/src/users/state/user_provider.dart'),
          FeatureTemplates.userProvider);
      write(p.join(targetDir, 'lib/src/users/presentation/view/user_screen.dart'),
          FeatureTemplates.userScreen);
    }

    // 14. Write working smoke test replacing default counter test
    write(
      p.join(targetDir, 'test/widget_test.dart'),
      '''
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:{{package_name}}/core/di/dependency_injection.dart';
import 'package:{{package_name}}/main.dart';

void main() {
  testWidgets('App renders without crashing smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: DependencyInjection.providers,
        child: const MyApp(),
      ),
    );
    expect(find.byType(MyApp), findsOneWidget);
  });
}
''',
    );

    // Create additional presentation placeholder & request directories
    final widgetsDir =
        Directory(p.join(targetDir, 'lib/src/users/presentation/widget'));
    if (!widgetsDir.existsSync()) widgetsDir.createSync(recursive: true);
    final requestDir =
        Directory(p.join(targetDir, 'lib/src/users/model/request'));
    if (!requestDir.existsSync()) requestDir.createSync(recursive: true);

    // Add .gitkeep to assets directories so Git tracks them
    FileHelper.writeFile(p.join(targetDir, 'assets/images/.gitkeep'), '');
    FileHelper.writeFile(p.join(targetDir, 'assets/icons/.gitkeep'), '');

    // Clean up .iml and .idea configuration files to prevent IntelliJ/Android Studio from loading it as a Java/Android package project
    try {
      final imlFile = File(p.join(targetDir, '$appName.iml'));
      if (imlFile.existsSync()) {
        var imlContent = imlFile.readAsStringSync();
        imlContent = imlContent
            .replaceAll(
                '<sourceFolder url="file://\$MODULE_DIR\$/lib" isTestSource="false" />',
                '')
            .replaceAll(
                '<sourceFolder url="file://\$MODULE_DIR\$/test" isTestSource="true" />',
                '');
        imlFile.writeAsStringSync(imlContent);
      }

      final modulesXmlFile = File(p.join(targetDir, '.idea/modules.xml'));
      if (modulesXmlFile.existsSync()) {
        var modulesContent = modulesXmlFile.readAsStringSync();
        final lines = modulesContent.split('\n');
        lines.removeWhere((line) => line.contains('_android.iml'));
        modulesXmlFile.writeAsStringSync(lines.join('\n'));
      }

      final androidImlFile =
          File(p.join(targetDir, 'android/${appName}_android.iml'));
      if (androidImlFile.existsSync()) {
        androidImlFile.deleteSync();
      }
    } catch (e) {
      print('Warning: Failed to clean up IDE module files: $e');
    }

    // Configure FVM if active
    if (useFvm) {
      FvmHelper.configureFvmProject(targetDir, fvmVersion: fvmVersion);
    }

    print('Running "$runnerLabel pub get" in $targetDir...');
    final result = FvmHelper.runFlutter(
      ['pub', 'get'],
      useFvm: useFvm,
      workingDirectory: targetDir,
    );

    if (result.stdout != null && result.stdout.toString().trim().isNotEmpty) {
      print(result.stdout);
    }
    if (result.stderr != null && result.stderr.toString().trim().isNotEmpty) {
      print(result.stderr);
    }

    if (result.exitCode == 0) {
      print('"$runnerLabel pub get" completed successfully.');
    } else {
      print(
          'Warning: "$runnerLabel pub get" failed with exit code ${result.exitCode}.');
    }

    final formatRunnerLabel = useFvm ? 'fvm dart' : 'dart';
    print('Running "$formatRunnerLabel format ." in $targetDir...');
    final formatResult = FvmHelper.runDart(
      ['format', '.'],
      useFvm: useFvm,
      workingDirectory: targetDir,
    );

    if (formatResult.stdout != null &&
        formatResult.stdout.toString().trim().isNotEmpty) {
      print(formatResult.stdout);
    }
    if (formatResult.stderr != null &&
        formatResult.stderr.toString().trim().isNotEmpty) {
      print(formatResult.stderr);
    }

    if (formatResult.exitCode == 0) {
      print('"$formatRunnerLabel format" completed successfully.');
    } else {
      print(
          'Warning: "$formatRunnerLabel format" failed with exit code ${formatResult.exitCode}.');
    }

    print('Project structure successfully created inside: $appName');
  }
}
