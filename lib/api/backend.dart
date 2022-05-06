import 'dart:convert';
import 'package:http/http.dart' as http;

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
