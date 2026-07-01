import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:test_app_dir/src/users/bloc/user_bloc.dart';

class UserProvider {
  static List<SingleChildWidget> providers = [
    Provider<UserBloc>(
      create: (_) => UserBloc()..fetchUsers(),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];
}
