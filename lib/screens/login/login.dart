import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/models/login.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/screens/menu/menu_tela.dart';
import 'package:cadastrorotas/services/login_service.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  loginService get instance => GetIt.instance<loginService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();
  usuariosService get instanceUser => GetIt.instance<usuariosService>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _formKey,
      body: SingleChildScrollView(
        child: Background(
          child: Builder(builder: (context) {
            if (isLoading)
              return const Center(child: CircularProgressIndicator());
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.23),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _loginController,
                    validator: (login) {
                      if (login == null || login.isEmpty) {
                        return 'Login inválido';
                      } else
                        return null;
                    },

                    decoration: InputDecoration(labelText: "Login"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !passwordVisibility,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'senha inválida';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Senha", suffixIcon: InkWell(
                      onTap: () => setState(
                            () => passwordVisibility = !passwordVisibility,
                      ),
                      child: Icon(
                        passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF34BBB3),
                        size: 22,
                      ),
                    ),),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      var isLoginValidated = await islogged();
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (isLoginValidated) {
                        setStateIfMounted(() {
                          isLoading = false;
                        });
                        instanceHttp.searchToken();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuScreen()));
                      } else
                        _passwordController.clear();

                      setStateIfMounted(() {
                        isLoading = false;
                      });
                    },
                    child: const Text('Logar'),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  final snackBarLogin = SnackBar(
    content: Text('Confirmando informações...'),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 1),
  );
  final snackBarError = SnackBar(
    content: Text('Error no login: Análise as informações e tente novamente'),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 1),
  );

  Future<bool> islogged() async {
    setStateIfMounted(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ScaffoldMessenger.of(context).showSnackBar(snackBarLogin).close;
    var loginForm =
        Login(login: _loginController.text, password: _passwordController.text);
    var response = await instance.login(loginForm);
    if (!response.error) {
      sharedPreferences.setString('token', response.data);
      var responseMe = await instanceUser.getUsuarioLogado(response.data);

      if (!responseMe.error) {
        sharedPreferences.setString('nome', responseMe.data.nome);
        sharedPreferences.setString('cargo', responseMe.data.cargo);
        sharedPreferences.setString('id', responseMe.data.id.toString());
        return true;
      }
      return false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      return false;
    }
  }

  void setStateIfMounted(Null Function() param0) {
    if (mounted) setState(param0);
  }
}
