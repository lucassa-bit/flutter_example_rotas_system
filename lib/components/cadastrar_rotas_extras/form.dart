import 'package:cadastrorotas/options/http_options.dart';
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
  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dataController = TextEditingController();
  TextEditingController dataChegadaController = TextEditingController();
  bool isLoading = false;

  usuariosService get instance => GetIt.instance<usuariosService>();

  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => widget.rotas.id >= 0;

  @override
  void initState() {
    setStateIfMounted(() {
      isLoading = true;
    });
    dataController.text = widget.rotas.dataEmissao;
    dataChegadaController.text = widget.rotas.dataChegada;
    super.initState();
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
                        firstDate: DateTime(2000),
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
                      val != null
                          ? null
                          : 'data de emissão inválida',
                  decoration: const InputDecoration(
                    labelText: 'Data de emissão',
                    hintText: '01/01/2000',
                    icon: Icon(Icons.date_range_rounded),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  controller: dataChegadaController,
                  readOnly: true,
                  onSaved: (val) => widget.rotas.dataChegada = val!,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        helpText: 'Escolha a data de emissão para a rota',
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
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
                  decoration: const InputDecoration(
                    labelText: 'Data de chegada',
                    hintText: '01/01/2000',
                    icon: Icon(Icons.date_range_rounded),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.codigoRota,
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.codigoRota = val!,
                  validator: (val) =>
                      val!.isNotEmpty ? null : 'código de rota inválido',
                  decoration: const InputDecoration(
                    labelText: 'Código rota',
                    hintText: '000',
                    icon: Icon(Icons.assistant_direction),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.placaCaminhao,
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.placaCaminhao = val!,
                  validator: (val) =>
                  val!.isNotEmpty ? null : 'placa informada inválida',
                  decoration: const InputDecoration(
                    labelText: 'Placa do caminhão',
                    hintText: '',
                    icon: Icon(Icons.airport_shuttle),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.destinoRota,
                  onSaved: (val) => widget.rotas.destinoRota = val!,
                  validator: (val) =>
                      val!.isNotEmpty ? null : 'destino da rota inválido',
                  decoration: const InputDecoration(
                    labelText: 'Destino',
                    hintText: '',
                    icon: Icon(Icons.format_align_justify),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.numeroManifesto,
                  onSaved: (val) => widget.rotas.numeroManifesto = val!,
                  validator: (val) => null,
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
                child: TextFormField(
                  initialValue: widget.rotas.numeroRomaneio,
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.numeroRomaneio = val!,
                  decoration: const InputDecoration(
                    labelText: 'Número de romaneio',
                    hintText: '',
                    icon: Icon(Icons.text_snippet_outlined),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.nomeMotorista,
                  onSaved: (val) => widget.rotas.nomeMotorista = val!,
                  validator: (val) => val!.isNotEmpty ? null : 'nome inválido',
                  decoration: const InputDecoration(
                    labelText: 'Nome do motorista',
                    hintText: '',
                    icon: Icon(Icons.person),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.identidadeMotorista,
                  onSaved: (val) => widget.rotas.identidadeMotorista = val!,
                  decoration: const InputDecoration(
                    labelText: 'Identidade do motorista',
                    hintText: '',
                    icon: Icon(Icons.group),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  initialValue: widget.rotas.cpfMotorista,
                  onSaved: (val) => widget.rotas.cpfMotorista = val!,
                  decoration: const InputDecoration(
                    labelText: 'Cpf do motorista',
                    hintText: '',
                    icon: Icon(Icons.featured_video_outlined),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.pixMotorista,
                  onSaved: (val) => widget.rotas.pixMotorista = val!,
                  decoration: const InputDecoration(
                    labelText: 'Pix do motorista',
                    hintText: '',
                    icon: Icon(Icons.pix),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  initialValue: widget.rotas.numeroCelularMotorista,
                  onSaved: (val) => widget.rotas.numeroCelularMotorista = val!,
                  decoration: const InputDecoration(
                    labelText: 'Contato do motorista',
                    hintText: 'digite o telefone do motorista',
                    icon: Icon(Icons.phone_android),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.valorRota > 0
                      ? widget.rotas.valorRota.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.valorRota =
                      double.tryParse(val!.replaceAll(",", "."))!,
                  validator: (val) =>
                      double.tryParse(val!.replaceAll(",", ".")) != null
                          ? null
                          : 'valor da rota inválido',
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    hintText: '0,00',
                    icon: Icon(Icons.account_balance),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.despesasRota > 0
                      ? widget.rotas.despesasRota.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.despesasRota =
                      double.tryParse(val!.replaceAll(",", "."))!,
                  validator: (val) =>
                      double.tryParse(val!.replaceAll(",", ".")) != null
                          ? null
                          : 'despesa inválida',
                  decoration: const InputDecoration(
                    labelText: 'Despesas',
                    hintText: '0,00',
                    icon: Icon(Icons.account_balance_wallet_rounded),
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
    if (valid != null && valid) {
      form.currentState?.save();
    } else {
      return false;
    }
    return valid;
  }

  void setStateIfMounted(Null Function() param0) {
    if(mounted) setState(param0);
  }
}
