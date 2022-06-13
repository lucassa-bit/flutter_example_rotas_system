import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

part 'usuario.g.dart';

class Usuario {
  int id;
  String login;
  String senha;
  String cpf;
  String identidade;
  String pix;
  String nome;
  String email;
  String cargo;
  String numeroCelular;

  Usuario({
    this.id = -1,
    this.login = '',
    this.senha = '',
    this.cpf = '',
    this.identidade = '',
    this.pix = '',
    this.nome = '',
    this.email = '',
    this.cargo = '',
    this.numeroCelular = '',
  });

  factory Usuario.fromJson(Map<String, dynamic> item) => _$UsuarioFromJson(item);
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
