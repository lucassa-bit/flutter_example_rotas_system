// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'numero_rotas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NumeroRotas _$numeroRotasFromJson(Map<String, dynamic> json) => NumeroRotas(
      id: json['id'] as int? ?? 0,
      codigo: json['codigoRota'] as String? ?? '',
      destino: json['destinoRota'] as String? ?? '',
      valor: (json['valorRota'] as num?)?.toDouble() ?? 0,
      despesas: (json['despesasRota'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$numeroRotasToJson(NumeroRotas instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigoRota': instance.codigo,
      'destinoRota': instance.destino,
      'valorRota': instance.valor,
      'despesasRota': instance.despesas,
    };
