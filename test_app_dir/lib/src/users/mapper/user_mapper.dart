import 'package:test_app_dir/core/base/base_mapper.dart';
import 'package:test_app_dir/src/users/model/ui_entity/user_ui_entity.dart';
import 'package:test_app_dir/src/users/model/response/user_response.dart';

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
