import 'package:cadastrorotas/models/caminhao.dart';
import 'package:flutter/material.dart';

typedef OnDelete();

class CaminhaoForm extends StatefulWidget {
  final Caminhao caminhao;
  final state = _CaminhaoFormState();
  final OnDelete onDelete;

  CaminhaoForm({Key? key, required this.caminhao, required this.onDelete})
      : super(key: key);
  @override
  _CaminhaoFormState createState() => state;

  bool isValid() => state.validate();
}

class _CaminhaoFormState extends State<CaminhaoForm> {
  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  bool get isEditting => widget.caminhao.id >= 0;

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
                title: Text('Caminhão'),
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
                  initialValue: widget.caminhao.placa,
                  keyboardType: TextInputType.text,
                  onSaved: (val) => widget.caminhao.placa = val!,
                  validator: (val) => val!.length > 0
                      ? null
                      : 'placa inválida',
                  decoration: InputDecoration(
                    labelText: 'placa',
                    hintText: '',
                    icon: Icon(Icons.airport_shuttle),
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
