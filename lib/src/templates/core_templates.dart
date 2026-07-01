class CoreTemplates {
  // ==========================================
  // CONSTANTS LAYER
  // ==========================================

  static String get constantsExport => '''
export 'api_endpoints.dart';
export 'app_constants.dart';
export 'app_strings.dart';
export 'app_images.dart';
export 'app_icons.dart';
export 'app_fonts.dart';
export 'app_dimensions.dart';
export 'app_spacing.dart';
export 'app_radius.dart';
export 'app_durations.dart';
export 'app_regex.dart';
export 'app_keys.dart';
export 'shared_pref_keys.dart';
export 'hive_boxes.dart';
export 'network_constants.dart';
export 'api_headers.dart';
export 'asset_paths.dart';
export 'validation_messages.dart';
export 'error_messages.dart';
export 'route_names.dart';
export 'environment.dart';
''';

  static String get apiEndpoints => '''
class ApiEndpoints {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String users = '/users';
}
''';

  static String get appConstants => '''
class AppConstants {
  static const String appName = 'My App';
  static const String defaultLocale = 'en';
}
''';

  static String get appStrings => '''
class AppStrings {
  static const String appTitle = 'Flutter Architecture';
  static const String welcome = 'Welcome';
  static const String hello = 'Hello';
  static const String loading = 'Loading...';
  static const String error = 'An error occurred';
  static const String success = 'Success';
}
''';

  static String get appImages => '''
class AppImages {
  static const String placeholder = 'assets/images/placeholder.png';
}
''';

  static String get appIcons => '''
class AppIcons {
  static const String logo = 'assets/icons/logo.svg';
}
''';

  static String get appFonts => '''
class AppFonts {
  static const String primary = 'Roboto';
}
''';

  static String get appDimensions => '''
class AppDimensions {
  static const double pageMargin = 16.0;
  static const double cardPadding = 12.0;
}
''';

  static String get appSpacing => '''
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
''';

  static String get appRadius => '''
class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
}
''';

  static String get appDurations => '''
class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
}
''';

  static String get appRegex => '''
class AppRegex {
  static final RegExp email = RegExp(r'^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+\$');
  static final RegExp phone = RegExp(r'^\\+?[0-9]{10,12}\$');
}
''';

  static String get appKeys => '''
import 'package:flutter/material.dart';

class AppKeys {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}
''';

  static String get sharedPrefKeys => '''
class SharedPrefKeys {
  static const String token = 'token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userData = 'user_data';
  static const String languageCode = 'language_code';
  static const String themeMode = 'theme_mode';
  static const String isLoggedIn = 'is_logged_in';
  static const String onboardingCompleted = 'onboarding_completed';
}
''';

  static String get hiveBoxes => '''
class HiveBoxes {
  static const String cache = 'cache_box';
}
''';

  static String get networkConstants => '''
class NetworkConstants {
  static const int connectTimeout = 30000; // 30s
  static const int receiveTimeout = 30000;
}
''';

  static String get apiHeaders => '''
class ApiHeaders {
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accept = 'accept';
}
''';

  static String get assetPaths => '''
class AssetPaths {
  static const String images = 'assets/images/';
  static const String icons = 'assets/icons/';
  static const String translations = 'assets/translations/';
}
''';

  static String get validationMessages => '''
class ValidationMessages {
  static const String required = 'This field is required';
  static const String invalidEmail = 'Enter a valid email';
  static const String invalidPhone = 'Enter a valid phone number';
}
''';

  static String get errorMessages => '''
class ErrorMessages {
  static const String noInternet = 'No internet connection';
  static const String serverError = 'Something went wrong on the server';
  static const String unauthorized = 'Unauthorized access';
  static const String unexpected = 'An unexpected error occurred';
}
''';

  static String get routeNames => '''
class RouteNames {
  static const String initial = '/';
  static const String users = '/users';
}
''';

  static String get environment => '''
enum Environment { dev, staging, prod }

class EnvConfig {
  static Environment environment = Environment.dev;
}
''';

  // ==========================================
  // THEME LAYER
  // ==========================================

  static String get themeColors => '''
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}
''';

  static String get themeTextStyles => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );
}
''';

  static String get themeTheme => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/theme/app_colors.dart';
import 'package:{{package_name}}/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.h1,
        bodyLarge: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
''';

  static String get themeShadows => '''
import 'package:flutter/material.dart';

class AppShadows {
  static const BoxShadow card = BoxShadow(
    color: Colors.black12,
    blurRadius: 4.0,
    offset: Offset(0, 2),
  );
}
''';

  static String get themeBorders => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/theme/app_colors.dart';

