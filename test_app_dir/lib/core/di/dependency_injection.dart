import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:test_app_dir/core/storage/app_preferences.dart';
import 'package:test_app_dir/core/localization/localization_service.dart';

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
