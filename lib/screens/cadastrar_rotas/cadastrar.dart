import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_rotas/multi_form.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/rotas_service.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:flutter/material.dart';

class cadastrarRotas extends StatefulWidget {
  const cadastrarRotas({Key? key}) : super(key: key);

  @override
  _cadastrarRotasState createState() => _cadastrarRotasState();
}

class _cadastrarRotasState extends State<cadastrarRotas> {
  late APIResponse<List<Rotas>> _apiResponse;
  List<String> valores = [];
  bool isLoading = false;
  List<Map> _rotas = [];
  final _formKey = GlobalKey<FormState>();
  int _sortColumn = 0;
  bool isAscd = true;

  rotasService get instance => GetIt.instance<rotasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  @override
  void initState() {
    _fetchRotas();
    isLoading = true;
    super.initState();
  }

  _fetchRotas() async {
    _rotas = [];
    _apiResponse = await instance.getNovasRotasCadastras(
        instanceHttp.token, int.parse(instanceHttp.id));
    fillRotas();

    setStateIfMounted(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _formKey,
        appBar: AppBar(
          title: const Text('Rotas cadastradas'),
        ),
        floatingActionButton: FloatingActionButton(
            hoverColor: Colors.grey,
            backgroundColor: Colors.grey,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => MultiForm(Rotas())))
                  .then((value) {
                _fetchRotas();
              });
            },
            child: const Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Background(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
            child: Builder(builder: (context) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_apiResponse.error) {
                return Center(
                    child: EmptyState(
                  title: 'Error',
                  message:
                      'error na aprovação da rota, contate o desenvolvedor',
                ));
              }
              if (_rotas.isEmpty) {
                return Center(
                  child: EmptyState(
                    title: 'Vázia',
                    message:
                        'rotas cadastradas já foram adicionadas o manifesto e/ou concluidas',
                  ),
                );
              } else {
                return _createDataTable();
              }
            }),
          ),
        ));
  }

  Widget _createDataTable() {
    return ListView(children: [
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: _createColumns(),
            rows: _createRows(),
            sortColumnIndex: _sortColumn,
            sortAscending: isAscd,
          )),
      const Text(
        'OBS: Essas são as rotas que foram cadastradas a pouco e que estão esperando cadastro do manifesto',
        style: TextStyle(fontSize: 14),
      ),
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Edit')),
      const DataColumn(label: Text('Delete')),
      DataColumn(
          label: const Text('Data'),
          onSort: (indexValue, _) {
            setState(() {
              _sortColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareToDate(a['data'], b['data']));
              } else {
                _rotas.sort((a, b) => compareToDate(b['data'], a['data']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Rota'),
          onSort: (indexValue, _) {
            setState(() {
              _sortColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(b['Rota'], a['Rota']));
              } else {
                _rotas.sort((a, b) => compareTo(a['Rota'], b['Rota']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Destino'),
          onSort: (indexValue, _) {
            setState(() {
              _sortColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(a['Destino'], b['Destino']));
              } else {
                _rotas.sort((a, b) => compareTo(b['Destino'], a['Destino']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Placa'),
          onSort: (indexValue, _) {
            setState(() {
              _sortColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(b['placa'], a['placa']));
              } else {
                _rotas.sort((a, b) => compareTo(a['placa'], b['placa']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Nome do motorista'),
          onSort: (indexValue, _) {
            setState(() {
              _sortColumn = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) =>
                    compareTo(a['Nome do motorista'], b['Nome do motorista']));
              } else {
                _rotas.sort((a, b) =>
                    compareTo(b['Nome do motorista'], a['Nome do motorista']));
              }
              isAscd = !isAscd;
            });
          }),
      const DataColumn(label: Text('Contato Motorista')),
      const DataColumn(label: Text('Ver mais')),
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'data': element.dataEmissao,
        'Rota': element.codigoRota,
        'placa': element.placaCaminhao,
        'Destino': element.destinoRota,
        'Nome do motorista': element.nomeMotorista,
        'Contato Motorista': element.numeroCelularMotorista,
        'Responsável interno': element.nomeResponsavelInterno,
        'Contato responsável interno': element.contatoResponsavelInterno,
        'Gerente externo': element.nomeGerenteExterno,
        'Contato gerente externo': element.contatoGerenteExterno,
        'Despesas': element.despesasRota.toString(),
        'Valor': element.valorRota.toString(),
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
          DataCell(Text(rotas['data'] ?? '')),
          DataCell(Text(rotas['Rota'] ?? '')),
          DataCell(Text(rotas['Destino'] ?? '')),
          DataCell(Text(rotas['placa'] ?? '')),
          DataCell(Text(rotas['Nome do motorista'] ?? '')),
          DataCell(Text(rotas['Contato Motorista'] ?? '')),
          DataCell(viewInfo(int.parse(rotas['id']))),
        ],
      );
    }).toList();
  }

  Widget viewInfo(int id) {
    return IconButton(
        onPressed: () async {
          Rotas rota = Rotas();
          _apiResponse.data.forEach((element) {
            if(element.id == id) {
              rota = element;
              return;
            }
          });
          await showDialog<bool>(
            builder: (_) => CustomAlertDialog(
                const Text(''),
                Text(rota != null ? 'identidade do motorista: ${rota.identidadeMotorista.isNotEmpty ? rota.identidadeMotorista : 'Vázio'}\n'
                        'Cpf do motorista: ${rota.cpfMotorista.isNotEmpty ? rota.cpfMotorista : 'Vázio'}\n\n'
                        'Número de romaneio: ${rota.numeroRomaneio.isNotEmpty ? rota.numeroRomaneio : 'Vázio'}\n\n'
                        'Responsável interno: ${rota.nomeResponsavelInterno}\n'
                        'Contato responsável: ${rota.contatoResponsavelInterno}\n\n'
                        'Gerente externo: ${rota.nomeGerenteExterno}\n'
                        'Contato gerente: ${rota.contatoGerenteExterno}\n\n' +
                    (instanceHttp.cargo == 'Administrador'
                        ? 'Despesas: ${rota.despesasRota}\n'
                            'Valor: ${rota.valorRota}'
                        : '') : 'Error na busca de informação, rota corrompida'),
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
    _apiResponse.data.forEach((element) {
      if(element.id == id) {
       rota = element;
      }
    });
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => MultiForm(rota)))
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
                  const Text('Gostaria de deletar essa rota?'),
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
            await instance.deleteRota(id, instanceHttp.token);
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
