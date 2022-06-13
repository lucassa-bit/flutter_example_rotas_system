import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/rotas_extras_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';

import '../../components/cadastrar_rotas_extras/multi_form.dart';

class cadastrarRotasExtras extends StatefulWidget {
  String dataInicial;
  String dataFinal;

  cadastrarRotasExtras(
      {Key? key, required this.dataInicial, required this.dataFinal})
      : super(key: key);

  @override
  State<cadastrarRotasExtras> createState() =>
      _cadastrarRotasExtrasState(dataInicial, dataFinal);
}

class _cadastrarRotasExtrasState extends State<cadastrarRotasExtras> {
  String dataInicial;
  String dataFinal;

  late APIResponse<List<Rotas>> _apiResponse;

  List<String> valores = [];
  List<Map> _rotas = [];

  int indexColumn = 0;

  bool isLoading = false;
  bool isAscd = true;

  rotasExtrasService get instance => GetIt.instance<rotasExtrasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  _cadastrarRotasExtrasState(this.dataInicial, this.dataFinal);

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
    _apiResponse =
        await instance.getRotas(instanceHttp.token, dataInicial, dataFinal);
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
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
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
                  message: 'Sem servicos para essas datas',
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
          child: DataTable(
            columns: _createColumns(),
            rows: _createRows(),
            sortColumnIndex: indexColumn,
            sortAscending: isAscd,
          )),
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Editar')),
      const DataColumn(label: Text('Deletar')),
      DataColumn(
          label: const Text('Data de emissão'),
          onSort: (indexValue, _) {
            setState(() {
              indexColumn = indexValue;
              if (isAscd) {
                _rotas.sort(
                    (a, b) => compareToDate(a['dataEmissao'], b['dataEmissao']));
              } else {
                _rotas.sort(
                    (a, b) => compareToDate(b['dataEmissao'], a['dataEmissao']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('data de chegada'),
          onSort: (indexValue, _) {
            setState(() {
              indexColumn = indexValue;
              if (isAscd) {
                _rotas.sort(
                    (a, b) => compareToDate(a['dataChegada'], b['dataChegada']));
              } else {
                _rotas.sort(
                    (a, b) => compareToDate(b['dataChegada'], a['dataChegada']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Rota'),
          onSort: (indexValue, _) {
            setState(() {
              indexColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(a['rota'], b['rota']));
              } else {
                _rotas.sort((a, b) => compareTo(b['rota'], a['rota']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Destino'),
          onSort: (indexValue, _) {
            setState(() {
              indexColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(a['destino'], b['destino']));
              } else {
                _rotas.sort((a, b) => compareTo(b['destino'], a['destino']));
              }
              isAscd = !isAscd;
            });
          }),
      const DataColumn(label: Text('Número do manifesto')),
      const DataColumn(label: Text('Número de romaneio')),
      const DataColumn(label: Text('Ver mais')),
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'dataEmissao': element.dataEmissao,
        'dataChegada': element.dataChegada,
        'rota': element.codigoRota,
        'destino': element.destinoRota,
        'numeroManifesto': element.numeroManifesto,
        'numeroRomaneio': element.numeroRomaneio,
        'nomeMotorista': element.nomeMotorista,
        'contatoMotorista': element.numeroCelularMotorista,
        'despesas': element.despesasRota.toString(),
        'valor': element.valorRota.toString(),
      });
      valores.add('');
    }
  }

  List<DataRow> _createRows() {
    return _rotas.mapIndexed((index, rotas) {
      return DataRow(
        cells: [
          DataCell(editInfo(int.parse(rotas['id']))),
          DataCell(deleteInfo(int.parse(rotas['id']))),
          DataCell(Text(rotas['dataEmissao'] ?? '')),
          DataCell(Text(rotas['dataChegada'] ?? '')),
          DataCell(Text(rotas['rota'] ?? '')),
          DataCell(Text(rotas['destino'] ?? '')),
          DataCell(Text(rotas['numeroManifesto'] ?? '')),
          DataCell(Text(rotas['numeroRomaneio'] ?? '')),
          DataCell(viewInfo(int.parse(rotas['id']))),
        ],
      );
    }).toList();
  }

  Widget viewInfo(int id) {
    Rotas rota = Rotas();
    for (var element in _apiResponse.data) {
      if(id == element.id) {
        rota = element;
        continue;
      }
    }
    return IconButton(
        onPressed: () async {
          await showDialog<bool>(
            builder: (_) => CustomAlertDialog(
                const Text(''),
                Text('Placa do caminhão: ${rota.placaCaminhao}\n'
                    'Nome do motorista: ${rota.nomeMotorista}\n'
                    'Contato do motorista: ${rota.numeroCelularMotorista.isNotEmpty ? rota.numeroCelularMotorista : 'Sem contato'}\n'
                    'Identidade do motorista: ${rota.identidadeMotorista.isNotEmpty ? rota.identidadeMotorista : 'Vázio'}\n'
                    'Cpf do motorista: ${rota.cpfMotorista.isNotEmpty ? rota.cpfMotorista : 'Vázio'}\n'
                    'Pix do motorista: ${rota.pixMotorista.isNotEmpty ? rota.pixMotorista : 'Vázio'}\n\n'
                    'Administrador: ${rota.nomeAdministrador}\n'
                    'Contato do administrador: ${rota.contatoAdministrador.isNotEmpty ? rota.contatoAdministrador : 'Sem contato'}\n'
                    'Identidade do administrador: ${rota.identidadeAdministrador.isNotEmpty ? rota.identidadeAdministrador : 'Vázio'}\n'
                    'Cpf do administrador: ${rota.cpfAdministrador.isNotEmpty ? rota.cpfAdministrador : 'Vázio'}\n'
                    'Pix do administrador: ${rota.pixAdministrador.isNotEmpty ? rota.pixAdministrador : 'Vázio'}\n\n'
                    'Despesas: ${rota.despesasRota}\n'
                    'Valor: ${rota.valorRota}\n'),
                TextButton(
                  onPressed: () => null,
                  child: const Text(''),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Ok'),
                )),
            context: context,
          );
        },
        icon: const Icon(Icons.info_outline));
  }

  Widget editInfo(int id) {
    Rotas rota = Rotas();
    for (var element in _apiResponse.data) {
      if(element.id == id) {
        rota = element;
        continue;
      }
    }
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      MultiFormRotaExtra(rota)))
              .then((value) {
            _fetchRotas();
          });
        },
        icon: const Icon(Icons.pending_actions_rounded));
  }

  Widget deleteInfo(int id) {
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
          if (response != null && response) {
            setStateIfMounted(() {
              isLoading = true;
            });
            await instance.deleteRotasExtras(id, instanceHttp.token);
            await _fetchRotas();
            setStateIfMounted(() {
              isLoading = false;
            });
          }
        },
        icon: const Icon(Icons.delete));
  }

  void setStateIfMounted(Null Function() param0) {
    if (mounted) setState(param0);
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
