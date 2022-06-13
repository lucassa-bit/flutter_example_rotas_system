import 'dart:convert';

import 'package:cadastrorotas/models/login.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:http/http.dart' as http;

class loginService {
  var client = http.Client();
  static const urlBase = 'https://aedrotas.herokuapp.com';
  static const headers = {
    'Content-Type':'application/json',
  };

  Future<APIResponse<String>> login(Login login) async {
    var response = await client.post(
        Uri.parse(urlBase + '/login'),
        headers: headers,
        body: jsonEncode(login.toJson()));

    if (response.statusCode == 200) {
      return APIResponse<String>(data: response.body);
    }
    return APIResponse<String>(
        data: '', error: true, errorMessage: "");
  }
}