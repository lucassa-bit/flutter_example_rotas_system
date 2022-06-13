// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
      id: json['id'] as int? ?? 0,
      login: json['login'] as String? ?? '',
      senha: json['senha'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      pix: json['pix'] as String? ?? '',
      identidade: json['identidade'] as String? ?? '',
      cargo: transforString(json['cargo']),
      numeroCelular: json['numeroCelular'] as String? ?? '',
    );

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'senha': instance.senha,
      'cpf': instance.cpf,
      'pix': instance.pix,
      'identidade': instance.identidade,
      'nome': instance.nome,
      'email': instance.email,
      'cargo': instance.cargo,
      'numeroCelular': instance.numeroCelular,
    };

String transforString(String value) {
      return value == 'ADMIN' ? 'Administrador' :
          toBeginningOfSentenceCase(value.toLowerCase().replaceAll('_', ' '))!;
}