class AppBorders {
  static final Border outline = Border.all(
    color: AppColors.textSecondary.withAlpha(76),
    width: 1.0,
  );
}
''';

  static String get themeExport => '''
export 'app_colors.dart';
export 'app_text_styles.dart';
export 'app_theme.dart';
export 'app_shadows.dart';
export 'app_borders.dart';
''';

  // ==========================================
  // STORAGE LAYER
  // ==========================================

  static String get storageExport => '''
export 'app_preferences.dart';
export 'secure_storage_service.dart';
export 'storage_service.dart';
export 'package:{{package_name}}/core/constants/shared_pref_keys.dart';
''';

  static String get storageService => '''
abstract class StorageService {
  Future<void> init();
  Future<void> clearAll();
}
''';

  static String get secureStorageService => '''
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  static final SecureStorageService _instance = SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }
}
''';

  static String get appPreferences => '''
import 'package:shared_preferences/shared_preferences.dart';
import 'package:{{package_name}}/core/constants/shared_pref_keys.dart';
import 'package:{{package_name}}/core/storage/storage_service.dart';

class AppPreferences implements StorageService {
  static final AppPreferences _instance = AppPreferences._internal();
  SharedPreferences? _prefs;

  factory AppPreferences() => _instance;

  AppPreferences._internal();

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Type-safe Getters & Setters for SharedPrefKeys

  Future<void> setToken(String value) async => await setString(SharedPrefKeys.token, value);
  String? get token => getString(SharedPrefKeys.token);

  Future<void> setRefreshToken(String value) async => await setString(SharedPrefKeys.refreshToken, value);
  String? get refreshToken => getString(SharedPrefKeys.refreshToken);

  Future<void> setUserId(String value) async => await setString(SharedPrefKeys.userId, value);
  String? get userId => getString(SharedPrefKeys.userId);

  Future<void> setUserData(String value) async => await setString(SharedPrefKeys.userData, value);
  String? get userData => getString(SharedPrefKeys.userData);

  Future<void> setLanguageCode(String value) async => await setString(SharedPrefKeys.languageCode, value);
  String? get languageCode => getString(SharedPrefKeys.languageCode);

  Future<void> setThemeMode(String value) async => await setString(SharedPrefKeys.themeMode, value);
  String? get themeMode => getString(SharedPrefKeys.themeMode);

  Future<void> setIsLoggedIn(bool value) async => await setBool(SharedPrefKeys.isLoggedIn, value);
  bool? get isLoggedIn => getBool(SharedPrefKeys.isLoggedIn);

  Future<void> setOnboardingCompleted(bool value) async => await setBool(SharedPrefKeys.onboardingCompleted, value);
  bool? get onboardingCompleted => getBool(SharedPrefKeys.onboardingCompleted);

  // Generic Operations

  Future<bool> setString(String key, String value) async => await _prefs!.setString(key, value);
  String? getString(String key) => _prefs?.getString(key);

  Future<bool> setBool(String key, bool value) async => await _prefs!.setBool(key, value);
  bool? getBool(String key) => _prefs?.getBool(key);

  Future<bool> setInt(String key, int value) async => await _prefs!.setInt(key, value);
  int? getInt(String key) => _prefs?.getInt(key);

  Future<bool> setDouble(String key, double value) async => await _prefs!.setDouble(key, value);
  double? getDouble(String key) => _prefs?.getDouble(key);

  Future<bool> remove(String key) async => await _prefs!.remove(key);

  @override
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
''';

  // ==========================================
  // BASE & STATE CLASSES
  // ==========================================

  static String get baseBloc => '''
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final subscription = CompositeSubscription();
  final hideKeyboardSubject = PublishSubject<bool>();

  void dispose() {
    subscription.clear();
    hideKeyboardSubject.close();
  }
}
''';

  static String get baseMapper => '''
abstract class BaseMapper<T, V> {
  V map(T t);
}
''';


  static String get baseUiState => '''
class BaseUiState<T> {
  dynamic error;
  T? data;
  UIState? _state;

  BaseUiState();

  BaseUiState.loading() : _state = UIState.loading;
  BaseUiState.completed({this.data}) : _state = UIState.completed;
  BaseUiState.error(this.error) : _state = UIState.error;

  bool isLoading() => _state == UIState.loading;
  bool isCompleted() => _state == UIState.completed;
  bool isError() => _state == null || _state == UIState.error;

