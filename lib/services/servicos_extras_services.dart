import 'dart:convert';

import 'package:cadastrorotas/models/servicos_extras.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class servicosExtrasService {
  var client = http.Client();

  Future<APIResponse<List<ServicosExtras>>> getServices(
      String token, String dataInicial, String dataFinal) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase +
            '/api/servico_extra?dataEmissaoInicial=${dataInicial}&dataEmissaoFinal=${dataFinal}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final servicos = <ServicosExtras>[];

      for (var item in jsonData) {
        servicos.add(ServicosExtras.fromJson(item));
      }
      return APIResponse<List<ServicosExtras>>(data: servicos);
    }
    return APIResponse<List<ServicosExtras>>(data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> newServicosExtras(ServicosExtras servicosExtras, String token) async {
    var body = jsonEncode(servicosExtras.toJson());
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/servico_extra/cadastrar'),
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

  Future<APIResponse<bool>> updateServicosExtra(ServicosExtras servicosExtras, String token) async {
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/servico_extra/edit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: jsonEncode(servicosExtras.toJson()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> deleteServicosExtras(int id, String token) async {
    var response = await client.delete(
        Uri.parse(
            httpOptions.urlBase + '/api/servico_extra/delete?id=' + id.toString()),
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
