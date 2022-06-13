import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/rotas_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/components/cadastrar_rotas/form.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:get_it/get_it.dart';

class MultiForm extends StatefulWidget {
  final Rotas rota;

  const MultiForm(this.rota);

  @override
  _MultiFormState createState() => _MultiFormState(rota);
}

class _MultiFormState extends State<MultiForm> {
  List<RotasForm> rotas = [];
  Rotas rota;
  bool isLoading = false;

  rotasService get instance => GetIt.instance<rotasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => !(rota.id < 0);

  _MultiFormState(this.rota);

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
        title: Text(isEditting ? 'Editar rotas' : 'Cadastrar rotas'),
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
                      ),
                    )
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
  void onDelete(Rotas _user) {
    setStateIfMounted(() {
      if(!isEditting) rota = Rotas();
      var find = rotas.firstWhere(
        (it) => it.rotas == _user,
        orElse: () => RotasForm(
          onDelete: () {},
          rotas: Rotas(),
        ),
      );
      rotas.removeAt(rotas.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    if (rotas.isEmpty) {
      setStateIfMounted(() {
          rotas.add(RotasForm(
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
                Text((isEditting ? 'Editar' : 'Cadastrar') + ' rota'),
                Text('Você tem certeza que deseja ' +
                    (isEditting ? 'editar' : 'cadastrar') +
                    ' essa rota?'),
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
          data[0].gerenteExterno = int.parse(instanceHttp.id);
          var response = isEditting
              ? await instance.updateRota(data[0], instanceHttp.token)
              : await instance.newRota(data[0], instanceHttp.token);
          if (!response.error) {
            await showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Rota ' + (isEditting ? 'editada' : 'criada')),
                    Text('A rota foi ' +
                        (isEditting ? 'editada' : 'criada') +
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
                        ' da rota'),
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
                        child: const Text('ok')))).then((value) {
              if(isEditting) return Navigator.of(context, rootNavigator: true).pop();
            });
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
