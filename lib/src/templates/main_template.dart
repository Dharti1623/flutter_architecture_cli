class MainTemplate {
  static String get mainDart => '''
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:{{package_name}}/core/di/dependency_injection.dart';
import 'package:{{package_name}}/core/localization/app_localizations.dart';
import 'package:{{package_name}}/core/localization/localization_service.dart';
import 'package:{{package_name}}/core/storage/app_preferences.dart';
import 'package:{{package_name}}/core/theme/app_theme.dart';
import 'package:{{package_name}}/src/users/presentation/view/user_screen.dart';
import 'package:{{package_name}}/src/users/state/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences wrapper
  await AppPreferences().init();
  
  runApp(
    MultiProvider(
      providers: DependencyInjection.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return MaterialApp(
      title: 'Generated App',
      theme: AppTheme.lightTheme,
      locale: localizationService.currentLocale,
      supportedLocales: localizationService.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Wrap UserScreen in its feature providers
      home: MultiProvider(
        providers: UserProvider.providers,
        child: const UserScreen(),
      ),
    );
  }
}
''';
}
