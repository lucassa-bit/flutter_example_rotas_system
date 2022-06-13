import 'dart:convert';

import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class usuariosService {
  var client = http.Client();

  Future<APIResponse<List<Usuario>>> getUsuarioList(String token) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/usuario'),
        headers: {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final usuarios = <Usuario>[];

      for (var item in jsonData) {
        usuarios.add(Usuario.fromJson(item));
      }
      return APIResponse<List<Usuario>>(data: usuarios);
    }
    return APIResponse<List<Usuario>>(
        data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<List<Usuario>>> getResponsaveisList(String token) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/usuario/responsaveis'),
        headers: {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final usuarios = <Usuario>[];

      for (var item in jsonData) {
        usuarios.add(Usuario.fromJson(item));
      }
      return APIResponse<List<Usuario>>(data: usuarios);
    }
    return APIResponse<List<Usuario>>(
        data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<Usuario>> getUsuarioLogado(String token) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/usuario/me'),
        headers: {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return APIResponse<Usuario>(data: Usuario.fromJson(jsonData));
    }
    return APIResponse<Usuario>(data: Usuario(), error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> newUsuario(Usuario usuario, String token) async {
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/usuario/registrar'),
        headers: {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token},
        body: jsonEncode(usuario.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(
        data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> updateUsuario(Usuario usuario, String token) async {
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/usuario/edit'),
        headers: {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token},
        body: jsonEncode(usuario.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(
        data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> deleteUsuario(int id, String token) async {
    var response = await client.delete(
        Uri.parse(httpOptions.urlBase + '/api/usuario/delete?id=' + id.toString()),
        headers: {'Content-Type':'application/json', 'Authorization': 'Bearer ' + token});

    if (response.statusCode == 200) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(
        data: false, error: true, errorMessage: "");
  }
}