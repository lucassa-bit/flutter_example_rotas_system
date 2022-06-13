import 'dart:convert';

import 'package:cadastrorotas/models/motorista.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class motoristaService {
  var client = http.Client();

  Future<APIResponse<List<Motorista>>> getMotoristas(String token) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/motorista'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final motoristas = <Motorista>[];

      for (var item in jsonData) {
        motoristas.add(Motorista.fromJson(item));
      }
      return APIResponse<List<Motorista>>(data: motoristas);
    }
    return APIResponse<List<Motorista>>(data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> novoMotorista(Motorista motorista, String token) async {
    var body = jsonEncode(motorista.toJson());
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/motorista/cadastrar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> editarMotorista(Motorista motorista, String token) async {
    var body = jsonEncode(motorista.toJson());
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/motorista/edit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> deleteMotorista(int id, String token) async {
    var response = await client.delete(
        Uri.parse(httpOptions.urlBase + '/api/motorista/delete?id=' + id.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }
}
