import 'dart:convert';

import 'package:cadastrorotas/models/editar_manifesto.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:cadastrorotas/models/to_aprove_list.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;

class rotasService {
  var client = http.Client();

  Future<APIResponse<List<Rotas>>> getNovasRotasCadastras(
      String token, int id) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase + '/api/rota/find/novas_cadastradas?idUsuario=$id'),
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

  Future<APIResponse<List<Rotas>>> getRotasConcluidas(
      String token, String dataInicial, String dataFinal) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase +
            '/api/rota/find/concluidos?dataEmissaoInicial=$dataInicial&dataEmissaoFinal=$dataFinal'),
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

  Future<APIResponse<List<Rotas>>> getRotasForResponsavel(
      String token, int id) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase +
            '/api/rota/find/responsavel?idUsuario=' +
            id.toString()),
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

  Future<APIResponse<List<Rotas>>> getRotasForGerente(
      String token, int id) async {
    var response = await client.get(
        Uri.parse(httpOptions.urlBase +
            '/api/rota/find/gerente?idUsuario=' +
            id.toString()),
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

  Future<APIResponse<bool>> aprovarRota(
      String token, toAproveList aprovar) async {
    var body =
        jsonEncode(aprovar.listaToAprove.map((e) => e.toJson()).toList());
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/rota/edit/aprovar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: body);

    if (response.statusCode == 202) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> newRota(Rotas rota, String token) async {
    var body = jsonEncode(rota.cadastroRota());
    var response = await client.post(
        Uri.parse(httpOptions.urlBase + '/api/rota/cadastrar'),
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

  Future<APIResponse<bool>> updateManifesto(
      List<EditarManifesto> rotas, String token) async {
    var body = jsonEncode(rotas.map((e) => e.toJson()).toList());
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/rota/edit/manifesto'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: body);

    if (response.statusCode == 202) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> editarRotas(List<Rotas> rotas, String token) async {
    var body = jsonEncode(rotas.map((e) => e.toJson()).toList());
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/rota/edit/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: body);

    if (response.statusCode == 202) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> updateRota(Rotas rota, String token) async {
    var response = await client.put(
        Uri.parse(httpOptions.urlBase + '/api/rota/edit'),
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: jsonEncode(rota.toEdit()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return APIResponse<bool>(data: true);
    }
    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }

  Future<APIResponse<bool>> deleteRota(int id, String token) async {
    var response = await client.delete(
        Uri.parse(httpOptions.urlBase + '/api/rota/delete?id=' + id.toString()),
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
