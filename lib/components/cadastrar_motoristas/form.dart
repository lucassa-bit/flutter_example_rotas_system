import 'package:cadastrorotas/models/motorista.dart';
import 'package:flutter/material.dart';

typedef OnDelete();

class MotoristaForm extends StatefulWidget {
  final Motorista motorista;
  final state = _MotoristaFormState();
  final OnDelete onDelete;

  MotoristaForm({Key? key, required this.motorista, required this.onDelete})
      : super(key: key);
  @override
  _MotoristaFormState createState() => state;

  bool isValid() => state.validate();
}

class _MotoristaFormState extends State<MotoristaForm> {
  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  bool get isEditting => widget.motorista.id >= 0;

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
                title: const Text('Motorista'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ), Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.motorista.nome,
                  keyboardType: TextInputType.text,
                  onSaved: (val) => widget.motorista.nome = val!,
                  validator: (val) => val!.isNotEmpty
                      ? null
                      : 'Nome inválido',
                  decoration: const InputDecoration(
                    labelText: 'nome do motorista',
                    hintText: '',
                    icon: Icon(Icons.person),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.motorista.identidade,
                  onSaved: (val) => widget.motorista.identidade = val!,
                  decoration: const InputDecoration(
                    labelText: 'identidade',
                    hintText: '',
                    icon: Icon(Icons.group),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.motorista.cpf,
                  onSaved: (val) => widget.motorista.cpf = val!,
                  decoration: const InputDecoration(
                    labelText: 'cpf',
                    hintText: '',
                    icon: Icon(Icons.featured_video_outlined),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.motorista.pix,
                  onSaved: (val) => widget.motorista.pix = val!,
                  decoration: const InputDecoration(
                    labelText: 'pix',
                    hintText: '',
                    icon: Icon(Icons.pix),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.motorista.contato,
                  onSaved: (val) => widget.motorista.contato = val!,
                  decoration: const InputDecoration(
                    labelText: 'Contato',
                    hintText: '',
                    icon: Icon(Icons.phone),
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
    else {
      return false;
    }
    return valid;
  }
}
