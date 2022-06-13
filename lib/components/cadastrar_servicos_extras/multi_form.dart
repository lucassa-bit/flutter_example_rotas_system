import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/cadastrar_servicos_extras/form.dart';
import 'package:cadastrorotas/models/servicos_extras.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/servicos_extras_services.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:get_it/get_it.dart';

class MultiFormServicosExtras extends StatefulWidget {
  final ServicosExtras servicosExtras;

  const MultiFormServicosExtras(this.servicosExtras, {Key? key}) : super(key: key);

  @override
  _MultiFormServicosExtrasState createState() =>
      _MultiFormServicosExtrasState(servicosExtras);
}

class _MultiFormServicosExtrasState extends State<MultiFormServicosExtras> {
  List<ServiceForms> serviceForms = [];
  ServicosExtras servicosExtras;
  bool isLoading = false;

  servicosExtrasService get instance => GetIt.instance<servicosExtrasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => !(servicosExtras.id < 0);

  _MultiFormServicosExtrasState(this.servicosExtras);

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
        title: const Text('Cadastrar Serviços'),
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
          return serviceForms.isEmpty
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
                      itemCount: serviceForms.length,
                      itemBuilder: (_, i) => serviceForms[i],
                    );
        }),
      ),
      floatingActionButton: !isEditting && serviceForms.isEmpty
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
  void onDelete(ServicosExtras _user) {
    setStateIfMounted(() {
      if(!isEditting) servicosExtras = ServicosExtras();
      var find = serviceForms.firstWhere(
        (it) => it.servicosExtras == _user,
        orElse: () => ServiceForms(
          onDelete: () {},
          servicosExtras: ServicosExtras(),
        ),
      );
 serviceForms.removeAt(serviceForms.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    if (serviceForms.isEmpty) {
      setStateIfMounted(() {
          serviceForms.add(ServiceForms(
            servicosExtras: servicosExtras,
            onDelete: () => onDelete(servicosExtras),
          ));
      });
    }
  }

  ///on save forms
  void onSave() async {
    if (serviceForms.isNotEmpty) {
      var allValid = true;
      for (var form in serviceForms) {
        allValid = form.isValid();
      }
      if (allValid) {
        bool submit = false;
        final result = await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                Text((isEditting ? 'Editar' : 'Cadastrar') + ' Serviço extra'),
                Text('Você tem certeza que deseja ' +
                    (isEditting ? 'editar' : 'cadastrar') +
                    ' esse Serviço extra?'),
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
          var data = serviceForms.map((it) => it.servicosExtras).toList();
          setStateIfMounted(() {
            isLoading = true;
          });
          var response = isEditting
              ? await instance.updateServicosExtra(data[0], instanceHttp.token)
              : await instance.newServicosExtras(data[0], instanceHttp.token);
          if (!response.error) {
            await showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Rota extra ' + (isEditting ? 'editada' : 'criada')),
                    Text('A rota extra foi ' +
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
                        ' do serviço extra'),
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
          serviceForms = [];
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
