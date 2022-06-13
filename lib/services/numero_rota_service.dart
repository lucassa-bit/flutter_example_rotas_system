import 'dart:convert';

import 'package:cadastrorotas/models/motorista.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/numero_rotas.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class numeroRotasService {
  var client = http.Client();

  Future<APIResponse<List<NumeroRotas>>> getNumeroRotas(String token) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/numeroRota'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final motoristas = <NumeroRotas>[];

      for (var item in jsonData) {
        motoristas.add(NumeroRotas.fromJson(item));
      }
      return APIResponse<List<NumeroRotas>>(data: motoristas);
    }
    return APIResponse<List<NumeroRotas>>(data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> novoNumeroRota(NumeroRotas numeroRotas, String token) async {
    var body = jsonEncode(numeroRotas.toJson());
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/numeroRota/cadastrar'),
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

  Future<APIResponse<bool>> editarNumeroRota(NumeroRotas numeroRotas, String token) async {
    var body = jsonEncode(numeroRotas.toJson());
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/numeroRota/edit'),
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

  Future<APIResponse<bool>> deleteNumeroRota(int id, String token) async {
    var response = await client.delete(
        Uri.parse(httpOptions.urlBase + '/api/numeroRota/delete?id=' + id.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> deleteNumeroRotaWeb(int id, String token) async {
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/numeroRota/deleteWeb?id=' + id.toString()),
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
