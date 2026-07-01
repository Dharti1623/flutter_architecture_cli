import 'package:test/test.dart';
import 'package:clean_architecture_generator/src/utils/string_utils.dart';

void main() {
  group('StringUtils Tests', () {
    test('toPascalCase works correctly', () {
      expect(StringUtils.toPascalCase('user_profile'), equals('UserProfile'));
      expect(StringUtils.toPascalCase('user-profile'), equals('UserProfile'));
      expect(StringUtils.toPascalCase('userProfile'), equals('UserProfile'));
    });

    test('toCamelCase works correctly', () {
      expect(StringUtils.toCamelCase('user_profile'), equals('userProfile'));
      expect(StringUtils.toCamelCase('UserProfile'), equals('userProfile'));
    });

    test('toSnakeCase works correctly', () {
      expect(StringUtils.toSnakeCase('UserProfile'), equals('user_profile'));
      expect(StringUtils.toSnakeCase('user-profile'), equals('user_profile'));
    });

    test('toKebabCase works correctly', () {
      expect(StringUtils.toKebabCase('UserProfile'), equals('user-profile'));
      expect(StringUtils.toKebabCase('user_profile'), equals('user-profile'));
    });
  });
}
