import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/cadastrar_caminhao/form.dart';
import 'package:cadastrorotas/models/caminhao.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/caminhao_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MultiFormCaminhao extends StatefulWidget {
  final Caminhao caminhao;

  const MultiFormCaminhao(this.caminhao, {Key? key}) : super(key: key);

  @override
  _MultiFormCaminhaoState createState() => _MultiFormCaminhaoState(caminhao);
}

class _MultiFormCaminhaoState extends State<MultiFormCaminhao> {
  List<CaminhaoForm> caminhoes = [];
  Caminhao caminhao;
  bool isLoading = false;

  caminhaoService get instance => GetIt.instance<caminhaoService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => !(caminhao.id < 0);

  _MultiFormCaminhaoState(this.caminhao);

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
        title: Text((isEditting ? 'Editar ' : 'Cadastrar ') + 'caminhão'),
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
          if (caminhoes.isEmpty) {
            return Center(
              child: EmptyState(
                title: 'Vázio',
                message:
                    'Por favor, adicione um formulário clicando no botão abaixo',
              ),
            );
          }
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: caminhoes.length,
            itemBuilder: (_, i) => caminhoes[i],
          );
        }),
      ),
      floatingActionButton: !isEditting && caminhoes.isEmpty
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
  void onDelete(Caminhao _caminhao) {
    setStateIfMounted(() {
      if(!isEditting) caminhao = Caminhao();
      var find = caminhoes.firstWhere(
        (it) => it.caminhao == _caminhao,
        orElse: () => CaminhaoForm(
          onDelete: () {},
          caminhao: Caminhao(),
        ),
      );
 caminhoes.removeAt(caminhoes.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    if (caminhoes.isEmpty) {
      setStateIfMounted(() {
        caminhoes.add(CaminhaoForm(
          caminhao: caminhao,
          onDelete: () => onDelete(caminhao),
        ));
      });
    }
  }

  ///on save forms
  void onSave() async {
    if (caminhoes.isNotEmpty) {
      var allValid = true;
      for (var form in caminhoes) {
        allValid = form.isValid();
      }
      if (allValid) {
        bool submit = false;
        final result = await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                Text((isEditting ? 'Editar' : 'Cadastrar') + ' caminhão'),
                Text('Você tem certeza que deseja ' +
                    (isEditting ? 'editar' : 'cadastrar') +
                    ' esse caminhão?'),
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
          var data = caminhoes.map((it) => it.caminhao).toList();
          setStateIfMounted(() {
            isLoading = true;
          });
          var response = isEditting
              ? await instance.editarCaminhao(data[0], instanceHttp.token)
              : await instance.novoCaminhao(data[0], instanceHttp.token);
          if (!response.error) {
            await showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Caminhão ' + (isEditting ? 'editado' : 'criado')),
                    Text('O caminhão foi ' +
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
                        ' do caminhão'),
                    Text('Analise as informações ' +
                        (isEditting ? 'de edição,' : 'de cadastro,') +
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
          caminhoes = [];
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
