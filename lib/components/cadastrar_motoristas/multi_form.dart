import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/cadastrar_motoristas/form.dart';
import 'package:cadastrorotas/models/motorista.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/motorista_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:get_it/get_it.dart';

class MultiFormMotorista extends StatefulWidget {
  final Motorista motorista;

  const MultiFormMotorista(this.motorista);

  @override
  _MultiFormMotoristaState createState() => _MultiFormMotoristaState(motorista);
}

class _MultiFormMotoristaState extends State<MultiFormMotorista> {
  List<MotoristaForm> motoristas = [];
  Motorista motorista;
  bool isLoading = false;

  motoristaService get instance => GetIt.instance<motoristaService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => !(motorista.id < 0);

  _MultiFormMotoristaState(this.motorista);

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
        title: Text((isEditting ? 'Editar ' : 'Cadastrar ') + 'motorista'),
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
        child: Builder(
          builder: (context) {
            if(isLoading) return const Center(child: CircularProgressIndicator(color: Colors.white,));
            if(motoristas.isEmpty) {
              return Center(
                    child: EmptyState(
                      title: 'Vázio',
                      message:
                          'Por favor, adicione um formulário clicando no botão abaixo',
                    ),
                  );
            }
                return ListView.builder(
                    addAutomaticKeepAlives: false,
                    itemCount: motoristas.length,
                    itemBuilder: (_, i) => motoristas[i],
                  );
          }
        ),
      ),
      floatingActionButton: !isEditting && motoristas.isEmpty
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
  void onDelete(Motorista _motorista) {
    setStateIfMounted(() {
      if(!isEditting) motorista = Motorista();
      var find = motoristas.firstWhere(
        (it) => it.motorista == _motorista,
        orElse: () => MotoristaForm(
          onDelete: () {},
          motorista: Motorista(),
        ),
      );
 motoristas.removeAt(motoristas.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    if (motoristas.isEmpty) {
      setStateIfMounted(() {

          motoristas.add(MotoristaForm(
            motorista: motorista,
            onDelete: () => onDelete(motorista),
          ));
      });
    }
  }

  ///on save forms
  void onSave() async {
    if (motoristas.isNotEmpty) {
      var allValid = true;
      for (var form in motoristas) {
        allValid = form.isValid();
      }
      if (allValid) {
        bool submit = false;
        final result = await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                Text((isEditting ? 'Editar' : 'Cadastrar') + ' motorista'),
                Text('Você tem certeza que deseja ' +
                    (isEditting ? 'editar' : 'cadastrar') +
                    ' esse motorista?'),
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
          var data = motoristas.map((it) => it.motorista).toList();
          setStateIfMounted(() {
            isLoading = true;
          });
          var response = isEditting
              ? await instance.editarMotorista(data[0], instanceHttp.token)
              : await instance.novoMotorista(data[0], instanceHttp.token);
          if (!response.error) {
            await showDialog(
                context: context,
                builder: (_) => CustomAlertDialog(
                    Text('Motorista ' + (isEditting ? 'editado' : 'criado')),
                    Text('O motorista foi ' +
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
                    Text('Erro ' + (isEditting ? 'na edição' : 'no cadastro') + ' do motorista'),
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
          motoristas = [];
          setStateIfMounted(() {
            isLoading = false;
            onAddForm();
          });
        }
      }
    }
  }

  void setStateIfMounted(Null Function() param0) {
    if(mounted) setState(param0);
  }
}
