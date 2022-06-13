import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_numero_rota/multi_form.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/models/numero_rotas.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/numero_rota_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';


class CadastrarNumeroRotas extends StatefulWidget {
  const CadastrarNumeroRotas({Key? key}) : super(key: key);

  @override
  State<CadastrarNumeroRotas> createState() =>
      _CadastrarNumeroRotaState();
}

class _CadastrarNumeroRotaState extends State<CadastrarNumeroRotas> {
  late APIResponse<List<NumeroRotas>> _apiResponse;

  List<String> valores = [];
  List<Map> _rotas = [];

  bool isLoading = false;

  numeroRotasService get instance => GetIt.instance<numeroRotasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  @override
  void initState() {
    _fetchRotas();
    isLoading = true;
    super.initState();
  }

  _fetchRotas() async {
    _rotas = [];
    _apiResponse = await instance.getNumeroRotas(instanceHttp.token);
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
            if (isLoading) return const Center(child: CircularProgressIndicator());
            if (_apiResponse.error) {
              return Center(
                  child: EmptyState(
                    title: 'Error',
                    message: 'error na aprovação do servico extra, contate o desenvolvedor',
                  ));
            }
            if (_rotas.isEmpty) {
              return Center(
                child: EmptyState(
                  title: 'Vázia',
                  message: 'Não existem números de rota para serem mostrados',
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
      const DataColumn(label: Text('Rota')),
      const DataColumn(label: Text('Destino')),
      if(instanceHttp.cargo == 'Administrador')
        const DataColumn(label: Text('Despesas')),
      if(instanceHttp.cargo == 'Administrador')
        const DataColumn(label: Text('Valor')),
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'Rota': element.codigo,
        'Destino': element.destino,
        'Despesas': element.despesas.toString(),
        'Valor': element.valor.toString(),
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
          DataCell(Text(rotas['Rota'] ?? '')),
          DataCell(Text(rotas['Destino'] ?? '')),
          if(instanceHttp.cargo == 'Administrador')
            DataCell(Text(rotas['Despesas'] ?? '')),
          if(instanceHttp.cargo == 'Administrador')
            DataCell(Text(rotas['Valor'] ?? '')),
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
                  MultiFormNumeroRotas(_apiResponse.data[index])))
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
            await instance.deleteNumeroRotaWeb(
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
    if(mounted) setState(param0);
  }
}
