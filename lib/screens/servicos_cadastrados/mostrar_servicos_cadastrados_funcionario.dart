import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:cadastrorotas/components/alert_dialog.dart';
import 'package:cadastrorotas/components/background.dart';
import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/editar_manifesto.dart';
import 'package:cadastrorotas/models/empty_state.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/arquivo_service.dart';
import 'package:cadastrorotas/services/rotas_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

import '../../components/image_dialog.dart';

class mostrarCadastrarManifesto extends StatefulWidget {
  const mostrarCadastrarManifesto({Key? key}) : super(key: key);

  @override
  State<mostrarCadastrarManifesto> createState() =>
      _mostrarCadastrarManifestoState();
}

class _mostrarCadastrarManifestoState extends State<mostrarCadastrarManifesto> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late APIResponse<List<Rotas>> _apiResponse;
  late firebase_storage.ListResult results;

  List<String> manifestos = [];
  List<String?> arquivos = [];
  List<String?> nomeArquivos = [];
  List<bool> hasArquivos = [];
  List<String> linkArquivos = [];
  List<Map> _rotas = [];

  bool isLoading = false;
  bool? _isEditMode = false;

  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> dataController = [];
  List<TextEditingController> horasInicio = [];
  List<TextEditingController> horasFim = [];

  final ImagePicker _picker = ImagePicker();

  arquivoService get instancePhoto => GetIt.instance<arquivoService>();

  rotasService get instance => GetIt.instance<rotasService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  @override
  void initState() {
    _fetchRotas();
    super.initState();
  }

  _fetchRotas() async {
    _rotas = [];
    manifestos = [];
    horasInicio = [];
    horasFim = [];
    arquivos = [];
    hasArquivos = [];
    linkArquivos = [];
    nomeArquivos = [];

    setStateIfMounted(() {
      isLoading = true;
    });

    results = await storage.ref('').listAll();
    _apiResponse = await instance.getRotasForResponsavel(
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
        floatingActionButton: _rotas.isNotEmpty && _isEditMode!
            ? FloatingActionButton(
                onPressed: () {
                  postAprovados();
                },
                child: const Icon(Icons.save),
                backgroundColor: Colors.green,
              )
            : null,
        appBar: AppBar(
          title: const Text('Cadastro manifesto'),
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
                message: 'error na busca das rotas, contate o desenvolvedor',
              ));
            }
            if (_rotas.isEmpty) {
              return Center(
                child: EmptyState(
                  title: 'Vázia',
                  message: 'Sem rotas para serem cadastradas',
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
      _createCheckboxField(),
      const Text(
        'Como usar: Para cadastrar o manifesto, no formulário acima passe para '
        'a direita até, encontrar a linha dos dados do manifesto.'
        '\nApós isso, clique no quadrado de editar, para ativar a edição, '
        'a partir disso você poderá adicionar os valores, clicando na linha '
        'abaixo do manifesto.\nPara Salvar, após cadastrar os manifestos, clique '
        'no botão abaixo',
        style: TextStyle(fontSize: 14),
      ),
    ]);
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Data de emissão')),
      const DataColumn(label: Text('Data de chegada')),
      const DataColumn(label: Text('Hora de início')),
      const DataColumn(label: Text('Hora de finalização')),
      const DataColumn(label: Text('Placa')),
      const DataColumn(label: Text('Rota')),
      const DataColumn(label: Text('Destino')),
      const DataColumn(label: Text('Número manifesto')),
      const DataColumn(label: Text('Foto')),
      const DataColumn(label: Text('Ver mais')),
    ];
  }

  void fillRotas() {
    for (var element in _apiResponse.data) {
      _rotas.add({
        'id': element.id.toString(),
        'data': element.dataEmissao,
        'placa': element.placaCaminhao,
        'Rota': element.codigoRota,
        'Destino': element.destinoRota,
        'Nome do motorista': element.nomeMotorista,
        'Contato Motorista': element.numeroCelularMotorista,
        'Gerente externo': element.nomeGerenteExterno,
        'Contato gerente externo': element.contatoGerenteExterno,
      });
      dataController.add(TextEditingController(text: element.dataChegada));
      manifestos.add(element.numeroManifesto);
      horasInicio.add(TextEditingController(text: element.horaInicio));
      horasFim.add(TextEditingController(text: element.horaFim));
      bool hasImage = false;
      for (var valueItem in results.items) {
        if (element.id == pickId(valueItem.name)) {
          linkArquivos.add(valueItem.name);
          hasImage = true;
        }
      }
      if (!hasImage) linkArquivos.add('');
      hasArquivos.add(hasImage);
      arquivos.add(null);
      nomeArquivos.add(null);
    }
  }

  List<DataRow> _createRows() {
    return _rotas.mapIndexed((index, rotas) {
      return DataRow(
        cells: [
          DataCell(Text(rotas['data'])),
          _createDataChegadaCell(index),
          _createHoraInicioCell(index),
          _createHoraFimCell(index),
          DataCell(Text(rotas['placa'])),
          DataCell(Text(rotas['Rota'])),
          DataCell(Text(rotas['Destino'])),
          _createManifestoCell(index),
          DataCell(photoUpload(_apiResponse.data[index].id, index)),
          DataCell(viewInfo(_apiResponse.data[index]))
        ],
      );
    }).toList();
  }

  DataCell _createManifestoCell(int index) {
    return DataCell(_isEditMode == true
        ? TextFormField(
            initialValue: manifestos[index],
            onChanged: (valor) {
              manifestos[index] = valor;
            },
            style: const TextStyle(fontSize: 14))
        : Text(manifestos[index]));
  }

  DataCell _createHoraInicioCell(int index) {
    return DataCell(_isEditMode == true
        ? TextFormField(
            controller: horasInicio[index],
            readOnly: true,
            onTap: () async {
              List<String> tempo = horasInicio[index].text.split(":");

              TimeOfDay? tempoSend = await showTimePicker(
                  context: context,
                  helpText: 'Escolha a hora de inicio',
                  initialTime: horasInicio[index].text.isNotEmpty
                      ? TimeOfDay(
                          hour: int.parse(tempo[0]),
                          minute: int.parse(tempo[1]))
                      : TimeOfDay.now());

              if (tempoSend != null) {
                setStateIfMounted(() {
                  horasInicio[index].text =
                      '${tempoSend.hour < 10 ? '0${tempoSend.hour}' : tempoSend.hour}'
                      ':${tempoSend.minute < 10 ? '0${tempoSend.minute}' : tempoSend.minute}:00';
                });
              }
            },
            style: const TextStyle(fontSize: 14))
        : Text(horasInicio[index].text));
  }

  DataCell _createHoraFimCell(int index) {
    return DataCell(_isEditMode == true
        ? TextFormField(
            controller: horasFim[index],
            readOnly: true,
            onTap: () async {
              List<String> tempo = horasFim[index].text.split(":");

              TimeOfDay? tempoSend = await showTimePicker(
                  context: context,
                  helpText: 'Escolha a hora de Finalização',
                  initialTime: horasFim[index].text.isNotEmpty
                      ? TimeOfDay(
                          hour: int.parse(tempo[0]),
                          minute: int.parse(tempo[1]))
                      : TimeOfDay.now());

              if (tempoSend != null) {
                setStateIfMounted(() {
                  horasFim[index].text =
                      '${tempoSend.hour < 10 ? '0${tempoSend.hour}' : tempoSend.hour}'
                      ':${tempoSend.minute < 10 ? '0${tempoSend.minute}' : tempoSend.minute}:00';
                });
              }
            },
            style: const TextStyle(fontSize: 14))
        : Text(horasFim[index].text));
  }

  DataCell _createDataChegadaCell(int index) {
    return DataCell(_isEditMode == true
        ? TextFormField(
            controller: dataController[index],
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  helpText: 'Escolha a data de chegada',
                  context: context,
                  initialDate: dataController[index].text.isNotEmpty
                      ? DateFormat('dd/MM/yyyy')
                          .parse(dataController[index].text)
                      : DateTime.now(),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(pickedDate);

                setStateIfMounted(() {
                  dataController[index].text =
                      formattedDate; //set output date to TextField value.
                });
              }
            },
            style: const TextStyle(fontSize: 14))
        : Text(dataController[index].text));
  }

  Row _createCheckboxField() {
    return Row(
      children: [
        Checkbox(
          value: _isEditMode,
          onChanged: (value) {
            setState(() {
              _isEditMode = value;
              int index = 0;
              while (index < manifestos.length) {
                if (_apiResponse.data[index].numeroManifesto.isEmpty) {
                  manifestos[index] = '';
                }
                if (_apiResponse.data[index].dataChegada.isEmpty) {
                  dataController[index].text = '';
                }
                if (_apiResponse.data[index].horaInicio.isEmpty) {
                  horasInicio[index].text = '';
                }
                if (_apiResponse.data[index].horaFim.isEmpty) {
                  horasFim[index].text = '';
                }
                arquivos[index] = null;
                nomeArquivos[index] = null;
                index++;
              }
            });
          },
        ),
        const Text('Modo de edição'),
      ],
    );
  }

  Widget viewInfo(Rotas rota) {
    return IconButton(
        onPressed: () async {
          await showDialog<bool>(
            builder: (_) => CustomAlertDialog(
                const Text(''),
                Text(
                    'Número de romaneio: ${rota.numeroRomaneio.isNotEmpty ? rota.numeroRomaneio : 'Vázio'}\n\n'
                    'Nome do motorista: ${rota.nomeMotorista}\n'
                    'Contato do motorista: ${rota.numeroCelularMotorista.isNotEmpty ? rota.numeroCelularMotorista : 'Sem contato'}\n'
                    'identidade do motorista: ${rota.identidadeMotorista.isNotEmpty ? rota.identidadeMotorista : 'Vázio'}\n'
                    'Cpf do motorista: ${rota.cpfMotorista.isNotEmpty ? rota.cpfMotorista : 'Vázio'}\n\n'
                    'Gerente externo: ${rota.nomeGerenteExterno}\n'
                    'Contato gerente: ${rota.contatoGerenteExterno}\n'),
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

  void _showPicker(context, int id, int index) {
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
                      imgFromGallery(index);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Câmera'),
                  onTap: () {
                    imgFromCamera(index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget photoUpload(int id, int index) {
    return IconButton(
        onPressed: () async {
          await showDialog<bool>(
            builder: (_) => ImageDialog(
              const Text(''),
              FutureBuilder(
                key: UniqueKey(),
                future: linkArquivos[index].isNotEmpty
                    ? storage.ref(linkArquivos[index]).getDownloadURL()
                    : null,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData ||
                      arquivos[index] != null) {
                    return SizedBox(
                      width: 300,
                      height: 250,
                      child: arquivos[index] == null
                          ? CachedNetworkImage(
                              imageUrl: snapshot.data!,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : defaultTargetPlatform == TargetPlatform.iOS ||
                                  defaultTargetPlatform ==
                                      TargetPlatform.android
                              ? Image.file(
                                  File(arquivos[index]!),
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  arquivos[index]!,
                                  fit: BoxFit.fill,
                                ),
                    );
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
                  if (arquivos[index] != null)
                    IconButton(
                        onPressed: () async {
                          arquivos[index] = null;
                          const snackBar =
                              SnackBar(content: Text('Arquivo apagado'));
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.delete)),
                  if (linkArquivos[index].isNotEmpty)
                    IconButton(
                        onPressed: () async {
                          final ref = storage.ref(linkArquivos[index]);

                          if (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.android) {
                            final status = await Permission.storage.request();
                            if (status.isGranted) {
                              const dir = '/storage/emulated/0/Download/';
                              final file = File('$dir${ref.name}');

                              await ref.writeToFile(file);
                              final snackBar = SnackBar(
                                  content:
                                      Text('Imagem se encontra ${file.path}'));
                              Navigator.of(context, rootNavigator: true).pop();
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
                        icon: const Icon(Icons.download_rounded)),
                  if (_isEditMode!)
                    TextButton(
                      onPressed: () {
                        if (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.android) {
                          Navigator.of(context, rootNavigator: true).pop();
                          _showPicker(context, id, index);
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                          imgFromGallery(index);
                        }
                      },
                      child: const Text('Mudar imagem'),
                    ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('Ok'),
                  )
                ],
              ),
            ),
            context: context,
          );
        },
        icon: const Icon(Icons.upload_outlined));
  }

  Future imgFromGallery(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        arquivos[index] = pickedFile.path;
        nomeArquivos[index] = pickedFile.name;
      }
    });
  }

  Future imgFromCamera(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        arquivos[index] = pickedFile.path;
        nomeArquivos[index] = pickedFile.name;
      }
    });
  }

  void postAprovados() async {
    List<EditarManifesto> sendRotas = [];
    List<String> sendArquivos = [];
    List<String> sendNomesArquivos = [];
    List<String> sendLinkArquivos = [];
    int index = 0;
    while (index < _rotas.length) {
      if (manifestos[index].isNotEmpty &&
          dataController[index].text.isNotEmpty &&
          horasInicio[index].text.isNotEmpty &&
          horasFim[index].text.isNotEmpty) {
        sendRotas.add(EditarManifesto(
            id: int.parse(_rotas[index]['id']),
            numeroManifesto: manifestos[index],
            dataChegada: dataController[index].text,
            horaInicio: horasInicio[index].text,
            horaFim: horasFim[index].text));

        if (arquivos[index] != null && nomeArquivos[index] != null) {
          sendArquivos.add(arquivos[index]!);
          sendNomesArquivos.add(nomeArquivos[index]!);
          sendLinkArquivos.add(linkArquivos[index]);
        }
      }
      index++;
    }

    setStateIfMounted(() {
      isLoading = true;
    });
    bool submit = false;
    await showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
            const Text('Criação dos manifestos'),
            const Text('Gostaria de continuar?'),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  submit = false;
                },
                child: const Text('Não')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  submit = true;
                },
                child: const Text('Sim'))));
    if (submit) {
      var response =
          await instance.updateManifesto(sendRotas, instanceHttp.token);
      if (!response.error && sendArquivos.isNotEmpty) {
        sendArquivos.forEachIndexed((index, element) async {
          if (sendLinkArquivos[index].isNotEmpty) {
            await storage.ref(sendLinkArquivos[index]).delete();
          }
          await instancePhoto.uploadImagem(
              element, sendRotas[index].id, sendNomesArquivos[index]);
        });
      }
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
}
