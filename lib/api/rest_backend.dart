import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pfeditor/data/blueprint.dart';

var _collectionId = "pfeditorCollection00";
var _baseUrl = 'http://localhost:64790/api';
var _login = '$_baseUrl/login';
var _register = '$_baseUrl/register';
var _postUrl = '$_baseUrl/post/json/$_collectionId';
var _getUrl = '$_baseUrl/get/json/groupId/$_collectionId';
var _jwt = '';
var _cache = [];

class RestApi {
  static final RestApi _singleton = RestApi();

  factory RestApi() {
    return _singleton;
  }

  Future<RestDTO> loginAsync(String username, String password) async {
    // Form validator???
    var headers = {
      'body': jsonEncode({username: username, password: password})
    };

    var result = await _getRequest(_login, headers: headers);

    if (result.statusCode != 200) {
      return RestDTO(success: false, message: result.body);
    }

    var data = jsonDecode(result.body);

    _jwt = data.token;

    return RestDTO(message: 'Authenticated!');
  }

  Future<RestDTO> loadProjectsAsync() async {
    if (_cache.isNotEmpty) return RestDTO(data: {'cache': _cache});

    var result = await _postRequest(_getUrl);

    if (result.statusCode != 200) {
      return RestDTO(success: false, message: result.body);
    }

    return RestDTO(data: {'cache': _cache});
  }

  Future<RestDTO> saveProjectAsync(Map<String, dynamic> project) async {
    var result = await _postRequest(_postUrl, body: project);

    if (result.statusCode != 200) {
      return RestDTO(success: false, message: result.body);
    }

    _cache = [];

    return RestDTO(message: 'Project saved!');
  }

  Future<Response> _getRequest(String url,
          {Map<String, String>? headers}) async =>
      await http.get(Uri.parse(url), headers: headers ?? {});

  Future<Response> _postRequest(String url,
      {dynamic? body, Map<String, String>? headers}) async {
    return await http.post(Uri.parse(url), body: body ?? "", headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_jwt"
    });
  }
}

class RestDTO {
  RestDTO({this.success = true, this.message = '', this.data});
  final bool success;
  final String message;
  Map<String, dynamic>? data;
}
