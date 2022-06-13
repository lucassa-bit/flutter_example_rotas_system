import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/caminhao.dart';
import 'package:cadastrorotas/models/motorista.dart';
import 'package:cadastrorotas/models/numero_rotas.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/caminhao_service.dart';
import 'package:cadastrorotas/services/motorista_service.dart';
import 'package:cadastrorotas/services/numero_rota_service.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

typedef OnDelete = Function();

class RotasForm extends StatefulWidget {
  final Rotas rotas;
  final state = _RotasFormState();
  final OnDelete onDelete;

  RotasForm({Key? key, required this.rotas, required this.onDelete})
      : super(key: key);
  @override
  _RotasFormState createState() => state;

  bool isValid() => state.validate();
}

class _RotasFormState extends State<RotasForm> {
  APIResponse<List<Usuario>>? _apiResponse;
  APIResponse<List<Motorista>>? _apiResponseMotorista;
  APIResponse<List<NumeroRotas>>? _apiResponseNumeroRota;
  APIResponse<List<Caminhao>>? _apiResponseCaminhao;

  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dataController = TextEditingController();
  TextEditingController dataChegadaController = TextEditingController();
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController horaFimController = TextEditingController();
  TextEditingController despesaController = TextEditingController();
  TextEditingController valorController = TextEditingController();

  final List<bool> _isOpen = [false, false, false, false];
  var usuarioIdGroup = [-1, -1, -1, -1];
  bool isLoading = false;

  usuariosService get instance => GetIt.instance<usuariosService>();
  caminhaoService get instanceCaminhao => GetIt.instance<caminhaoService>();
  motoristaService get instanceMotorista => GetIt.instance<motoristaService>();
  numeroRotasService get instanceNumeroRotas =>
      GetIt.instance<numeroRotasService>();

  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => widget.rotas.id >= 0;

  @override
  void initState() {
    setStateIfMounted(() {
      isLoading = true;
    });

    _fetchUsuarios();
    dataController.text = widget.rotas.dataEmissao;
    dataChegadaController.text = widget.rotas.dataChegada;
    horaInicioController.text = widget.rotas.horaInicio;
    horaFimController.text = widget.rotas.horaFim;
    despesaController.text = widget.rotas.despesasRota.toString();
    valorController.text = widget.rotas.valorRota.toString();
    super.initState();
  }

