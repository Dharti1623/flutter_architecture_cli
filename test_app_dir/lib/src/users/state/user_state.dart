import 'package:test_app_dir/core/base/base_ui_state.dart';
import 'package:test_app_dir/src/users/model/ui_entity/user_ui_entity.dart';

class GetUsersState extends BaseUiState<List<UserUiEntity>> {
  GetUsersState() : super();

  GetUsersState.loading() : super.loading();

  GetUsersState.completed(List<UserUiEntity> users)
      : super.completed(data: users);

  GetUsersState.error(super.error) : super.error();
}
