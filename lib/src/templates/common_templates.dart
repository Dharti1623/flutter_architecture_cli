class CommonTemplates {
  // ==========================================
  // COMMON WIDGETS
  // ==========================================

  static String get appText => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/localization/app_localizations.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final Map<String, dynamic>? params;

  const AppText({
    super.key,
    required this.text,
    this.style,
    this.align,
    this.maxLines,
    this.overflow,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    String translatedText = AppLocalizations.of(context).translate(text);
    if (params != null) {
      params!.forEach((key, value) {
        translatedText = translatedText.replaceAll('{\$key}', value.toString());
      });
    }
    return Text(
      translatedText,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
''';

  static String get appImage => '''
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:{{package_name}}/common/widgets/app_loader.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholder: (context, url) => placeholder ?? const AppLoader(),
        errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
      );
    }

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) => errorWidget ?? const Icon(Icons.error),
    );
  }
}
''';

  static String get appTextField => '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.isPassword = false,
    this.prefix,
    this.suffix,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefix,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffix,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
''';

  static String get appButton => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/common/widgets/app_loader.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppLoader();
    }

    if (isOutline) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
''';

  static String get appContainer => '''
import 'package:flutter/material.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;

  const AppContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 8.0,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}
''';

  static String get appBackground => '''
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Gradient? gradient;

  const AppBackground({
    super.key,
    required this.child,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
''';

  static String get appLoader => '''
import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
''';

  static String get appEmptyState => '''
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final String message;

  const AppEmptyState({super.key, this.message = 'No data available'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
''';

  static String get appErrorWidget => '''
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.errorMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
''';

  static String get appDivider => '''
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  final double thickness;
  final Color? color;

  const AppDivider({super.key, this.thickness = 1.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      color: color ?? Colors.grey[300],
    );
  }
}
''';

  static String get appShimmer => '''
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
''';

  static String get appNetworkStatusWidget => '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/utils/connectivity_helper.dart';

class AppNetworkStatusWidget extends StatelessWidget {
  final Widget child;

  const AppNetworkStatusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectivityHelper().onConnectivityChanged,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        if (!isConnected) {
          return const Scaffold(
            body: Center(
              child: Text('No Internet Connection', style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          );
        }
        return child;
      },
    );
  }
}
''';

  static String get widgetsExport => '''
export 'app_text.dart';
export 'app_image.dart';
export 'app_text_field.dart';
export 'app_button.dart';
export 'app_container.dart';
export 'app_background.dart';
export 'app_loader.dart';
export 'app_empty_state.dart';
export 'app_error_widget.dart';
export 'app_divider.dart';
export 'app_shimmer.dart';
export 'app_network_status_widget.dart';
''';

  // ==========================================
  // HELPERS
  // ==========================================

  static String get helperDialog => '''
import 'package:flutter/material.dart';

class DialogHelper {
  static void show(BuildContext context, {required Widget child}) {
    showDialog(
      context: context,
      builder: (_) => child,
    );
  }
}
''';

  static String get helperBottomSheet => '''
import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void show(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => child,
    );
  }
}
''';

  static String get helperToast => '''
class ToastHelper {
  /// Show a toast notification with the given message.
  static void show(String message) {
  }
}
''';

  static String get helperSnackbar => '''
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
''';

  static String get helperNavigation => '''
import 'package:flutter/material.dart';

class NavigationHelper {
  static Future<T?> pushNamed<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }
}
''';

  static String get helperUrlLauncher => '''
class UrlLauncherHelper {
  /// Launches the given external URL.
  static Future<void> launch(String url) async {
  }
}
''';

  static String get helpersExport => '''
export 'dialog_helper.dart';
export 'bottom_sheet_helper.dart';
export 'toast_helper.dart';
export 'snackbar_helper.dart';
export 'navigation_helper.dart';
export 'url_launcher_helper.dart';
''';

  // ==========================================
  // EXTENSIONS
  // ==========================================

  static String get extString => '''
extension StringExtensions on String {
  bool get isValidEmail => RegExp(r'^\\w+([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*(\\.\\w{2,3})+\$').hasMatch(this);
}
''';

  static String get extDateTime => '''
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toFormattedString([String format = 'yyyy-MM-dd']) {
    return DateFormat(format).format(this);
  }
}
''';

  static String get extContext => '''
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
''';

  static String get extWidget => '''
import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget paddingAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);
}
''';

  static String get extIterable => '''
extension IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
''';

  static String get extensionsExport => '''
export 'string_extensions.dart';
export 'date_time_extensions.dart';
export 'context_extensions.dart';
export 'widget_extensions.dart';
export 'iterable_extensions.dart';
''';

  // ==========================================
  // UTILITIES
  // ==========================================

  static String get utilDateFormatter => '''
import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }
}
''';

  static String get utilValidators => '''
class Validators {
  static String? required(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }
}
''';

  static String get utilDebouncer => '''
import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
''';

  static String get utilLogger => '''
import 'dart:developer';

class Logger {
  static void info(String message) => log('INFO: \$message');
  static void error(String message) => log('ERROR: \$message');
}
''';

  static String get utilDeviceHelper => '''
class DeviceHelper {
  /// Device helper configurations.
}
''';

  static String get utilPermissionHelper => '''
class PermissionHelper {
  /// Request system level device permissions.
}
''';

  static String get utilConnectivityHelper => '''
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final ConnectivityHelper _instance = ConnectivityHelper._internal();
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  factory ConnectivityHelper() => _instance;

  ConnectivityHelper._internal() {
    _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      _controller.add(hasConnection);
    });
  }

  Stream<bool> get onConnectivityChanged => _controller.stream;

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }
}
''';

  static String get utilInternetChecker => '''
import 'dart:io';

class InternetChecker {
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
''';

  static String get utilFilePickerHelper => '''
class FilePickerHelper {
  /// File selection helper configurations.
}
''';

  static String get utilImagePickerHelper => '''
class ImagePickerHelper {
  /// Image selection helper configurations.
}
''';
}
