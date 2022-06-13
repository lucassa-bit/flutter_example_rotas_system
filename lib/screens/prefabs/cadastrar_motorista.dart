import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_motoristas/multi_form.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/models/motorista.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/motorista_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';

class CadastrarMotoristas extends StatefulWidget {
  const CadastrarMotoristas({Key? key}) : super(key: key);

  @override
  State<CadastrarMotoristas> createState() => _CadastrarMotoristaState();
}

class _CadastrarMotoristaState extends State<CadastrarMotoristas> {
  late APIResponse<List<Motorista>> _apiResponse;

  List<String> valores = [];
  List<Map> _rotas = [];

  bool isLoading = false;

  motoristaService get instance => GetIt.instance<motoristaService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  @override
  void initState() {
    setStateIfMounted(() {
      isLoading = true;
    });

    _fetchRotas();

    super.initState();
  }

  _fetchRotas() async {
    _rotas = [];
    _apiResponse = await instance.getMotoristas(instanceHttp.token);
    fillRotas();

    setStateIfMounted(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Background(
          child: Builder(builder: (context) {
            if (isLoading)
              return const Center(child: CircularProgressIndicator());
            if (_apiResponse.error) {
              return Center(
                  child: EmptyState(
                title: 'Error',
                message:
                    'error na aprovação do servico extra, contate o desenvolvedor',
              ));
            }
            if (_rotas.isEmpty) {
              return Center(
                child: EmptyState(
                  title: 'Vázia',
                  message: 'Não existem motoristas para serem mostrados',
                ),
              );
            } else {
              return _createDataTable();
            }
          }),
        ));
  }

  Widget _createDataTable() {
    return ListView(children: [
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(columns: _createColumns(), rows: _createRows())),
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Editar')),
      const DataColumn(label: Text('Deletar')),
      const DataColumn(label: Text('Nome')),
      const DataColumn(label: Text('Identidade')),
      const DataColumn(label: Text('Cpf')),
      const DataColumn(label: Text('Pix')),
      const DataColumn(label: Text('Contato')),
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'nomeMotorista': element.nome,
        'cpfMotorista': element.cpf,
        'numeroCelularMotorista': element.contato,
        'pixMotorista': element.pix,
        'identidadeMotorista': element.identidade,
      });
      valores.add('');
    }
  }

  List<DataRow> _createRows() {
    return _rotas.mapIndexed((index, rotas) {
      return DataRow(
        cells: [
          DataCell(editInfo(index)),
          DataCell(deleteInfo(index)),
          DataCell(Text(rotas['nomeMotorista'] ?? '')),
          DataCell(Text(rotas['identidadeMotorista'].isNotEmpty
              ? rotas['identidadeMotorista']
              : 'Vázio')),
          DataCell(Text(rotas['cpfMotorista'].isNotEmpty
              ? rotas['cpfMotorista']
              : 'Vázio')),
          DataCell(Text(rotas['pixMotorista'].isNotEmpty
              ? rotas['pixMotorista']
              : 'Vázio')),
          DataCell(Text(rotas['numeroCelularMotorista'].isNotEmpty ? rotas['numeroCelularMotorista'] : 'Sem contato')),
        ],
      );
    }).toList();
  }

  Widget editInfo(int index) {
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      MultiFormMotorista(_apiResponse.data[index])))
              .then((value) {
            _fetchRotas();
          });
        },
        icon: const Icon(Icons.pending_actions_rounded));
  }

  Widget deleteInfo(int index) {
    return IconButton(
        onPressed: () async {
          var response = await showDialog(
              context: context,
              builder: (_) => CustomAlertDialog(
                  const Text('Confirmação de deleção'),
                  const Text('Gostaria de deletar esse servico?'),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                      child: const Text('Não')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child: const Text('Sim'))));
          setStateIfMounted(() {
            isLoading = true;
          });
          if (response != null && response) {
            await instance.deleteMotorista(
                _apiResponse.data[index].id, instanceHttp.token);
            await _fetchRotas();
          }
          setStateIfMounted(() {
            isLoading = false;
          });
        },
        icon: const Icon(Icons.delete));
  }

  void setStateIfMounted(Null Function() param0) {
    if (mounted) setState(param0);
  }
}
