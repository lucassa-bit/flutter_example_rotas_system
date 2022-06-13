import 'dart:convert';

import 'package:cadastrorotas/models/rotas.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class rotasExtrasService {
  var client = http.Client();

  Future<APIResponse<List<Rotas>>> getRotas(
      String token, String dataInicial, String dataFinal) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase +
            '/api/rota_extra?dataEmissaoInicial=${dataInicial}&dataEmissaoFinal=${dataFinal}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final rotas = <Rotas>[];

      for (var item in jsonData) {
        rotas.add(Rotas.fromJson(item));
      }
      return APIResponse<List<Rotas>>(data: rotas);
    }
    return APIResponse<List<Rotas>>(data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> newRotaExtras(Rotas rota, String token) async {
    var body = jsonEncode(rota.cadastroRotaExtra());
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/rota_extra/cadastrar'),
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

  Future<APIResponse<bool>> updateRotaExtra(Rotas rota, String token) async {
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/rota_extra/edit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: jsonEncode(rota.toEditExtra()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> deleteRotasExtras(int id, String token) async {
    var response = await client.delete(
        Uri.parse(
            httpOptions.urlBase + '/api/rota_extra/delete?id=' + id.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }
}
