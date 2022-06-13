import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

part 'servicos_extras.g.dart';

class ServicosExtras {
  int id;
  String dataEmissao;
  String descricaoServico;
  String destinoRota;
  double despesasRota;
  double valorRota;

  ServicosExtras({
      this.id = -1,
      this.dataEmissao = '',
      this.descricaoServico = '',
      this.destinoRota = '',
      this.despesasRota = 0,
      this.valorRota = 0});

  factory ServicosExtras.fromJson(Map<String, dynamic> item) => _$ServicosExtrasFromJson(item);
  Map<String, dynamic> toJson() => _$ServicosExtrasToJson(this);
}
