

import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_caminhao/multi_form.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/caminhao.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/caminhao_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';

import '../../components/alert_dialog.dart';

class CadastrarCaminhoes extends StatefulWidget {

  @override
  State<CadastrarCaminhoes> createState() =>
      _CadastrarCaminhoesState();
}

class _CadastrarCaminhoesState extends State<CadastrarCaminhoes> {
  late APIResponse<List<Caminhao>> _apiResponse;

  List<String> valores = [];
  List<Map> _caminhoes = [];

  bool isLoading = false;

  caminhaoService get instance => GetIt.instance<caminhaoService>();
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
    _caminhoes = [];
    _apiResponse = await instance.getCaminhoes(instanceHttp.token);
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
                    message: 'error na aprovação do servico extra, contate o desenvolvedor',
                  ));
            if (_caminhoes.length <= 0) {
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
      DataColumn(label: Text('Editar')),
      DataColumn(label: Text('Deletar')),
      DataColumn(label: Text('Placa')),
    ];
  }

  void fillRotas() {
    _apiResponse.data.forEach((element) {
      _caminhoes.add({
        'id': element.id.toString(),
        'placa': element.placa,
      });
      valores.add('');
    });
  }

  List<DataRow> _createRows() {
    return _caminhoes.mapIndexed((index, rotas) {
      return DataRow(
        cells: [
          DataCell(editInfo(index)),
          DataCell(deleteInfo(index)),
          DataCell(Text(rotas['placa'] ?? '')),
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
                  MultiFormCaminhao(_apiResponse.data[index])))
              .then((value) {
            _fetchRotas();
          });
        },
        icon: Icon(Icons.pending_actions_rounded));
  }

  Widget deleteInfo(int index) {
    return IconButton(
        onPressed: () async {
          var response = await showDialog(
              context: context,
              builder: (_) => CustomAlertDialog(
                  Text('Confirmação de deleção'),
                  Text('Gostaria de deletar esse servico?'),
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
            await instance.deleteCaminhao(
                _apiResponse.data[index].id, instanceHttp.token);
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
}
