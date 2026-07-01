import 'package:test_app_dir/core/network/api_client.dart';
import 'package:test_app_dir/core/constants/api_endpoints.dart';
import 'package:test_app_dir/src/users/model/response/user_response.dart';

class UserDataSource {
  final ApiClient _apiClient = ApiClient.instance;

  Stream<List<UserResponse>> getUsers() {
    return Stream.fromFuture(
      _apiClient.get(ApiEndpoints.users),
    ).map((response) {
      if (response.error != null) {
        throw Exception(response.error);
      }
      final list = response.data as List<dynamic>? ?? [];
      return list
          .map((item) => UserResponse.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
