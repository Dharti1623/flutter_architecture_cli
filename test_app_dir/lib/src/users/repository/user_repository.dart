import 'package:test_app_dir/src/users/data_source/user_datasource.dart';
import 'package:test_app_dir/src/users/mapper/user_mapper.dart';
import 'package:test_app_dir/src/users/model/ui_entity/user_ui_entity.dart';

class UserRepository {
  final UserDataSource _userDataSource = UserDataSource();

  Stream<List<UserUiEntity>> getUsers() {
    return _userDataSource
        .getUsers()
        .map((dtos) => UserResponseToUiEntity().mapList(dtos));
  }
}
