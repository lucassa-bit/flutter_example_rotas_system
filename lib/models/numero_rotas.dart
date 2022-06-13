part 'numero_rotas.g.dart';

class NumeroRotas {
  int id;
  String codigo;
  String destino;
  double valor;
  double despesas;

  NumeroRotas({this.id = -1, this.codigo = '', this.destino = '', this.valor = 0, this.despesas = 0});

  factory NumeroRotas.fromJson(Map<String, dynamic> item) => _$numeroRotasFromJson(item);
  Map<String, dynamic> toJson() => _$numeroRotasToJson(this);
}
