import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/cadastrar_numero_rota/form.dart';
import 'package:cadastrorotas/models/numero_rotas.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/numero_rota_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:get_it/get_it.dart';

class MultiFormNumeroRotas extends StatefulWidget {
  final NumeroRotas rota;

  const MultiFormNumeroRotas(this.rota);

  @override
  _MultiFormNumeroRotasState createState() => _MultiFormNumeroRotasState(rota);
}

class _MultiFormNumeroRotasState extends State<MultiFormNumeroRotas> {
  List<NumeroRotasForm> rotas = [];
  NumeroRotas rota;
  bool isLoading = false;

  numeroRotasService get instance => GetIt.instance<numeroRotasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => !(rota.id < 0);

  _MultiFormNumeroRotasState(this.rota);

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
        title: Text((isEditting ? 'Editar ' : 'Cadastrar ') + 'numero rota'),
        centerTitle: true,
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
          return rotas.isEmpty
              ? Center(
                  child: EmptyState(
                    title: 'Vázio',
                    message:
                        'Por favor, adicione um formulário clicando no botão abaixo',
                  ),
                )
              : isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : ListView.builder(
                      addAutomaticKeepAlives: false,
                      itemCount: rotas.length,
                      itemBuilder: (_, i) => rotas[i],
                    );
        }),
      ),
      floatingActionButton: !isEditting && rotas.isEmpty
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
  void onDelete(NumeroRotas _numeroRota) {
    setStateIfMounted(() {
      if(!isEditting) rota = NumeroRotas();
      var find = rotas.firstWhere(
        (it) => it.rotas == _numeroRota,
        orElse: () => NumeroRotasForm(
          onDelete: () {},
          rotas: NumeroRotas(),
        ),
      );
 rotas.removeAt(rotas.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    if (rotas.isEmpty) {
      setStateIfMounted(() {
          rotas.add(NumeroRotasForm(
            rotas: rota,
            onDelete: () => onDelete(rota),
          ));
      });
    }
  }

  ///on save forms
  void onSave() async {
    if (rotas.isNotEmpty) {
      var allValid = true;
      for (var form in rotas) {
        allValid = form.isValid();
      }
      if (allValid) {
        bool submit = false;
        final result = await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                Text((isEditting ? 'Editar' : 'Cadastrar') + ' número de rota'),
                Text('Você tem certeza que deseja ' +
                    (isEditting ? 'editar' : 'cadastrar') +
                    ' esse número de rota?'),
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
          var data = rotas.map((it) => it.rotas).toList();
          setStateIfMounted(() {
            isLoading = true;
          });
          var response = isEditting
              ? await instance.editarNumeroRota(data[0], instanceHttp.token)
              : await instance.novoNumeroRota(data[0], instanceHttp.token);
          if (!response.error) {
            await showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Número de rota ' +
                        (isEditting ? 'editada' : 'criada')),
                    Text('O número da rota foi ' +
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
            await showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Erro ' +
                        (isEditting ? 'na edição' : 'no cadastro') +
                        ' do número de rota'),
                    Text('Analise as informações ' +
                        (isEditting ? 'de edição' : 'de cadastro') +
                        ' aguarde um pouco e tente novamente'),
                    TextButton(
                      onPressed: () {},
                      child: const Text(''),
                    ),
                    TextButton(
                        onPressed: () {
                          int count = 0;
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text('ok'))));
          }
          rotas = [];
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