  _fetchUsuarios() async {
    usuarioIdGroup[0] = widget.rotas.idNumeroRota;
    usuarioIdGroup[1] = widget.rotas.idMotorista;
    usuarioIdGroup[2] = widget.rotas.responsavelInterno;
    usuarioIdGroup[3] = widget.rotas.idCaminhao;

    _apiResponse = (await instance.getResponsaveisList(instanceHttp.token));
    _apiResponseMotorista =
        (await instanceMotorista.getMotoristas(instanceHttp.token));
    _apiResponseNumeroRota =
        (await instanceNumeroRotas.getNumeroRotas(instanceHttp.token));
    _apiResponseCaminhao =
        await instanceCaminhao.getCaminhoes(instanceHttp.token);

    funcionarios();
    numeroRota();
    motorista();

    setStateIfMounted(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _scaffoldKey,
      padding: const EdgeInsets.all(16),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                leading: const Icon(Icons.verified_user),
                elevation: 0,
                title: const Text('rotas'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  controller: dataController,
                  readOnly: true,
                  onSaved: (val) => widget.rotas.dataEmissao = val!,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        helpText: 'Escolha a data de emissão para a rota',
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);

                      setStateIfMounted(() {
                        dataController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                  validator: (val) =>
                      val != null ? null : 'data de emissão inválida',
                  decoration: const InputDecoration(
                    labelText: 'Data de emissão',
                    hintText: '01/01/2000',
                    icon: Icon(Icons.date_range_rounded),
                    isDense: true,
                  ),
                ),
              ),
              if (isEditting && widget.rotas.numeroManifesto.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    controller: dataChegadaController,
                    readOnly: true,
                    onSaved: (val) => widget.rotas.dataChegada = val!,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);

                        setStateIfMounted(() {
                          dataChegadaController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                    validator: (val) =>
                        val != null ? null : 'data de chegada inválida',
                    decoration: const InputDecoration(
                      labelText: 'Data de chegada',
                      hintText: '01/01/2000',
                      icon: Icon(Icons.date_range_outlined),
                      isDense: true,
                    ),
                  ),
                ),
              if (isEditting && widget.rotas.numeroManifesto.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    controller: horaInicioController,
                    readOnly: true,
                    onSaved: (val) => widget.rotas.horaInicio = val!,
                    onTap: () async {
                      List<String> tempo = horaInicioController.text.split(":");

                      TimeOfDay? tempoSend = await showTimePicker(
                          context: context,
                          helpText: 'Escolha a hora de início',
                          initialTime: horaInicioController.text.isNotEmpty
                              ? TimeOfDay(
                                  hour: int.parse(tempo[0]),
                                  minute: int.parse(tempo[1]))
                              : TimeOfDay.now());

                      if (tempoSend != null) {
                        setStateIfMounted(() {
                          horaInicioController.text =
                              '${tempoSend.hour < 10 ? '0${tempoSend.hour}' : tempoSend.hour}'
                              ':${tempoSend.minute < 10 ? '0${tempoSend.minute}' : tempoSend.minute}:00';
                        });
                      }
                    },
                    validator: (val) =>
                        val != null ? null : 'hora de início inválida',
                    decoration: const InputDecoration(
                      labelText: 'hora de início',
                      hintText: '00:00',
                      icon: Icon(Icons.access_time_rounded),
                      isDense: true,
                    ),
                  ),
                ),
              if (isEditting && widget.rotas.numeroManifesto.isNotEmpty)
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    controller: horaFimController,
                    readOnly: true,
                    onSaved: (val) => widget.rotas.horaFim = val!,
                    onTap: () async {
                      List<String> tempo = horaFimController.text.split(":");

                      TimeOfDay? tempoSend = await showTimePicker(
                          context: context,
                          helpText: 'Escolha a hora de início',
                          initialTime: horaFimController.text.isNotEmpty
                              ? TimeOfDay(
                              hour: int.parse(tempo[0]),
                              minute: int.parse(tempo[1]))
                              : TimeOfDay.now());

                      if (tempoSend != null) {
                        setStateIfMounted(() {
                          horaFimController.text =
                          '${tempoSend.hour < 10 ? '0${tempoSend.hour}' : tempoSend.hour}'
                              ':${tempoSend.minute < 10 ? '0${tempoSend.minute}' : tempoSend.minute}:00';
                        });
                      }
                    },
                    validator: (val) =>
                    val != null ? null : 'hora de finalização inválida',
                    decoration: const InputDecoration(
                      labelText: 'hora de fim',
                      hintText: '00:00',
                      icon: Icon(Icons.access_time_rounded),
                      isDense: true,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.numeroRomaneio,
                  keyboardType: TextInputType.text,
                  onSaved: (val) => widget.rotas.numeroRomaneio = val!,
                  decoration: const InputDecoration(
                    labelText: 'Número de romaneio',
                    hintText: '',
                    icon: Icon(Icons.text_snippet_outlined),
                    isDense: true,
                  ),
                ),
              ),
              if (isEditting && widget.rotas.numeroManifesto.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    initialValue: widget.rotas.numeroManifesto,
                    keyboardType: TextInputType.text,
                    onSaved: (val) => widget.rotas.numeroManifesto = val!,
                    decoration: const InputDecoration(
                      labelText: 'Número do manifesto',
                      hintText: '',
                      icon: Icon(Icons.assignment),
                      isDense: true,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: ExpansionPanelList(
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isOpen) {
                          return const Center(
                            child: Text(
                              'Número rotas',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                        body: numeroRota(),
                        canTapOnHeader: true,
                        isExpanded: _isOpen[0],
                      )
                    ],
                    expansionCallback: (i, isOpen) => {
                          if (mounted) setState(() => _isOpen[i] = !isOpen),
                        }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: ExpansionPanelList(
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isOpen) {
                          return const Center(
                            child: Text(
                              'Motorista',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                        body: motorista(),
                        canTapOnHeader: true,
                        isExpanded: _isOpen[1],
                      )
                    ],
                    expansionCallback: (i, isOpen) => {
                          if (mounted) setState(() => _isOpen[1] = !isOpen),
                        }),
              ),
              if (!isEditting ||
                  (isEditting && widget.rotas.numeroManifesto.isEmpty))
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: ExpansionPanelList(
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isOpen) {
                          return const Center(
                            child: Text(
                              'Funcionarios internos',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                        body: funcionarios(),
                        canTapOnHeader: true,
                        isExpanded: _isOpen[2],
                      )
                    ],
                    expansionCallback: (i, isOpen) =>
                        {if (mounted) setState(() => _isOpen[2] = !isOpen)},
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: ExpansionPanelList(
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return const Center(
                          child: Text(
                            'Caminhoes',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                      body: caminhoes(),
                      canTapOnHeader: true,
                      isExpanded: _isOpen[3],
                    ),
                  ],
                  expansionCallback: (i, isOpen) =>
                      {if (mounted) setState(() => _isOpen[3] = !isOpen)},
                ),
              ),
              if (isEditting && instanceHttp.cargo == 'Administrador')
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    controller: despesaController,
                    keyboardType: TextInputType.number,
                    validator: (val) => val != null ? null : 'depesas inválida',
                    onSaved: (val) =>
                        widget.rotas.despesasRota = double.parse(val!),
                    decoration: const InputDecoration(
                      labelText: 'Despesa',
                      hintText: '',
                      icon: Icon(Icons.account_balance),
                      isDense: true,
                    ),
                  ),
                ),
              if (isEditting)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: TextFormField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    onSaved: (val) =>
                        widget.rotas.valorRota = double.parse(val!),
                    validator: (val) => val != null ? null : 'valor inválido',
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      hintText: '',
                      icon: Icon(Icons.account_balance_wallet),
                      isDense: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState?.validate();
    if (valid != null &&
        valid &&
        usuarioIdGroup[0] > 0 &&
        usuarioIdGroup[1] > 0 &&
        usuarioIdGroup[2] > 0 &&
        usuarioIdGroup[3] > 0) {
      returnIndex(usuarioIdGroup[0], 0);
      returnIndex(usuarioIdGroup[1], 1);
      returnIndex(usuarioIdGroup[2], 2);
      returnIndex(usuarioIdGroup[3], 3);

      form.currentState?.save();
    } else {
      return false;
    }
    return valid;
  }

  returnIndex(int value, int index) {
    switch (index) {
      case 0:
        {
          for (var element in _apiResponseNumeroRota!.data) {
            if (value == element.id) {
              widget.rotas.idNumeroRota = element.id;
              widget.rotas.codigoRota = element.codigo;
              widget.rotas.destinoRota = element.destino;
              widget.rotas.valorRota = element.valor;
              widget.rotas.despesasRota = element.despesas;
              return;
            }
          }
          break;
        }
      case 1:
        {
          for (var element in _apiResponseMotorista!.data) {
            if (value == element.id) {
              widget.rotas.idMotorista = element.id;
              widget.rotas.nomeMotorista = element.nome;
              widget.rotas.numeroCelularMotorista = element.contato;
              widget.rotas.pixMotorista = element.pix;
              widget.rotas.identidadeMotorista = element.identidade;
              return;
            }
          }
          break;
        }
      case 2:
        {
          for (var element in _apiResponse!.data) {
            if (value == element.id) {
              widget.rotas.responsavelInterno = element.id;
              return;
            }
          }
          break;
        }
      case 3:
        {
          for (var element in _apiResponseCaminhao!.data) {
            if (value == element.id) {
              widget.rotas.idCaminhao = element.id;
              widget.rotas.placaCaminhao = element.placa;
              return;
            }
          }
          break;
        }
    }
  }

  Widget funcionarios() {
    List<Usuario> listaU = [];
    List<Widget> lista = [];

    if (_apiResponse != null) {
      for (var element in _apiResponse!.data) {
        listaU.add(element);
      }
    }

    for (var element in listaU) {
      lista.add(ListTile(
        title: Text(element.nome.isNotEmpty ? element.nome : ''),
        leading: Radio<int>(
          value: element.id,
          groupValue: usuarioIdGroup[2],
          onChanged: (int? value) {
            if (value != null) setUsuarioGroup(value, 2);
          },
        ),
      ));
    }

    return Column(
      children: lista,
    );
  }

  Widget motorista() {
    List<Motorista> listaU = [];
    List<Widget> lista = [];

    if (_apiResponseMotorista != null) {
      for (var element in _apiResponseMotorista!.data) {
        listaU.add(element);
      }
    }

    for (var element in listaU) {
      lista.add(ListTile(
        title: Text(element.nome),
        leading: Radio<int>(
          value: element.id,
          groupValue: usuarioIdGroup[1],
          onChanged: (int? value) {
            if (value != null) setUsuarioGroup(value, 1);
          },
        ),
      ));
    }

    return Column(
      children: lista,
    );
  }

  Widget numeroRota() {
    List<NumeroRotas> listaU = [];
    List<Widget> lista = [];

    if (_apiResponseNumeroRota != null) {
      for (var element in _apiResponseNumeroRota!.data) {
        listaU.add(element);
      }
    }

    for (var element in listaU) {
      lista.add(ListTile(
        title: Text(element.codigo.isNotEmpty ? element.codigo : ''),
        subtitle: Text(instanceHttp.cargo != "Gerente externo"
            ? 'Destino: ${element.destino}\nValor: ${element.valor}\nDespesas: ${element.despesas}'
            : 'Destino: ${element.destino}\n'),
        leading: Radio<int>(
          value: element.id,
          groupValue: usuarioIdGroup[0],
          onChanged: (int? value) {
            if (value != null) {
              setUsuarioGroup(value, 0);
              despesaController.text = element.despesas.toString();
              valorController.text = element.valor.toString();
            }
          },
        ),
      ));
    }

    return Column(
      children: lista,
    );
  }

  Widget caminhoes() {
    List<Caminhao> listaC = [];
    List<Widget> lista = [];

    if (_apiResponseCaminhao != null) {
      for (var element in _apiResponseCaminhao!.data) {
        listaC.add(element);
      }
    }

    for (var element in listaC) {
      lista.add(ListTile(
        title: Text(element.placa.isNotEmpty ? element.placa : ''),
        leading: Radio<int>(
          value: element.id,
          groupValue: usuarioIdGroup[3],
          onChanged: (int? value) {
            if (value != null) setUsuarioGroup(value, 3);
          },
        ),
      ));
    }

    return Column(
      children: lista,
    );
  }

  void setUsuarioGroup(int user, int index) {
    switch (index) {
      case 0:
        {
          setStateIfMounted(() {
            widget.rotas.idNumeroRota = user;
            usuarioIdGroup[index] = user;
          });
          break;
        }
      case 1:
        {
          setStateIfMounted(() {
            widget.rotas.idMotorista = user;
            usuarioIdGroup[index] = user;
          });
          break;
        }
      case 2:
        {
          setStateIfMounted(() {
            widget.rotas.responsavelInterno = user;
            usuarioIdGroup[index] = user;
          });
          break;
        }
      case 3:
        {
          setStateIfMounted(() {
            widget.rotas.idCaminhao = user;
            usuarioIdGroup[index] = user;
          });
          break;
        }
    }
  }

  void setStateIfMounted(Null Function() param0) {
    if (mounted) setState(param0);
  }
}
