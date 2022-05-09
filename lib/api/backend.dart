import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;

import '../data/blueprint.dart';

var _pathPrefix = "pfeditorData";
var _fileName = "pfeditor_json_data.json";

Future<List<String>> fecthProjects() async {
  var projects = List<String>.empty(growable: true);
  var result = await http
      .get(Uri.parse("https://api.github.com/users/dutchjavadev/repos"));

  var data = jsonDecode(result.body);

  for (var d in data) {
    projects.add("${d["full_name"].toString()} ${d["html_url"].toString()}");
  }

  return projects;
}

Future<Directory> getTemporaryDirectory() async {
  var documentsDir = await path.getApplicationDocumentsDirectory();
  var tempDir =
      Directory("${documentsDir.path}${Platform.pathSeparator}$_pathPrefix");
  if (!await tempDir.exists()) {
    return await tempDir.create(recursive: true);
  } else {
    return tempDir;
  }
}

void saveProject(Map<String, dynamic> projectblueprint) async {
  var tempDir = await getTemporaryDirectory();

  var file = File("${tempDir.path}${Platform.pathSeparator}$_fileName");

  if (await file.exists()) {
    var newEntry = projectblueprint;

    var list = jsonDecode(file.readAsStringSync()) as List<dynamic>;

    list.add(newEntry);

    file.writeAsStringSync(jsonEncode(list));
  } else {
    var newEntry = [projectblueprint];
    file = await file.create();
    file.writeAsStringSync(jsonEncode(newEntry));
  }
}

Future<String> loadProject() async {
  var tempDir = await getTemporaryDirectory();
  var file = File("${tempDir.path}/$_fileName");

  if (!await file.exists()) {
    file = await file.create();
    var list = [
      ProjectBlueprint("Sim", "Ba", "").toJson(),
      ProjectBlueprint("King", "Kong", "").toJson(),
      ProjectBlueprint("AG", "S", "").toJson(),
    ];

    file.writeAsStringSync(jsonEncode(list));
  }

  return file.readAsStringSync();
}

Future<bool> simulateLogin(String email, String password) async {
  await Future.delayed(const Duration(seconds: 1));
  return true;
}
