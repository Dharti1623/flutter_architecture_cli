import 'package:test/test.dart';
import 'package:flutter_architecture_cli/src/utils/string_utils.dart';
import 'package:flutter_architecture_cli/src/utils/file_helper.dart';
import 'package:flutter_architecture_cli/src/templates/pubspec_template.dart';
import 'package:flutter_architecture_cli/src/templates/bloc_templates.dart';

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

  group('FileHelper Tests', () {
    test('findProjectRoot and getPackageName find current workspace pubspec',
        () {
      final root = FileHelper.findProjectRoot();
      expect(root, isNotEmpty);
      final pkgName = FileHelper.getPackageName(root);
      expect(pkgName, equals('flutter_architecture_cli'));
    });
  });

  group('BLoC Templates Tests', () {
    test('PubspecTemplate includes flutter_bloc and rxdart when isBloc is true', () {
      final pubspec = PubspecTemplate.buildPubspec('demo_app', isBloc: true);
      expect(pubspec.contains('flutter_bloc:'), isTrue);
      expect(pubspec.contains('rxdart:'), isTrue);
    });

    test('PubspecTemplate includes rxdart when isBloc is false', () {
      final pubspec = PubspecTemplate.buildPubspec('demo_app', isBloc: false);
      expect(pubspec.contains('rxdart:'), isTrue);
      expect(pubspec.contains('flutter_bloc:'), isFalse);
    });

    test('BlocTemplates generate valid code structure', () {
      final eventCode = BlocTemplates.featureEvent('Product');
      expect(eventCode.contains('abstract class ProductEvent'), isTrue);
      expect(eventCode.contains('FetchProductEvent'), isTrue);

      final stateCode =
          BlocTemplates.featureState('Product', 'products', 'demo_app');
      expect(stateCode.contains('ProductLoadingState'), isTrue);
      expect(stateCode.contains('ProductLoadedState'), isTrue);

      final blocCode =
          BlocTemplates.featureBloc('Product', 'products', 'demo_app');
      expect(blocCode.contains('class ProductBloc extends Bloc'), isTrue);
    });
  });
}
