part 'motorista.g.dart';

class Motorista {
  int id;
  String nome;
  String contato;
  String cpf;
  String pix;
  String identidade;

  Motorista({this.id = -1, this.nome = '', this.contato = '',
    this.cpf = '', this.pix = '', this.identidade = ''});

  factory Motorista.fromJson(Map<String, dynamic> item) => _$MotoristaFromJson(item);
  Map<String, dynamic> toJson() => _$MotoristaToJson(this);
}
