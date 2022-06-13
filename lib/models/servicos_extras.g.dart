// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servicos_extras.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicosExtras _$ServicosExtrasFromJson(Map<String, dynamic> json) =>
    ServicosExtras(
      id: json['id'] as int? ?? 0,
      dataEmissao: FormatDate(json['dataEmissao']) as String? ?? '',
      descricaoServico: json['descricaoServico'] as String? ?? '',
      destinoRota: json['destinoRota'] as String? ?? '',
      despesasRota: (json['despesasRota'] as num?)?.toDouble() ?? 0,
          valorRota: (json['valorRota'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ServicosExtrasToJson(ServicosExtras instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataEmissao': instance.dataEmissao,
      'descricaoServico': instance.descricaoServico,
      'destinoRota': instance.destinoRota,
      'despesasRota': instance.despesasRota,
          'valorRota': instance.valorRota
    };

String FormatDate(String? value) {
  if(value == null) return '';
  var valueList = value.split("-");
  return valueList[2] + '/' + valueList[1] + '/' + valueList[0];
}
