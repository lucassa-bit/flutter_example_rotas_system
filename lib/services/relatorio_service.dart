import 'package:cadastrorotas/models/api_response.dart';
import 'package:http/http.dart' as http;

class relatorioService {
  var client = http.Client();
  static const urlBase = 'https://aedrotas.herokuapp.com';

  Future<APIResponse<String>> generateTemporaryToken(String token) async {
    var response = await client.get(
        Uri.parse(urlBase + '/api/relatorio/token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        });

    if (response.statusCode == 200) {
      return APIResponse<String>(data: response.body);
    }
    return APIResponse<String>(
        data: '', error: true, errorMessage: "");
  }
}