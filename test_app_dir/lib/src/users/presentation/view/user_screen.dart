import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app_dir/common/widgets/app_text.dart';
import 'package:test_app_dir/common/widgets/app_loader.dart';
import 'package:test_app_dir/common/widgets/app_error_widget.dart';
import 'package:test_app_dir/src/users/bloc/user_bloc.dart';
import 'package:test_app_dir/src/users/state/user_state.dart';

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
