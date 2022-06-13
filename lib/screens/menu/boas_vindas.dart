import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/screens/login/login.dart';
import 'package:cadastrorotas/screens/menu/menu_tela.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoasVindasScreen extends StatefulWidget {
  @override
  State<BoasVindasScreen> createState() => _BoasVindasScreenState();
}

class _BoasVindasScreenState extends State<BoasVindasScreen> {
  usuariosService get instanceUser => GetIt.instance<usuariosService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  @override
  void initState() {
    verificarToken().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(
          child: Center(
            child: CircularProgressIndicator()
        ),
      ),
    );
  }

  Future<bool> verificarToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString('token') != null) {
      var responseMe = await instanceUser
          .getUsuarioLogado(sharedPreferences.getString('token')!);
      if (!responseMe.error) {
        sharedPreferences.setString('nome', responseMe.data.nome);
        sharedPreferences.setString('cargo', responseMe.data.cargo);
        sharedPreferences.setString('id', responseMe.data.id.toString());
        instanceHttp.searchToken();
        return true;
      }
      sharedPreferences.remove('token');
      return false;
    }
    return false;
  }
}
