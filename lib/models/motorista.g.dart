// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motorista.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Motorista _$MotoristaFromJson(Map<String, dynamic> json) => Motorista(
      id: json['id'] as int? ?? 0,
      nome: json['nomeMotorista'] as String? ?? '',
      contato: json['numeroCelularMotorista'] as String? ?? '',
      cpf: json['cpfMotorista'] as String? ?? '',
      pix: json['pixMotorista'] as String? ?? '',
      identidade: json['identidadeMotorista'] as String? ?? '',

);

Map<String, dynamic> _$MotoristaToJson(Motorista instance) => <String, dynamic>{
      'id': instance.id,
      'nomeMotorista': instance.nome,
      'numeroCelularMotorista': instance.contato,
      'cpfMotorista': instance.cpf,
      'pixMotorista': instance.pix,
      'identidadeMotorista': instance.identidade
};
