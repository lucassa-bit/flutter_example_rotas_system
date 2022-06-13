import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/components/cadastrar_rotas/multi_form.dart';
import 'package:cadastrorotas/components/image_dialog.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/arquivo_service.dart';
import 'package:cadastrorotas/services/rotas_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

class MostrarRotasConcluidas extends StatefulWidget {
  const MostrarRotasConcluidas({Key? key}) : super(key: key);

  @override
  State<MostrarRotasConcluidas> createState() => _MostrarRotasConcluidasState();
}

class _MostrarRotasConcluidasState extends State<MostrarRotasConcluidas> {
  var format = DateFormat('dd/MM/yyyy');
  var dataInicial = DateTime.now().subtract(const Duration(days: 7));
  var dataFinal = DateTime.now();
  String filename = '';

  late APIResponse<List<Rotas>> _apiResponse;
  List<String> valores = [];
  List<Map> _rotas = [];

  int _columnSort = 0;

  bool isLoading = false;
  bool isAscd = true;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  arquivoService get instancePhoto => GetIt.instance<arquivoService>();
  rotasService get instance => GetIt.instance<rotasService>();
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
    _apiResponse = await instance.getRotasConcluidas(instanceHttp.token,
        format.format(dataInicial), format.format(dataFinal));
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
          title: const Text('Rotas concluidas'),
          actions: [
            IconButton(
                icon: const Icon(Icons.date_range_rounded),
                onPressed: () {
                  showDateRangePicker(
                    helpText: 'Escolha o período de emissões de rotas',
                    context: context,
                    initialDateRange:
                        DateTimeRange(start: dataInicial, end: dataFinal),
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2222),
                  ).then((value) async {
                    if (value != null) {
                      dataInicial = value.start;
                      dataFinal = value.end;
                    }
                    await _fetchRotas();
                  });
                })
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
                  message: 'Sem rotas no periodo escolhido',
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
            sortAscending: isAscd,
            sortColumnIndex: _columnSort,
          )),
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Edit')),
      const DataColumn(label: Text('Delete')),
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
      DataColumn(
          label: const Text('Número manifesto'),
          onSort: (indexValue, _) {
            setState(() {
              _columnSort = indexValue;
              if (isAscd) {
                _rotas.sort((a, b) =>
                    compareTo(b['numeroManifesto'], a['numeroManifesto']));
              } else {
                _rotas.sort((a, b) =>
                    compareTo(a['numeroManifesto'], b['numeroManifesto']));
              }
              isAscd = !isAscd;
            });
          }),
      const DataColumn(label: Text('Foto')),
      const DataColumn(label: Text('Ver mais')),
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'DataEmissao': element.dataEmissao,
        'DataChegada': element.dataChegada,
        'horaInicio': element.horaInicio,
        'horaFim': element.horaFim,
        'placa': element.placaCaminhao,
        'Rota': element.codigoRota,
        'Destino': element.destinoRota,
        'Número manifesto': element.numeroManifesto,
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
          DataCell(Text(rotas['DataEmissao'] ?? '')),
          DataCell(Text(rotas['DataChegada'] ?? '')),
          DataCell(Text(rotas['horaInicio'] ?? '')),
          DataCell(Text(rotas['horaFim'] ?? '')),
          DataCell(Text(rotas['placa'] ?? '')),
          DataCell(Text(rotas['Rota'] ?? '')),
          DataCell(Text(rotas['Destino'] ?? '')),
          DataCell(Text(rotas['Número manifesto'] ?? '')),
          DataCell(photoShow(int.parse(rotas['id']))),
          DataCell(viewInfo(int.parse(rotas['id']))),
        ],
      );
    }).toList();
  }

  Widget viewInfo(int id) {
    Rotas rota = Rotas();
    for (var element in _apiResponse.data) {
      if (element.id == id) {
        rota = element;
        break;
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
                        'Contato do motorista: ${rota.numeroCelularMotorista.isNotEmpty ? rota.numeroCelularMotorista : 'Sem contato'}\n'
                        'Identidade do motorista: ${rota.identidadeMotorista.isNotEmpty ? rota.identidadeMotorista : 'Vázio'}\n'
                        'Cpf do motorista: ${rota.cpfMotorista.isNotEmpty ? rota.cpfMotorista : 'Vázio'}\n'
                        'Pix do motorista: ${rota.pixMotorista.isNotEmpty ? rota.pixMotorista : 'Vázio'}\n\n'
                        'Responsável interno: ${rota.nomeResponsavelInterno}\n'
                        'Contato do responsável interno: ${rota.contatoResponsavelInterno.isNotEmpty ? rota.contatoResponsavelInterno : 'Sem contato'}\n'
                        'Identidade do responsável interno: ${rota.identidadeResponsavelInterno.isNotEmpty ? rota.identidadeResponsavelInterno : 'Vázio'}\n'
                        'Cpf do responsável interno: ${rota.cpfResponsavelInterno.isNotEmpty ? rota.cpfResponsavelInterno : 'Vázio'}\n'
                        'Pix do responsável interno: ${rota.pixResponsavelInterno.isNotEmpty ? rota.pixResponsavelInterno : 'Vázio'}\n\n'
                        'Gerente externo: ${rota.nomeGerenteExterno}\n'
                        'Contato do gerente externo: ${rota.contatoGerenteExterno.isNotEmpty ? rota.contatoGerenteExterno : 'Sem contato'}\n'
                        'Identidade do gerente externo: ${rota.identidadeGerenteExterno.isNotEmpty ? rota.identidadeGerenteExterno : 'Vázio'}\n'
                        'Cpf do gerente externo: ${rota.cpfGerenteExterno.isNotEmpty ? rota.cpfGerenteExterno : 'Vázio'}\n'
                        'Pix do gerente externo: ${rota.pixGerenteExterno.isNotEmpty ? rota.pixGerenteExterno : 'Vázio'}\n\n'
                        'Despesas: ${rota.despesasRota}\n'
                        'Valor: ${rota.valorRota}\n'
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
                                final file = io.File('$dir${ref.name}');

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
                              anchorElement.download = await ref.getDownloadURL();
                              anchorElement.click();
                              anchorElement.remove();
                            }
                          },
                          icon: const Icon(Icons.download_sharp)),
                    TextButton(
                        onPressed: () {
                          if (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.android) {
                            Navigator.of(context, rootNavigator: true).pop();
                            _showPicker(context, id);
                          } else {
                            Navigator.of(context, rootNavigator: true).pop();
                            imgFromGallery(id);
                          }
                        },
                        child: const Text('Mudar imagem')),
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

  void _showPicker(context, int id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Galeria'),
                    onTap: () {
                      imgFromGallery(id);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Câmera'),
                  onTap: () {
                    imgFromCamera(id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future imgFromGallery(int id) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        instancePhoto.uploadImagem(pickedFile.path, id, pickedFile.name);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future imgFromCamera(int id) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        instancePhoto.uploadImagem(pickedFile.path, id, pickedFile.name);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Widget editInfo(int id) {
    Rotas rota = Rotas();
    _apiResponse.data.forEach((element) {
      if (element.id == id) {
        rota = element;
        return;
      }
    });
    return IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MultiForm(rota)))
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
          filename = '';
          if (response != null && response) {
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
          setStateIfMounted(() {
            isLoading = false;
          });
        },
        icon: const Icon(Icons.delete));
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
