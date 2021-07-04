import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'user.dart';


//final Uri apiServer = Uri.base;
final Uri apiServer = Uri.parse('http://localhost:5000');

// send the HTTP post with JSON format
var http_post = (String path, Map<String, dynamic> data) async => post(
  apiServer.replace(path: path),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(data),
);

var http_get_auth = (String path) async => get(
  apiServer.replace(path: path),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorizer': get_session(),
  },
);

var api_me = () => http_get_auth('/api/me');

Future<String> api_username() async {
  final resp = await api_me();

  switch (resp.statusCode) {
    case 200:
      Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));
      return data['username'] ?? '';
    default:
      return '';
  }
}

// vim: set ts=2 sw=2 expandtab:
