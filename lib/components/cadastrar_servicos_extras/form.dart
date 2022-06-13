import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/servicos_extras.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

typedef OnDelete();

class ServiceForms extends StatefulWidget {
  final ServicosExtras servicosExtras;
  final state = _ServiceFormsState();
  final OnDelete onDelete;

  ServiceForms({Key? key, required this.servicosExtras, required this.onDelete})
      : super(key: key);
  @override
  _ServiceFormsState createState() => state;

  bool isValid() => state.validate();
}

class _ServiceFormsState extends State<ServiceForms> {
  APIResponse<List<Usuario>>? _apiResponse;
  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dataController = TextEditingController();
  List<bool> _isOpen = [false];
  bool isLoading = false;

  usuariosService get instance => GetIt.instance<usuariosService>();
  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

  bool get isEditting => widget.servicosExtras.id >= 0;

  @override
  void initState() {
    dataController.text = widget.servicosExtras.dataEmissao;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _scaffoldKey,
      padding: EdgeInsets.all(16),
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
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('Serviços extras'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  controller: dataController,
                  readOnly: true,
                  onSaved: (val) => widget.servicosExtras.dataEmissao = val!,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        helpText: 'Escolha a data de emissão do serviço',
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
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
                      val != null && widget.servicosExtras.dataEmissao != null
                          ? null
                          : 'data de emissão inválida',
                  decoration: InputDecoration(
                    labelText: 'data',
                    hintText: '01/01/2000',
                    icon: Icon(Icons.date_range_rounded),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.servicosExtras.descricaoServico,
                  keyboardType: TextInputType.text,
                  onSaved: (val) =>
                      widget.servicosExtras.descricaoServico = val!,
                  validator: (val) =>
                      val!.length > 0 ? null : 'descrição do serviço inválida',
                  decoration: InputDecoration(
                    labelText: 'descrição',
                    hintText: '',
                    icon: Icon(Icons.view_list_rounded),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.servicosExtras.destinoRota,
                  onSaved: (val) => widget.servicosExtras.destinoRota = val!,
                  validator: (val) =>
                      val!.length > 0 ? null : 'destino da rota inválido',
                  decoration: InputDecoration(
                    labelText: 'destino',
                    hintText: '',
                    icon: Icon(Icons.format_align_justify),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.servicosExtras.valorRota > 0
                      ? widget.servicosExtras.valorRota.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.servicosExtras.valorRota =
                  double.tryParse(val!.replaceAll(",", "."))!,
                  validator: (val) =>
                  double.tryParse(val!.replaceAll(",", ".")) != null
                      ? null
                      : 'valor da rota inválido',
                  decoration: InputDecoration(
                    labelText: 'valor',
                    hintText: '0,00',
                    icon: Icon(Icons.account_balance),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.servicosExtras.despesasRota > 0
                      ? widget.servicosExtras.despesasRota.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.servicosExtras.despesasRota =
                      double.tryParse(val!.replaceAll(",", "."))!,
                  validator: (val) =>
                      double.tryParse(val!.replaceAll(",", ".")) != null
                          ? null
                          : 'valor de despesa inválido',
                  decoration: InputDecoration(
                    labelText: 'despesa',
                    hintText: '',
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
    } else
      return false;
    return valid;
  }

  void setStateIfMounted(Null Function() param0) {
    if(mounted) setState(param0);
  }
}
