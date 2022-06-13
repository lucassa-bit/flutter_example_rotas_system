import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/image_dialog.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/models/to_aprove.dart';
import 'package:cadastrorotas/models/to_aprove_list.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/rotas_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

class mostrarAprovarRota extends StatefulWidget {
  const mostrarAprovarRota({Key? key}) : super(key: key);

  @override
  State<mostrarAprovarRota> createState() => _mostrarAprovarRotaState();
}

class _mostrarAprovarRotaState extends State<mostrarAprovarRota> {
  late APIResponse<List<Rotas>> _apiResponse;
  bool isLoading = false;
  bool selectAll = false;
  bool isAscd = true;
  int _columnSort = 0;
  List<Map> _rotas = [];
  List<bool> _selected = [];
  List<bool> _revise = [];
  rotasService get instance => GetIt.instance<rotasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();
  String filename = '';

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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
    _selected = [];
    _revise = [];
    _apiResponse = await instance.getRotasForGerente(
        instanceHttp.token, int.parse(instanceHttp.id));
    fillRotas();

    setStateIfMounted(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aprovação rotas'),
          actions: [
            if (_rotas.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    postAprovados();
                  },
                ),
              ),
          ],
        ),
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
                message: 'error na aprovação da rota, contate o desenvolvedor',
              ));
            }
            if (_rotas.isEmpty) {
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
          child: DataTable(
            columns: _createColumns(),
            rows: _createRows(),
            sortColumnIndex: _columnSort,
            sortAscending: isAscd,
          ))
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: checkboxSelectAll()),
      DataColumn(
          label: const Text('Data de emissão'),
          onSort: (indexValue, _) {
            setState(() {
              _columnSort = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareToDate(b['data'], a['data']));
              } else {
                _rotas.sort((a, b) => compareToDate(a['data'], b['data']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Data de chegada'),
          onSort: (indexValue, _) {
            setState(() {
              _columnSort = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) =>
                    compareToDate(b['dataChegada'], a['dataChegada']));
              } else {
                _rotas.sort((a, b) =>
                    compareToDate(a['dataChegada'], b['dataChegada']));
              }
              isAscd = !isAscd;
            });
          }),
      const DataColumn(label: Text('Hora de início')),
      const DataColumn(label: Text('Hora de finalização')),
      DataColumn(
          label: const Text('Placa'),
          onSort: (indexValue, _) {
            setState(() {
              _columnSort = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(b['placa'], a['placa']));
              } else {
                _rotas.sort((a, b) => compareTo(a['placa'], b['placa']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Motorista'),
          onSort: (indexValue, _) {
            setState(() {
              _columnSort = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) =>
                    compareTo(b['Nome do motorista'], a['Nome do motorista']));
              } else {
                _rotas.sort((a, b) =>
                    compareTo(a['Nome do motorista'], b['Nome do motorista']));
              }
              isAscd = !isAscd;
            });
          }),
      DataColumn(
          label: const Text('Rota'),
          onSort: (indexValue, _) {
            setState(() {
              _columnSort = indexValue;
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
              _columnSort = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) => compareTo(b['Destino'], a['Destino']));
              } else {
                _rotas.sort((a, b) => compareTo(a['Destino'], b['Destino']));
              }
              isAscd = !isAscd;
            });
          }),
      const DataColumn(label: Text('Número manifesto')),
      const DataColumn(label: Text('Foto')),
      const DataColumn(label: Text('Ver mais')),
      const DataColumn(label: Text('Deletar'))
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'data': element.dataEmissao,
        'dataChegada': element.dataChegada,
        'horaInicio': element.horaInicio,
        'horaFim': element.horaFim,
        'placa': element.placaCaminhao,
        'Rota': element.codigoRota,
        'Destino': element.destinoRota,
        'Número manifesto': element.numeroManifesto,
        'Nome do motorista': element.nomeMotorista,
        'Contato Motorista': element.numeroCelularMotorista,
      });
      _selected.add(false);
      _revise.add(false);
    }
  }

  List<DataRow> _createRows() {
    return _rotas.mapIndexed((index, rotas) {
      return DataRow(
          cells: [
            DataCell(checkbox(index)),
            DataCell(Text(rotas['data'] ?? '')),
            DataCell(Text(rotas['dataChegada'] ?? '')),
            DataCell(Text(rotas['horaInicio'] ?? '')),
            DataCell(Text(rotas['horaFim'] ?? '')),
            DataCell(Text(rotas['placa'] ?? '')),
            DataCell(Text(rotas['Nome do motorista'] ?? '')),
            DataCell(Text(rotas['Rota'] ?? '')),
            DataCell(Text(rotas['Destino'] ?? '')),
            DataCell(Text(rotas['Número manifesto'] ?? '')),
            DataCell(photoShow(int.parse(rotas['id']))),
            DataCell(viewInfo(int.parse(rotas['id']))),
            DataCell(deleteInfo(int.parse(rotas['id'])))
          ],
          selected: _selected[index],
          onSelectChanged: (bool? selected) {
            setStateIfMounted(() {
              selectAll = false;
              if (selected!) {
                _selected[index] = selected;
                _revise[index] = !selected;
              } else if (!selected) {
                _selected[index] = selected;
              }
            });
          });
    }).toList();
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
          if (response != null && response) {
            setStateIfMounted(() {
              isLoading = true;
            });
            filename = '';
            (await storage.ref('').listAll())
                .items
                .forEachIndexed((indexValue, element) {
              if (id == pickId(element.name)) {
                filename = element.name;
                return;
              }
            });
            await instance.deleteRota(id, instanceHttp.token);
            if (filename.isNotEmpty) {
              await storage.ref(filename).delete();
            }
            await _fetchRotas();
          }
        },
        icon: const Icon(Icons.delete));
  }

  Widget checkboxSelectAll() {
    return Checkbox(
      checkColor: Colors.white,
      activeColor: Colors.red,
      value: selectAll,
      onChanged: (bool? value) {
        setStateIfMounted(() {
          selectAll = value!;
          int index = 0;

          if (value) {
            while (index < _revise.length) {
              _revise[index] = value;
              _selected[index] = !value;
              index++;
            }
          } else {
            while (index < _revise.length) {
              _revise[index] = value;
              index++;
            }
          }
        });
      },
    );
  }

  Widget checkbox(int index) {
    return Checkbox(
      checkColor: Colors.white,
      activeColor: Colors.red,
      value: _revise[index],
      onChanged: (bool? value) {
        setStateIfMounted(() {
          if (value!) {
            _revise[index] = value;
            _selected[index] = !value;
          } else if (!value) {
            _revise[index] = value;
          }

          int check = 0;
          for (var element in _revise) {
            if (element) check++;
          }
          if (check == _revise.length) {
            selectAll = true;
          } else if (check != _revise.length) {
            selectAll = false;
          }
        });
      },
    );
  }

  Widget viewInfo(int id) {
    Rotas rota = Rotas();
    for (var element in _apiResponse.data) {
      if (element.id == id) {
        rota = element;
        continue;
      }
    }
    return IconButton(
        onPressed: () async {
          await showDialog<bool>(
            builder: (_) => CustomAlertDialog(
                const Text(''),
                Text(rota != null
                    ? 'Número de romaneio: ${rota.numeroRomaneio.isNotEmpty ? rota.numeroRomaneio : 'Vázio'}\n\n'
                            'Nome do motorista: ${rota.nomeMotorista}\n'
                            'Identidade do motorista: ${rota.identidadeMotorista.isNotEmpty ? rota.identidadeMotorista : 'Vázio'}\n'
                            'Cpf do motorista: ${rota.cpfMotorista.isNotEmpty ? rota.cpfMotorista : 'Vázio'}\n'
                            'Contato do motorista: ${rota.numeroCelularMotorista.isNotEmpty ? rota.numeroCelularMotorista : 'Sem contato'}\n\n'
                            'Responsável interno: ${rota.nomeResponsavelInterno}\n'
                            'Contato responsável: ${rota.contatoResponsavelInterno}\n\n'
                            'Gerente externo: ${rota.nomeGerenteExterno}\n'
                            'Contato gerente: ${rota.contatoGerenteExterno}\n\n' +
                        (instanceHttp.cargo == 'Administrador'
                            ? 'Despesas: ${rota.despesasRota}\n'
                                'Valor: ${rota.valorRota}'
                            : '')
                    : 'Error na busca de informação, rota corrompida'),
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

  Widget photoShow(int id) {
    return IconButton(
        onPressed: () async {
          filename = '';
          (await storage.ref('').listAll())
              .items
              .forEachIndexed((index, element) {
            if (id == pickId(element.name)) {
              filename = element.name;
              return;
            }
          });
          await showDialog<bool>(
            builder: (_) {
              return ImageDialog(
                const Text(''),
                FutureBuilder(
                  future: storage.ref(filename).getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return SizedBox(
                          width: 300,
                          height: 250,
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return const Center(child: Text('Sem foto'));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (filename.isNotEmpty)
                      IconButton(
                          onPressed: () async {
                            final ref = storage.ref(filename);

                            if (defaultTargetPlatform == TargetPlatform.iOS ||
                                defaultTargetPlatform ==
                                    TargetPlatform.android) {
                              final status = await Permission.storage.request();
                              if (status.isGranted) {
                                const dir = '/storage/emulated/0/Download/';
                                final file = File('$dir${ref.name}');

                                await ref.writeToFile(file);
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Imagem se encontra ${file.path}'));
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } else {
                              html.AnchorElement anchorElement =
                                  html.AnchorElement(
                                      href: await ref.getDownloadURL());
                              anchorElement.target = "blank";
                              anchorElement.download =
                                  await ref.getDownloadURL();
                              anchorElement.click();
                              anchorElement.remove();
                            }
                          },
                          icon: const Icon(Icons.download_sharp)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text('Ok'),
                    )
                  ],
                ),
              );
            },
            context: context,
          );
        },
        icon: const Icon(Icons.photo));
  }

  void postAprovados() async {
    toAproveList aprovar = toAproveList(listaToAprove: []);
    int index = 0;
    while (index < _rotas.length) {
      aprovar.listaToAprove.add(
        toAprove(
            id: int.parse(_rotas[index]['id']),
            isAprovado: _selected[index],
            isOkayToAprove: !_revise[index]),
      );
      index++;
    }
    setStateIfMounted(() {
      isLoading = true;
    });
    bool submit = false;
    await showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
            const Text('Confirmação da aprovação'),
            const Text('Gostaria de continuar?'),
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
      var response = await instance.aprovarRota(instanceHttp.token, aprovar);

      if (response.error) {
        await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                const Text('Erro na aprovação das rotas'),
                const Text(
                    'As rotas não foram aprovadas, tente novamente mais tarde'),
                TextButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('ok'))));
      } else {
        await showDialog(
            context: context,
            builder: (_) => CustomAlertDialog(
                (const Text('Rotas aprovadas')),
                const Text('As rotas escolhidas foram aprovadas com sucesso'),
                TextButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('ok'))));
        await _fetchRotas();
      }
    }

    setStateIfMounted(() {
      isLoading = false;
    });
  }

  void setStateIfMounted(Null Function() param0) {
    if (mounted) setState(param0);
  }

  int pickId(String pathname) {
    List<String> novoValor = pathname.substring(5).split(".");
    return int.parse(novoValor[0]);
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
