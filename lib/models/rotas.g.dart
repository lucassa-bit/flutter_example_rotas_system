// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rotas _$RotasFromJson(Map<String, dynamic> json) => Rotas(
      id: json['id'] as int? ?? 0,
      dataEmissao: FormatDate(json['dataEmissao']),
      dataChegada: FormatDate(json['dataChegada']),

      horaInicio: json['horaInicio'] as String? ?? '',
      horaFim: json['horaFim'] as String? ?? '',

      gerenteExterno: json['idGerente'] as int? ?? 0,
      contatoGerenteExterno: json['contatoGerente'] as String? ?? '',
      nomeGerenteExterno: json['nomeGerente'] as String? ?? '',
      cpfGerenteExterno: json['cpfGerente'] as String? ?? '',
      pixGerenteExterno: json['pixGerente'] as String? ?? '',
      identidadeGerenteExterno: json['identidadeGerente'] as String? ?? '',

      responsavelInterno: json['idResponsavel'] as int? ?? 0,
      nomeResponsavelInterno: json['nomeResponsavel'] as String? ?? '',
      contatoResponsavelInterno: json['contatoResponsavel'] as String? ?? '',
      cpfResponsavelInterno: json['cpfResponsavel'] as String? ?? '',
      pixResponsavelInterno: json['pixResponsavel'] as String? ?? '',
      identidadeResponsavelInterno: json['identidadeResponsavel'] as String? ?? '',

      administrador: json['idAdministrador'] as int? ?? 0,
      nomeAdministrador: json['nomeAdministrador'] as String? ?? '',
      contatoAdministrador: json['contatoAdministrador'] as String? ?? '',
      cpfAdministrador: json['cpfAdministrador'] as String? ?? '',
      pixAdministrador: json['pixAdministrador'] as String? ?? '',
      identidadeAdministrador: json['identidadeAdministrador'] as String? ?? '',

      nomeMotorista: json['nomeMotorista'] as String? ?? '',
      numeroManifesto: json['numeroManifesto'] as String? ?? '',
      numeroCelularMotorista: json['numeroCelularMotorista'] as String? ?? '',
      cpfMotorista: json['cpfMotorista'] as String? ?? '',
      pixMotorista: json['pixMotorista'] as String? ?? '',
      identidadeMotorista: json['identidadeMotorista'] as String? ?? '',

      codigoRota: json['codigoRota'] as String? ?? '',
      destinoRota: json['destinoRota'] as String? ?? '',
      valorRota: (json['valorRota'] as num?)?.toDouble() ?? 0,
      despesasRota: (json['despesasRota'] as num?)?.toDouble() ?? 0,

      placaCaminhao: json['placaCaminhao'] as String? ?? '',
      numeroRomaneio: json['numeroRomaneio'] as String? ?? '',
      isAprovado: json['isAprovado'] as bool? ?? false,

      idCaminhao: json['idCaminhao'] as int? ?? 0,
      idMotorista: json['idMotorista'] as int? ?? 0,
      idNumeroRota: json['idNumeroRota'] as int? ?? 0,
);

Map<String, dynamic> _$RotasToJson(Rotas instance) => <String, dynamic>{
      'id': instance.id,
      'dataEmissao': instance.dataEmissao,
      'dataChegada': instance.dataChegada,
      'isAprovado': instance.isAprovado,
      'horaInicio': instance.horaInicio,
      'horaFim': instance.horaFim,
      'numeroManifesto': instance.numeroManifesto,
      'numeroRomaneio': instance.numeroRomaneio,
      'gerenteExterno': instance.gerenteExterno,
      'responsavelInterno': instance.responsavelInterno,
      'nomeMotorista': instance.nomeMotorista,
      'numeroCelularMotorista': instance.numeroCelularMotorista,
      'cpfMotorista': instance.cpfMotorista,
      'pixMotorista': instance.pixMotorista,
      'identidadeMotorista': instance.identidadeMotorista,
      'codigoRota': instance.codigoRota,
      'destinoRota': instance.destinoRota,
      'valorRota': instance.valorRota,
      'despesasRota': instance.despesasRota,
      'placaCaminhao': instance.placaCaminhao,
      'idCaminhao': instance.idCaminhao,
      'idMotorista': instance.idMotorista,
      'idNumeroRota': instance.idNumeroRota,
    };

String FormatDate(String? value) {
      if(value == null) return '';
      var valueList = value.split("-");
      return valueList[2] + '/' + valueList[1] + '/' + valueList[0];
}

