import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/cadastrar_usuario/form.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:get_it/get_it.dart';

class MultiForm extends StatefulWidget {
  final Usuario usuario;
  const MultiForm(this.usuario, {Key? key}) : super(key: key);
  @override
  _MultiFormState createState() => _MultiFormState(usuario);
}

class _MultiFormState extends State<MultiForm> {
  List<UsuarioForm> usuarios = [];
  Usuario usuario;
  bool isLoading = false;

  usuariosService get instance => GetIt.instance<usuariosService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => usuario.id >= 0;

  _MultiFormState(this.usuario);

  @override
  void initState() {
    setStateIfMounted(() {
      onAddForm();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        title: const Text('Cadastrar usuario'),
        actions: <Widget>[
          InkWell(
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: onSave,
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF30C1FF),
              Color(0xFF2AA7DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Builder(builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (usuarios.isEmpty) {
            return Center(
              child: EmptyState(
                title: 'Vázio',
                message:
                    'Por favor, adicione um formulário a partir do botão abaixo',
              ),
            );
          } else {
            return ListView.builder(
              addAutomaticKeepAlives: false,
              itemCount: usuarios.length,
              itemBuilder: (_, i) => usuarios[i],
            );
          }
        }),
      ),
      floatingActionButton: !isEditting && usuarios.isEmpty
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                onAddForm();
              },
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  ///on form user deleted
  void onDelete(Usuario _user) {
    setStateIfMounted(() {
      if(!isEditting) usuario = Usuario();
      var find = usuarios.firstWhere(
        (it) => it.usuario == _user,
        orElse: () => UsuarioForm(
          onDelete: () {},
          usuario: Usuario(),
        ),
      );
 usuarios.removeAt(usuarios.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    if (usuarios.isEmpty) {
      setStateIfMounted(() {
          usuarios.add(UsuarioForm(
            usuario: usuario,
            onDelete: () => onDelete(usuario),
          ));
      });
    }
  }

  ///on save forms
  void onSave() async {
    if (usuarios.isNotEmpty) {
      var allValid = true;
      for (var form in usuarios) {
        allValid = form.isValid();
      }
      if (allValid) {
        bool submit = true;
        final result = await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                Text((isEditting ? 'Editar' : 'Cadastrar') + ' usuário'),
                Text('Você tem certeza que deseja ' +
                    (isEditting ? 'editar' : 'cadastrar') +
                    ' esse usuário?'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      submit = false;
                    },
                    child: const Text('Não')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      submit = true;
                    },
                    child: const Text('Sim'))));
        if (submit) {
          var data = usuarios.map((it) => it.usuario).toList();
          setStateIfMounted(() {
            isLoading = true;
          });
          var response = isEditting
              ? await instance.updateUsuario(data[0], instanceHttp.token)
              : await instance.newUsuario(data[0], instanceHttp.token);
          if (!response.error) {
            setStateIfMounted(() {
              isLoading = false;
            });
            showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Usuário ' + (isEditting ? 'editado' : 'criado')),
                    Text('Seu usuário foi ' +
                        (isEditting ? 'editado' : 'criado') +
                        ' com sucesso'),
                    TextButton(
                      onPressed: () {},
                      child: const Text(''),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          submit = true;
                        },
                        child: const Text('ok'))));
          } else {
            showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Erro ' +
                        (isEditting ? 'na edição' : 'no cadastro') +
                        ' do usuário'),
                    Text('Analise as informações ' +
                        (isEditting ? 'de edição' : 'de cadastro') +
                        ' aguarde um pouco e tente novamente'),
                    TextButton(
                      onPressed: () {},
                      child: const Text(''),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          submit = true;
                        },
                        child: const Text('ok'))));
          }
          usuarios = [];
          setStateIfMounted(() {
            isLoading = false;
            onAddForm();
          });
        }
      }
    }
  }

  void setStateIfMounted(Null Function() param0) {
    if (mounted) setState(param0);
  }
}
