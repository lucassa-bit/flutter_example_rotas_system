import 'dart:convert';

import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class arquivoService {
  var client = http.Client();

  Future<APIResponse<bool>> uploadImagem(
      String file, int id, String nomeArquivo) async {
    await client.post(
        Uri.parse(
          httpOptions.urlBase + '/api/arquivos/upload/$id',
        ),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode({
          'file':
              const Base64Encoder().convert(await (XFile(file).readAsBytes())),
          'nomeArquivo': nomeArquivo,
        }));

    return APIResponse<bool>(data: false, error: true, errorMessage: "");
  }
}
