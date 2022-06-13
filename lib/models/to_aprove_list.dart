import 'package:cadastrorotas/models/to_aprove.dart';

part 'to_aprove_list.g.dart';

class toAproveList {
  List<toAprove> listaToAprove = [];

  toAproveList({required this.listaToAprove});

  Map<String, dynamic> toJson() => _$toAproveListToJson(this);

}