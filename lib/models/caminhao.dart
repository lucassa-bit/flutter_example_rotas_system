part 'caminhao.g.dart';

class Caminhao {
  int id;
  String placa;

  Caminhao({this.id = -1, this.placa = ''});

  factory Caminhao.fromJson(Map<String, dynamic> item) =>
      _$CaminhaoFromJson(item);
  Map<String, dynamic> toJson() => _$CaminhaoToJson(this);
}
