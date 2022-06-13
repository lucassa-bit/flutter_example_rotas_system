import 'package:cadastrorotas/models/usuario.dart';
import 'package:flutter/material.dart';

typedef OnDelete();

class UsuarioForm extends StatefulWidget {
  final Usuario usuario;
  final state = _UsuarioFormState();
  final OnDelete onDelete;

  UsuarioForm({Key? key, required this.usuario, required this.onDelete})
      : super(key: key);
  @override
  _UsuarioFormState createState() => state;

  bool isValid() => state.validate();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var realCargos = <String>['ADMIN', 'GERENTE_EXTERNO', 'RESPONSAVEL_INTERNO'];
  var checkCargos = <String>[
    'Administrador',
    'Gerente externo',
    'Responsavel interno'
  ];
  String valorButton = 'Administrador';

  @override
  void initState() {
    if (widget.usuario.login == '') {
      widget.usuario.cargo =
          checkValueToPost(valorButton, checkCargos, realCargos);
    } else {
      valorButton =
          checkValueToView(widget.usuario.cargo, checkCargos, realCargos);
      widget.usuario.cargo =
          checkValueToPost(valorButton, checkCargos, realCargos);
    }
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
                title: const Text('Usuário'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                actions: <Widget>[
                  if (widget.usuario.login == '')
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: widget.onDelete,
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.usuario.nome,
                  keyboardType: TextInputType.name,
                  onSaved: (val) => widget.usuario.nome = val!,
                  validator: (val) => val!.isNotEmpty ? null : 'Nome inválido',
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    hintText: 'nome',
                    icon: Icon(Icons.person),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.usuario.identidade,
                  onSaved: (val) => widget.usuario.identidade = val!,
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
                  initialValue: widget.usuario.cpf,
                  keyboardType: TextInputType.text,
                  onSaved: (val) => widget.usuario.cpf = val!,
                  decoration: const InputDecoration(
                    labelText: 'Cpf',
                    hintText: '',
                    icon: Icon(Icons.featured_video_outlined),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.usuario.pix,
                  onSaved: (val) => widget.usuario.pix = val!,
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
                  initialValue: widget.usuario.numeroCelular,
                  keyboardType: TextInputType.number,
                  onSaved: (val) => widget.usuario.numeroCelular = val!,
                  validator: (val) => val!.isNotEmpty ? null : 'Número inválido',
                  decoration: const InputDecoration(
                    labelText: 'Número do celular',
                    hintText: '',
                    icon: Icon(Icons.phone_android),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.usuario.email,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (val) => widget.usuario.email = val!,
                  validator: (val) => val!.contains("@") && !val.contains(" ")
                      ? null
                      : 'email inválido',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'email@local.com',
                    icon: Icon(Icons.email),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.usuario.login,
                  keyboardType: TextInputType.name,
                  onSaved: (val) => widget.usuario.login = val!,
                  validator: (val) =>
                      !val!.contains(" ") && val.isNotEmpty ? null : 'login inválido',
                  decoration: const InputDecoration(
                    labelText: 'Login',
                    hintText: '',
                    icon: Icon(Icons.login),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  initialValue: widget.usuario.senha,
                  keyboardType: TextInputType.name,
                  onSaved: (val) => widget.usuario.senha = val!,
                  validator: (val) =>
                      (widget.usuario.login == '' && val!.isNotEmpty) ||
                              (widget.usuario.login != '')
                          ? null
                          : 'Senha inválida',
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    hintText: 'senha',
                    icon: Icon(Icons.password),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownButton<String>(
                  value: valorButton,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    if (mounted) {
                      setState(() {
                        valorButton = newValue!;
                        widget.usuario.cargo =
                            checkValueToPost(newValue, checkCargos, realCargos);
                      });
                    }
                  },
                  items:
                      checkCargos.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String checkValueToView(
      String value, List<String> checkList, List<String> realList) {
    int valorRetornar = realList.indexOf(value);
    if (valorRetornar >= 0) {
      return checkList.elementAt(valorRetornar);
    } else {
      return value;
    }
  }

  String checkValueToPost(
      String value, List<String> checkList, List<String> realList) {
    int valorRetornar = checkList.indexOf(value);
    if (valorRetornar >= 0) {
      return realList.elementAt(checkList.indexOf(value));
    } else {
      return value;
    }
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
}
