import 'dart:convert';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/caminhao.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class caminhaoService {
  var client = http.Client();

  Future<APIResponse<List<Caminhao>>> getCaminhoes(String token) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/caminhao'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final motoristas = <Caminhao>[];

      for (var item in jsonData) {
        motoristas.add(Caminhao.fromJson(item));
      }
      return APIResponse<List<Caminhao>>(data: motoristas);
    }
    return APIResponse<List<Caminhao>>(data: [], error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> novoCaminhao(Caminhao motorista, String token) async {
    var body = jsonEncode(motorista.toJson());
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/caminhao/cadastrar'),
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

  Future<APIResponse<bool>> editarCaminhao(Caminhao motorista, String token) async {
    var body = jsonEncode(motorista.toJson());
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/caminhao/edit'),
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

  Future<APIResponse<bool>> deleteCaminhao(int id, String token) async {
    var response = await client.delete(
        Uri.parse(httpOptions.urlBase + '/api/caminhao/delete?id=' + id.toString()),
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
