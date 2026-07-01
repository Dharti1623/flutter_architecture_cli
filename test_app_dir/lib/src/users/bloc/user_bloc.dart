import 'package:rxdart/rxdart.dart';
import 'package:test_app_dir/core/base/base_bloc.dart';
import 'package:test_app_dir/src/users/repository/user_repository.dart';
import 'package:test_app_dir/src/users/state/user_state.dart';

class UserBloc extends BaseBloc {
  final UserRepository _userRepository = UserRepository();
  final BehaviorSubject<GetUsersState> getUsersState =
      BehaviorSubject<GetUsersState>();

  void fetchUsers() {
    subscription.add(
      _userRepository
          .getUsers()
          .map((users) => GetUsersState.completed(users))
          .startWith(GetUsersState.loading())
          .onErrorReturnWith(
              (error, _) => GetUsersState.error(error.toString()))
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
