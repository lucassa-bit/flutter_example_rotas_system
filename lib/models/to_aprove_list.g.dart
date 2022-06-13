// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_aprove_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

toAproveList _$toAproveListFromJson(Map<String, dynamic> json) => toAproveList(
      listaToAprove: (json['listaToAprove'] as List<toAprove>)
          .map((e) => toAprove.fromJson(e as Map<String, toAprove>))
          .toList(),
    );

Map<String, dynamic> _$toAproveListToJson(toAproveList instance) =>
    <String, dynamic>{
      'listaToAprove': instance.listaToAprove,
    };
