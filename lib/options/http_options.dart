import 'package:shared_preferences/shared_preferences.dart';

class httpOptions{
  static const urlBase = 'https://aedrotas.herokuapp.com';

  var token = '';
  var nome = '';
  var cargo = '';
  var id = '';

  void searchToken() async {
    var valor = await SharedPreferences.getInstance();
    token = valor.getString('token')!;
    nome = valor.getString('nome')!;
    cargo = valor.getString('cargo')!;
    id = valor.getString('id')!;
  }

  void deleteToken() async {
    var valor = await SharedPreferences.getInstance();
    valor.remove('token');
    valor.remove('nome');
    valor.remove('cargo');
    valor.remove('id');
    token = '';
    nome = '';
    cargo = '';
    id = '';
  }
}