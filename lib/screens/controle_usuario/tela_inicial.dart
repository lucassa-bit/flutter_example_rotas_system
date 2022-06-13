import 'package:cadastrorotas/components/cadastrar_usuario/multi_form.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class telaInicial extends StatefulWidget {
  const telaInicial({Key? key}) : super(key: key);

  @override
  State<telaInicial> createState() => _telaInicialState();
}

class _telaInicialState extends State<telaInicial> {
  late APIResponse<List<Usuario>> _apiResponse;
  bool isLoading = false;
  usuariosService get instance => GetIt.instance<usuariosService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();


  @override
  void initState() {
    setStateIfMounted(() {
      isLoading = true;
    });

    _fetchUsuarios();

    super.initState();
  }

  _fetchUsuarios() async {
    _apiResponse = (await instance.getUsuarioList(instanceHttp.token));

    setStateIfMounted(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciar usuários'),
        ),
        floatingActionButton: FloatingActionButton(
          hoverColor: Colors.grey,
          backgroundColor: Colors.grey,
          onPressed: () => Navigator.of(context)
              .push(
                  MaterialPageRoute(builder: (context) => MultiForm(Usuario())))
              .then((_) {
            _fetchUsuarios();
          }),
          tooltip: 'Criar novo usuário',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Background(
          child: Builder(builder: (context) {
            if (isLoading) return const Center(child: CircularProgressIndicator());
            if (_apiResponse.error) {
              return EmptyState(
                title: 'Error',
                message: 'erro no cadastro do usuario',
              );
            }
            return ListView.builder(
              itemCount: _apiResponse.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    color: Colors.blueGrey,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      MultiForm(_apiResponse.data[index])))
                              .then((_) {
                            _fetchUsuarios();
                          });
                        },
                        child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {},
                            confirmDismiss: (direction) async {
                              final result = await showDialog(
                                  context: context,
                                  builder: (_) => CustomAlertDialog(
                                      const Text('Deletar usuário'),
                                      const Text(
                                          'Você tem certeza que deseja deletar esse usuário?'),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('sim')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('não'))));
                              if (result) {
                                var response = await instance
                                    .deleteUsuario(_apiResponse.data[index].id, instanceHttp.token);
                                if (response.error) {
                                  await showDialog(
                                      context: context,
                                      builder: (_) => CustomAlertDialog(
                                          const Text('Erro na exclusão'),
                                          const Text(
                                              'Ocorreu um error na deleção de usuário, tente novamente'),
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text(''),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('ok'))));
                                } else {
                                  await showDialog(
                                      context: context,
                                      builder: (_) => CustomAlertDialog(
                                          const Text('Usuário excluido'),
                                          const Text(
                                              'o usuário foi excluido com sucesso'),
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text(''),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text('ok'))));
                                  _fetchUsuarios();
                                }
                              }
                              return result;
                            },
                            background: Container(
                              color: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Align(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white70,
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            child: ListTile(
                                leading: const Padding(
                                  padding: EdgeInsets.symmetric(),
                                  child:
                                    Icon(Icons.person, color: Colors.white70),
                                ),
                                title: Text(
                                  _apiResponse.data[index].nome,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 18),
                                ),
                                subtitle: Text(
                                  _apiResponse.data[index].cargo,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                )))));
              },
            );
          }),
        ));
  }
  void setStateIfMounted(Null Function() param0) {
    if(mounted) setState(param0);
  }
}
