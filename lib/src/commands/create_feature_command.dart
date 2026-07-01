import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';

class CreateFeatureCommand extends Command {
  @override
  final String name = 'create_feature';

  @override
  final String description = 'Generates a complete new Clean Architecture feature (data + presentation layers) in the current project.';

  CreateFeatureCommand();

  String _getPackageName() {
    final file = File(p.join(Directory.current.path, 'pubspec.yaml'));
    if (!file.existsSync()) return 'app';
    final lines = file.readAsLinesSync();
    for (final line in lines) {
      if (line.trim().startsWith('name:')) {
        return line.split('name:').last.trim();
      }
    }
    return 'app';
  }

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print('Error: Please specify the feature name. Usage: clean_architecture_generator create_feature <feature_name>');
      return;
    }

    final featureName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final packageName = _getPackageName();

    print('Generating feature "$featureName" in feature-first Clean Architecture layout...');

    void write(String path, String content) {
      final replaced = content.replaceAll('{{package_name}}', packageName);
      FileHelper.writeFile(path, replaced);
    }

    final featureDir = p.join(Directory.current.path, 'lib/src', featureName);

    // 1. Model & DTO
    final uiEntityPath = p.join(featureDir, 'model', 'ui_entity', '${featureName}_ui_entity.dart');
    write(uiEntityPath, '''
class ${className}UiEntity {
  final int id;
  final String name;

  ${className}UiEntity({
    required this.id,
    required this.name,
  });
}
''');

    final responsePath = p.join(featureDir, 'model', 'response', '${featureName}_response.dart');
    write(responsePath, '''
class ${className}Response {
  int? id;
  String? name;

  ${className}Response({
    this.id,
    this.name,
  });

  ${className}Response.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
''');

    // Create request placeholder directory
    final requestDir = Directory(p.join(featureDir, 'model', 'request'));
    if (!requestDir.existsSync()) {
      requestDir.createSync(recursive: true);
    }

    // 2. Mapper
    final mapperPath = p.join(featureDir, 'mapper', '${featureName}_mapper.dart');
    write(mapperPath, '''
import 'package:{{package_name}}/core/base/base_mapper.dart';
import 'package:{{package_name}}/src/$featureName/model/ui_entity/${featureName}_ui_entity.dart';
import 'package:{{package_name}}/src/$featureName/model/response/${featureName}_response.dart';

class ${className}ResponseToUiEntity extends BaseMapper<${className}Response, ${className}UiEntity> {
  @override
  ${className}UiEntity map(${className}Response t) {
    return ${className}UiEntity(
      id: t.id ?? 0,
      name: t.name ?? '',
    );
  }

  List<${className}UiEntity> mapList(List<${className}Response>? list) {
    return list?.map(map).toList() ?? [];
  }
}
''');

    // 3. DataSource
    final dataSourcePath = p.join(featureDir, 'data_source', '${featureName}_datasource.dart');
    write(dataSourcePath, '''
import 'package:{{package_name}}/core/network/api_client.dart';
import 'package:{{package_name}}/src/$featureName/model/response/${featureName}_response.dart';

class ${className}DataSource {
  final ApiClient _apiClient = ApiClient.instance;

  Stream<List<${className}Response>> getData() {
    return Stream.fromFuture(
      _apiClient.get('/$featureName'),
    ).map((response) {
      final list = response as List<dynamic>? ?? [];
      return list.map((item) => ${className}Response.fromJson(item as Map<String, dynamic>)).toList();
    });
  }
}
''');

    // 4. Repository
    final repositoryPath = p.join(featureDir, 'repository', '${featureName}_repository.dart');
    write(repositoryPath, '''
import 'package:{{package_name}}/src/$featureName/data_source/${featureName}_datasource.dart';
import 'package:{{package_name}}/src/$featureName/mapper/${featureName}_mapper.dart';
import 'package:{{package_name}}/src/$featureName/model/ui_entity/${featureName}_ui_entity.dart';

class ${className}Repository {
  final ${className}DataSource _dataSource = ${className}DataSource();

  Stream<List<${className}UiEntity>> getData() {
    return _dataSource.getData().map((dtos) => ${className}ResponseToUiEntity().mapList(dtos));
  }
}
''');

    // 5. State Class
    final statePath = p.join(featureDir, 'state', '${featureName}_state.dart');
    write(statePath, '''
import 'package:{{package_name}}/core/base/base_ui_state.dart';
import 'package:{{package_name}}/src/$featureName/model/ui_entity/${featureName}_ui_entity.dart';

class Get${className}State extends BaseUiState<List<${className}UiEntity>> {
  Get${className}State() : super();

  Get${className}State.loading() : super.loading();

  Get${className}State.completed(List<${className}UiEntity> data) : super.completed(data: data);

  Get${className}State.error(super.error) : super.error();
}
''');

    // 6. Bloc
    final blocPath = p.join(featureDir, 'bloc', '${featureName}_bloc.dart');
    write(blocPath, '''
import 'package:rxdart/rxdart.dart';
import 'package:{{package_name}}/core/base/base_bloc.dart';
import 'package:{{package_name}}/src/$featureName/repository/${featureName}_repository.dart';
import 'package:{{package_name}}/src/$featureName/state/${featureName}_state.dart';

class ${className}Bloc extends BaseBloc {
  final ${className}Repository _repository = ${className}Repository();
  final BehaviorSubject<Get${className}State> stateSubject = BehaviorSubject<Get${className}State>();

  void fetchData() {
    subscription.add(
      _repository.getData()
          .map((data) => Get${className}State.completed(data))
          .startWith(Get${className}State.loading())
          .onErrorReturnWith((error, _) => Get${className}State.error(error.toString()))
          .listen((state) {
            if (!stateSubject.isClosed) {
              stateSubject.add(state);
            }
          }),
    );
  }

  @override
  void dispose() {
    stateSubject.close();
    super.dispose();
  }
}
''');

    // 7. Provider
    final providerPath = p.join(featureDir, 'state', '${featureName}_provider.dart');
    write(providerPath, '''
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:{{package_name}}/src/$featureName/bloc/${featureName}_bloc.dart';

class ${className}Provider {
  static List<SingleChildWidget> providers = [
    Provider<${className}Bloc>(
      create: (_) => ${className}Bloc()..fetchData(),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];
}
''');

    // 8. Screen View
    final screenPath = p.join(featureDir, 'presentation', 'view', '${featureName}_screen.dart');
    write(screenPath, '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:{{package_name}}/common/widgets/app_text.dart';
import 'package:{{package_name}}/common/widgets/app_loader.dart';
import 'package:{{package_name}}/common/widgets/app_error_widget.dart';
import 'package:{{package_name}}/src/$featureName/bloc/${featureName}_bloc.dart';
import 'package:{{package_name}}/src/$featureName/state/${featureName}_state.dart';

class ${className}Screen extends StatelessWidget {
  static const String routeName = '/$featureName';

  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<${className}Bloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: '$className List'),
      ),
      body: StreamBuilder<Get${className}State>(
        stream: bloc.stateSubject.stream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          
          if (state == null || state.isLoading()) {
            return const AppLoader();
          }

          if (state.isError()) {
            return AppErrorWidget(
              errorMessage: state.error?.toString() ?? 'Failed to load data',
              onRetry: () => bloc.fetchData(),
            );
          }

          final list = state.data ?? [];
          if (list.isEmpty) {
            return const Center(child: AppText(text: 'No data found'));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return ListTile(
                title: AppText(text: item.name),
                subtitle: AppText(text: 'ID: \${item.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
''');

    // Create presentation/widget directory
    final widgetDir = Directory(p.join(featureDir, 'presentation', 'widget'));
    if (!widgetDir.existsSync()) {
      widgetDir.createSync(recursive: true);
    }

    print('Feature "$featureName" generated successfully in feature-first layout.');
  }
}
