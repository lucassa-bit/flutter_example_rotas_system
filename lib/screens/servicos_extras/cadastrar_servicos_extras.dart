import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_servicos_extras/multi_form.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/models/servicos_extras.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/servicos_extras_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';


class cadastrarServicosExtras extends StatefulWidget {
  String dataInicial;
  String dataFinal;

  cadastrarServicosExtras({required this.dataInicial, required this.dataFinal});

  @override
  State<cadastrarServicosExtras> createState() =>
      _cadastrarServicosExtrasState(dataInicial, dataFinal);
}

class _cadastrarServicosExtrasState extends State<cadastrarServicosExtras> {
  String dataInicial;
  String dataFinal;

  late APIResponse<List<ServicosExtras>> _apiResponse;

  List<String> valores = [];
  List<Map> _rotas = [];

  int indexColumn = 0;

  bool isLoading = false;
  bool isAscd = true;

  servicosExtrasService get instance => GetIt.instance<servicosExtrasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  _cadastrarServicosExtrasState(this.dataInicial, this.dataFinal);

  @override
  void initState() {
    _fetchRotas();
    isLoading = true;
    super.initState();
  }

  _fetchRotas() async {
    _rotas = [];
    _apiResponse =
        await instance.getServices(instanceHttp.token, dataInicial, dataFinal);
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
            if (isLoading) return Center(child: CircularProgressIndicator());
            if (_apiResponse.error)
              return Center(
                  child: EmptyState(
                title: 'Error',
                message: 'error na aprovação da rota, contate o desenvolvedor',
              ));
            if (_rotas.length <= 0) {
              return Center(
                child: EmptyState(
                  title: 'Vázia',
                  message: 'Sem rotas para serem aprovadas',
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
          child: DataTable(columns: _createColumns(), rows: _createRows(), sortAscending: isAscd, sortColumnIndex: indexColumn,)),
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Edit')),
      DataColumn(label: Text('Delete')),
      DataColumn(label: Text('Data'), onSort: (indexValue, _) {
        setState(() {
          indexColumn = indexValue;
          if (isAscd) {
            _rotas.sort(
                    (a, b) => compareToDate(a['Data'], b['Data']));
          } else {
            _rotas.sort(
                    (a, b) => compareToDate(b['Data'], a['Data']));
          }
          isAscd = !isAscd;
        });
      }),
      DataColumn(label: Text('Descricao')),
      DataColumn(label: Text('Destino')),
      DataColumn(label: Text('Valor')),
      DataColumn(label: Text('Despesas')),
    ];
  }

  void fillRotas() {
    _apiResponse.data.forEach((element) {
      _rotas.add({
        'Id': element.id.toString(),
        'Data': element.dataEmissao,
        'Destino': element.destinoRota,
        'Descricao': element.descricaoServico,
        'Valor': element.valorRota.toString(),
        'Despesas': element.despesasRota.toString(),
      });
      valores.add('');
    });
  }

  List<DataRow> _createRows() {
    return _rotas.mapIndexed((index, rotas) {
      return DataRow(
        cells: [
          DataCell(editInfo(int.parse(rotas['Id']))),
          DataCell(deleteInfo(int.parse(rotas['Id']))),
          DataCell(Text(rotas['Data'] ?? '')),
          DataCell(Text(rotas['Descricao'] ?? '')),
          DataCell(Text(rotas['Destino'] ?? '')),
          DataCell(Text(rotas['Valor'] ?? '')),
          DataCell(Text(rotas['Despesas'] ?? '')),
        ],
      );
    }).toList();
  }

  Widget editInfo(int id) {
    ServicosExtras servicosExtras = ServicosExtras();
    _apiResponse.data.forEach((element) {
      if(id == element.id) {
        servicosExtras = element;
        return;
      }
    });
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => MultiFormServicosExtras(servicosExtras)))
              .then((value) {
            _fetchRotas();
          });
        },
        icon: Icon(Icons.pending_actions_rounded));
  }

  Widget deleteInfo(int id) {
    return IconButton(
        onPressed: () async {
          var response = await showDialog(
              context: context,
              builder: (_) => CustomAlertDialog(
                  Text('Confirmação de deleção'),
                  Text('Gostaria de deletar essa rota?'),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                      child: Text('Não')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      child: Text('Sim'))));
          setStateIfMounted(() {
            isLoading = true;
          });
          if (response != null && response) {
            await instance.deleteServicosExtras(id, instanceHttp.token);
            await _fetchRotas();
          }
          setStateIfMounted(() {
            isLoading = false;
          });
        },
        icon: Icon(Icons.delete));
  }

  void setStateIfMounted(Null Function() param0) {
    if(mounted) setState(param0);
  }

  int compareTo(String aValue, String bValue) {
    var charsA = aValue.split('');
    var charsB = bValue.split('');
    int index = 0;
    while (aValue.length > index && bValue.length > index) {
      var compare = charsA[index].compareTo(charsB[index]);
      if (compare != 0) {
        return compare;
      }
      index++;
    }
    if (aValue.length > bValue.length) {
      return 1;
    } else if (aValue.length < bValue.length) {
      return -1;
    }
    return 0;
  }

  int compareToDate(String aValue, String bValue) {
    var charsA = aValue.split('/');
    var charsB = bValue.split('/');
    int index = 2;
    while (index >= 0) {
      var compare = charsA[index].compareTo(charsB[index]);
      if (compare != 0) {
        return compare;
      }
      index--;
    }
    if (aValue.length > bValue.length) {
      return 1;
    } else if (aValue.length < bValue.length) {
      return -1;
    }
    return 0;
  }
}
