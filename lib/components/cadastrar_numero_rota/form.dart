import 'package:cadastrorotas/models/api_response.dart';
import 'package:cadastrorotas/models/numero_rotas.dart';
import 'package:cadastrorotas/models/usuario.dart';
import 'package:cadastrorotas/options/http_options.dart';
import 'package:cadastrorotas/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:cadastrorotas/models/rotas.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

typedef OnDelete();

class NumeroRotasForm extends StatefulWidget {
  final NumeroRotas rotas;
  final state = _NumeroRotasFormState();
  final OnDelete onDelete;

  NumeroRotasForm({Key? key, required this.rotas, required this.onDelete})
      : super(key: key);
  @override
  _NumeroRotasFormState createState() => state;

  bool isValid() => state.validate();
}

class _NumeroRotasFormState extends State<NumeroRotasForm> {
  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isEditting => widget.rotas.id >= 0;

  httpOptions get instanceHttp => GetIt.instance<httpOptions>();

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
                title: Text('Numero rota'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ), Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.codigo,
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.codigo = val!,
                  validator: (val) => val!.length > 0
                      ? null
                      : 'código de rota inválido',
                  decoration: InputDecoration(
                    labelText: 'código rota',
                    hintText: '000',
                    icon: Icon(Icons.assistant_direction),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.destino,
                  onSaved: (val) => widget.rotas.destino = val!,
                  validator: (val) =>
                      val!.length > 0 ? null : 'destino inválido',
                  decoration: InputDecoration(
                    labelText: 'destino',
                    hintText: '',
                    icon: Icon(Icons.format_align_justify),
                    isDense: true,
                  ),
                ),
              ),
              if(instanceHttp.cargo == 'Administrador')
                Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.valor > 0 ? widget.rotas.valor.toString() : '',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.valor =
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
              if(instanceHttp.cargo == 'Administrador')
                Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.rotas.despesas > 0 ? widget.rotas.despesas.toString() : '',
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.rotas.despesas =
                  double.tryParse(val!.replaceAll(",", "."))!,
                  validator: (val) =>
                  double.tryParse(val!.replaceAll(",", ".")) != null
                      ? null
                      : 'despesa inválida',
                  decoration: InputDecoration(
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

    }
    else
      return false;
    return valid;
  }
}
