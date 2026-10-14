class BlocTemplates {
  // ==========================================
  // BLOC DUMMY USER FEATURE
  // ==========================================

  static String get userEvent => '''
abstract class UserEvent {}

class FetchUsersEvent extends UserEvent {}

class RefreshUsersEvent extends UserEvent {}
''';

  static String get userState => '''
import 'package:{{package_name}}/src/users/model/ui_entity/user_ui_entity.dart';

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final List<UserUiEntity> users;
  UserLoadedState(this.users);
}

class UserErrorState extends UserState {
  final String message;
  UserErrorState(this.message);
}
''';

  static String get userBloc => '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{package_name}}/src/users/bloc/user_event.dart';
import 'package:{{package_name}}/src/users/bloc/user_state.dart';
import 'package:{{package_name}}/src/users/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc({UserRepository? repository})
      : _userRepository = repository ?? UserRepository(),
        super(UserInitialState()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future<void> _onFetchUsers(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());
    try {
      final users = await _userRepository.getUsersList();
      emit(UserLoadedState(users));
    } catch (error) {
      emit(UserErrorState(error.toString()));
    }
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      final users = await _userRepository.getUsersList();
      emit(UserLoadedState(users));
    } catch (error) {
      emit(UserErrorState(error.toString()));
    }
  }
}
''';

  static String get userRepository => '''
import 'package:{{package_name}}/src/users/data_source/user_datasource.dart';
import 'package:{{package_name}}/src/users/mapper/user_mapper.dart';
import 'package:{{package_name}}/src/users/model/ui_entity/user_ui_entity.dart';

class UserRepository {
  final UserDataSource _dataSource = UserDataSource();
  final UserResponseToUiEntity _mapper = UserResponseToUiEntity();

  /// Asynchronous fetch for BLoC
  Future<List<UserUiEntity>> getUsersList() async {
    final responseList = await _dataSource.getUsers().first;
    return _mapper.mapList(responseList);
  }

  /// Reactive stream fetch
  Stream<List<UserUiEntity>> getUsers() {
    return _dataSource.getUsers().map((responseList) {
      return _mapper.mapList(responseList);
    });
  }
}
''';

  static String get userScreen => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{package_name}}/common/widgets/app_text.dart';
import 'package:{{package_name}}/common/widgets/app_loader.dart';
import 'package:{{package_name}}/common/widgets/app_error_widget.dart';
import 'package:{{package_name}}/src/users/bloc/user_bloc.dart';
import 'package:{{package_name}}/src/users/bloc/user_event.dart';
import 'package:{{package_name}}/src/users/bloc/user_state.dart';

class UserScreen extends StatelessWidget {
  static const String routeName = '/users';

  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc()..add(FetchUsersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const AppText(text: 'Users List'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const AppLoader();
            }

            if (state is UserErrorState) {
              return AppErrorWidget(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<UserBloc>().add(FetchUsersEvent()),
              );
            }

            if (state is UserLoadedState) {
              final users = state.users;
              if (users.isEmpty) {
                return const Center(child: AppText(text: 'No users found'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: AppText(text: user.name),
                    subtitle: AppText(text: user.email),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
''';

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
      home: const UserScreen(),
    );
  }
}
''';

  // ==========================================
  // BLOC FEATURE GENERATOR TEMPLATES
  // ==========================================

  static String featureEvent(String className) => '''
abstract class ${className}Event {}

class Fetch${className}Event extends ${className}Event {}

class Refresh${className}Event extends ${className}Event {}
''';

  static String featureState(
          String className, String featureName, String packageName) =>
      '''
import 'package:$packageName/src/$featureName/model/ui_entity/${featureName}_ui_entity.dart';

abstract class ${className}State {}

class ${className}InitialState extends ${className}State {}

class ${className}LoadingState extends ${className}State {}

class ${className}LoadedState extends ${className}State {
  final List<${className}UiEntity> data;
  ${className}LoadedState(this.data);
}

class ${className}ErrorState extends ${className}State {
  final String message;
  ${className}ErrorState(this.message);
}
''';

  static String featureBloc(
          String className, String featureName, String packageName) =>
      '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/src/$featureName/bloc/${featureName}_event.dart';
import 'package:$packageName/src/$featureName/bloc/${featureName}_state.dart';
import 'package:$packageName/src/$featureName/repository/${featureName}_repository.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  final ${className}Repository _repository;

  ${className}Bloc({${className}Repository? repository})
      : _repository = repository ?? ${className}Repository(),
        super(${className}InitialState()) {
    on<Fetch${className}Event>(_onFetchData);
    on<Refresh${className}Event>(_onRefreshData);
  }

  Future<void> _onFetchData(
    Fetch${className}Event event,
    Emitter<${className}State> emit,
  ) async {
    emit(${className}LoadingState());
    try {
      final list = await _repository.getData();
      emit(${className}LoadedState(list));
    } catch (error) {
      emit(${className}ErrorState(error.toString()));
    }
  }

  Future<void> _onRefreshData(
    Refresh${className}Event event,
    Emitter<${className}State> emit,
  ) async {
    try {
      final list = await _repository.getData();
      emit(${className}LoadedState(list));
    } catch (error) {
      emit(${className}ErrorState(error.toString()));
    }
  }
}
''';

  static String featureRepository(
          String className, String featureName, String packageName,
          {String? dataSourceFile, String? dataSourceClass}) =>
      '''
import 'package:$packageName/src/$featureName/model/ui_entity/${featureName}_ui_entity.dart';
${dataSourceFile != null ? "import 'package:$packageName/src/$featureName/data_source/$dataSourceFile';\n" : ""}
class ${className}Repository {
  ${dataSourceClass != null ? "// ignore: unused_field\n  final $dataSourceClass _dataSource = $dataSourceClass();\n" : ""}
  Future<List<${className}UiEntity>> getData() async {
    // Add data fetching logic from dataSource
    return [];
  }
}
''';

  static String featureScreen(
          String className, String featureName, String packageName) =>
      '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/common/widgets/app_text.dart';
import 'package:$packageName/common/widgets/app_loader.dart';
import 'package:$packageName/common/widgets/app_error_widget.dart';
import 'package:$packageName/src/$featureName/bloc/${featureName}_bloc.dart';
import 'package:$packageName/src/$featureName/bloc/${featureName}_event.dart';
import 'package:$packageName/src/$featureName/bloc/${featureName}_state.dart';

class ${className}Screen extends StatelessWidget {
  static const String routeName = '/$featureName';

  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ${className}Bloc()..add(Fetch${className}Event()),
      child: Scaffold(
        appBar: AppBar(
          title: const AppText(text: '$className List'),
        ),
        body: BlocBuilder<${className}Bloc, ${className}State>(
          builder: (context, state) {
            if (state is ${className}LoadingState) {
              return const AppLoader();
            }

            if (state is ${className}ErrorState) {
              return AppErrorWidget(
                errorMessage: state.message,
                onRetry: () =>
                    context.read<${className}Bloc>().add(Fetch${className}Event()),
              );
            }

            if (state is ${className}LoadedState) {
              final list = state.data;
              if (list.isEmpty) {
                return const Center(child: AppText(text: 'No data found'));
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return ListTile(
                    title: AppText(text: item.name),
                    subtitle: AppText(text: 'ID: \${item.id}'),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
''';
}
