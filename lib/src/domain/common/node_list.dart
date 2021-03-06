import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:yaml/yaml.dart';
import 'package:oxen_wallet/src/domain/common/node.dart';

Future<List<Node>> loadDefaultNodes() async {
  final nodesRaw = await rootBundle.loadString('assets/node_list.yml');
  final nodes = loadYaml(nodesRaw) as YamlList;

  return nodes.map((dynamic raw) {
    if (raw is Map) {
      return Node.fromMap(raw);
    }

    return null;
  }).toList();
}

Future resetToDefault(Box<Node> nodeSource) async {
  final nodes = await loadDefaultNodes();
  final entities = <int, Node>{};

  await nodeSource.clear();

  for (var i = 0; i < nodes.length; i++) {
    entities[i] = nodes[i];
  }

  await nodeSource.putAll(entities);
}
