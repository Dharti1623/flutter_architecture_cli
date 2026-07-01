class FeatureTemplates {
  // ==========================================
  // MODEL & RESPONSE (DTO)
  // ==========================================

  static String get userModel => '''
class UserUiEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  UserUiEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
  });
}
''';

  static String get userDto => '''
class UserResponse {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? website;

  UserResponse({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.website,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    website = json['website'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['website'] = website;
    return data;
  }
}
''';

  // ==========================================
  // MAPPER
  // ==========================================

  static String get userMapper => '''
import 'package:{{package_name}}/core/base/base_mapper.dart';
import 'package:{{package_name}}/src/users/model/ui_entity/user_ui_entity.dart';
import 'package:{{package_name}}/src/users/model/response/user_response.dart';

class UserResponseToUiEntity extends BaseMapper<UserResponse, UserUiEntity> {
  @override
  UserUiEntity map(UserResponse t) {
    return UserUiEntity(
      id: t.id ?? 0,
      name: t.name ?? '',
      email: t.email ?? '',
      phone: t.phone ?? '',
      website: t.website ?? '',
    );
  }

  List<UserUiEntity> mapList(List<UserResponse>? list) {
    return list?.map(map).toList() ?? [];
  }
}
''';

  // ==========================================
  // DATA SOURCE
  // ==========================================

  static String get userDataSource => '''
import 'package:{{package_name}}/core/network/api_client.dart';
import 'package:{{package_name}}/core/constants/api_endpoints.dart';
import 'package:{{package_name}}/src/users/model/response/user_response.dart';

class UserDataSource {
  final ApiClient _apiClient = ApiClient.instance;

  Stream<List<UserResponse>> getUsers() {
    return Stream.fromFuture(
      _apiClient.get(ApiEndpoints.users),
    ).map((response) {
      final list = response as List<dynamic>? ?? [];
      return list.map((item) => UserResponse.fromJson(item as Map<String, dynamic>)).toList();
    });
  }
}
''';

  // ==========================================
  // REPOSITORY
  // ==========================================

  static String get userRepository => '''
import 'package:{{package_name}}/src/users/data_source/user_datasource.dart';
import 'package:{{package_name}}/src/users/mapper/user_mapper.dart';
import 'package:{{package_name}}/src/users/model/ui_entity/user_ui_entity.dart';

class UserRepository {
  final UserDataSource _userDataSource = UserDataSource();

  Stream<List<UserUiEntity>> getUsers() {
    return _userDataSource.getUsers().map((dtos) => UserResponseToUiEntity().mapList(dtos));
  }
}
''';

  // ==========================================
  // STATE CLASS
  // ==========================================

  static String get userState => '''
import 'package:{{package_name}}/core/base/base_ui_state.dart';
import 'package:{{package_name}}/src/users/model/ui_entity/user_ui_entity.dart';

class GetUsersState extends BaseUiState<List<UserUiEntity>> {
  GetUsersState() : super();

  GetUsersState.loading() : super.loading();

  GetUsersState.completed(List<UserUiEntity> users) : super.completed(data: users);

  GetUsersState.error(super.error) : super.error();
}
''';

  // ==========================================
  // BLOC / CONTROLLER
  // ==========================================

  static String get userController => '''
import 'package:rxdart/rxdart.dart';
import 'package:{{package_name}}/core/base/base_bloc.dart';
import 'package:{{package_name}}/src/users/repository/user_repository.dart';
import 'package:{{package_name}}/src/users/state/user_state.dart';

class UserBloc extends BaseBloc {
  final UserRepository _userRepository = UserRepository();
  final BehaviorSubject<GetUsersState> getUsersState = BehaviorSubject<GetUsersState>();

  void fetchUsers() {
    subscription.add(
      _userRepository.getUsers()
          .map((users) => GetUsersState.completed(users))
          .startWith(GetUsersState.loading())
          .onErrorReturnWith((error, _) => GetUsersState.error(error.toString()))
          .listen((state) {
            if (!getUsersState.isClosed) {
              getUsersState.add(state);
            }
          }),
    );
  }

  @override
  void dispose() {
    getUsersState.close();
    super.dispose();
  }
}
''';

  // ==========================================
  // PROVIDER / DI WIRE-UP
  // ==========================================

  static String get userProvider => '''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:{{package_name}}/src/users/bloc/user_bloc.dart';

class UserProvider {
  static List<SingleChildWidget> providers = [
    Provider<UserBloc>(
      create: (_) => UserBloc()..fetchUsers(),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];
}
''';

  // ==========================================
  // SCREEN (VIEW)
  // ==========================================

  static String get userScreen => '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:{{package_name}}/common/widgets/app_text.dart';
import 'package:{{package_name}}/common/widgets/app_loader.dart';
import 'package:{{package_name}}/common/widgets/app_error_widget.dart';
import 'package:{{package_name}}/src/users/bloc/user_bloc.dart';
import 'package:{{package_name}}/src/users/state/user_state.dart';

class UserScreen extends StatelessWidget {
  static const String routeName = '/users';

  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UserBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Users List'),
      ),
      body: StreamBuilder<GetUsersState>(
        stream: bloc.getUsersState.stream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          
          if (state == null || state.isLoading()) {
            return const AppLoader();
          }

          if (state.isError()) {
            return AppErrorWidget(
              errorMessage: state.error?.toString() ?? 'Failed to load users',
              onRetry: () => bloc.fetchUsers(),
            );
          }

          final users = state.data ?? [];
          if (users.isEmpty) {
            return const Center(child: AppText(text: 'No users found'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.name.substring(0, 1)),
                ),
                title: AppText(text: user.name),
                subtitle: AppText(text: user.email),
                trailing: Text(user.phone),
              );
            },
          );
        },
      ),
    );
  }
}
''';
}