  @override
  String toString() => 'State is \$_state';
}

enum UIState { loading, completed, error }
''';

  // ==========================================
  // NETWORK LAYER
  // ==========================================

  static String get apiResponse => '''
class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({this.data, this.error, this.statusCode});

  bool get isSuccess => error == null;
}
''';

  static String get apiException => '''
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message, {super.statusCode});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.statusCode});
}

class ValidationException extends ApiException {
  ValidationException(super.message, {super.statusCode});
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode});
}

class CacheException extends ApiException {
  CacheException(super.message, {super.statusCode});
}
''';

  static String get apiLogger => '''
import 'dart:developer';

class AppLogger {
  static void debug(String message) {
    log('DEBUG: \$message');
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    log('ERROR: \$message', error: error, stackTrace: stackTrace);
  }
}
''';

  static String get loggerInterceptor => '''
import 'package:dio/dio.dart';
import 'package:{{package_name}}/core/network/api_logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('REQUEST[\${options.method}] => PATH: \${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('RESPONSE[\${response.statusCode}] => PATH: \${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('ERROR[\${err.response?.statusCode}] => PATH: \${err.requestOptions.path}', error: err);
    super.onError(err, handler);
  }
}
''';

  static String get tokenInterceptor => '''
import 'package:dio/dio.dart';
import 'package:{{package_name}}/core/storage/secure_storage_service.dart';

class TokenInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageService().getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer \$token';
    }
    super.onRequest(options, handler);
  }
}
''';

  static String get errorInterceptor => '''
import 'package:dio/dio.dart';
import 'package:{{package_name}}/core/network/api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      throw UnauthorizedException('Unauthorized access', statusCode: 401);
    }
    super.onError(err, handler);
  }
}
''';

  static String get apiClient => '''
import 'package:dio/dio.dart';
import 'package:{{package_name}}/core/constants/api_endpoints.dart';
import 'package:{{package_name}}/core/constants/network_constants.dart';
import 'package:{{package_name}}/core/network/api_exceptions.dart';
import 'package:{{package_name}}/core/network/logger_interceptor.dart';
import 'package:{{package_name}}/core/network/token_interceptor.dart';
import 'package:{{package_name}}/core/network/error_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() => _instance;

  static ApiClient get instance => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: NetworkConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: NetworkConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    _dio.interceptors.addAll([
      TokenInterceptor(),
      LoggerInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<dynamic> _request(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data;
      } else {
        throw ApiException(
          'Received invalid status code: \${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      String errorMsg = e.toString();
      int? statusCode;
      if (e is DioException) {
        errorMsg = e.response?.data?['message'] ?? e.message ?? e.toString();
        statusCode = e.response?.statusCode;
      }
      throw ApiException(errorMsg, statusCode: statusCode);
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _request(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _request(
      path,
      method: 'POST',
      data: data,
      options: options,
    );
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _request(
      path,
      method: 'PUT',
      data: data,
      options: options,
    );
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _request(
      path,
      method: 'PATCH',
      data: data,
      options: options,
    );
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _request(
      path,
      method: 'DELETE',
      data: data,
      options: options,
    );
  }
}
''';

  // ==========================================
  // ROUTING LAYER
  // ==========================================

  static String get appRouter => '''
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for \${settings.name}'),
            ),
          ),
        );
    }
  }
}
''';

  // ==========================================
  // LOCALIZATION LAYER
  // ==========================================

  static String get appLocalizations => '''
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String>? _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'assets/translations/intl_\${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
''';

  static String get localizationService => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/storage/app_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LocalizationService() {
    _loadLocale();
  }

  void _loadLocale() {
    final String? languageCode = AppPreferences().getString(_localeKey);
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale.languageCode == locale.languageCode) return;
    _currentLocale = locale;
    notifyListeners();
    await AppPreferences().setString(_localeKey, locale.languageCode);
  }

  List<Locale> get supportedLocales => const [
        Locale('en'),
      ];
}
''';

  // ==========================================
  // DEPENDENCY INJECTION LAYER
  // ==========================================

  static String get di => '''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:{{package_name}}/core/storage/app_preferences.dart';
import 'package:{{package_name}}/core/localization/localization_service.dart';

class DependencyInjection {
  static List<SingleChildWidget> providers = [
    Provider<AppPreferences>(
      create: (_) => AppPreferences(),
    ),
    ChangeNotifierProvider<LocalizationService>(
      create: (_) => LocalizationService(),
    ),
  ];
}
''';
}
