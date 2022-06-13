part 'rotas.g.dart';

class Rotas {
  int id;
  String dataEmissao;
  String dataChegada;

  String horaInicio;
  String horaFim;

  bool isAprovado;
  String numeroManifesto;
  String numeroRomaneio;

  int gerenteExterno;
  String nomeGerenteExterno;
  String contatoGerenteExterno;
  String cpfGerenteExterno;
  String pixGerenteExterno;
  String identidadeGerenteExterno;

  int responsavelInterno;
  String nomeResponsavelInterno;
  String contatoResponsavelInterno;
  String cpfResponsavelInterno;
  String pixResponsavelInterno;
  String identidadeResponsavelInterno;

  int administrador;
  String nomeAdministrador;
  String contatoAdministrador;
  String cpfAdministrador;
  String pixAdministrador;
  String identidadeAdministrador;

  int idMotorista;
  String nomeMotorista;
  String numeroCelularMotorista;
  String cpfMotorista;
  String pixMotorista;
  String identidadeMotorista;

  int idNumeroRota;
  String codigoRota;
  String destinoRota;
  double valorRota;
  double despesasRota;

  int idCaminhao;
  String placaCaminhao;

  Rotas({
    this.id = -1,
    this.dataEmissao = '',
    this.dataChegada = '',
    this.gerenteExterno = -1,
    this.nomeGerenteExterno = '',
    this.contatoGerenteExterno = '',
    this.pixGerenteExterno = '',
    this.cpfGerenteExterno = '',
    this.identidadeGerenteExterno = '',
    this.administrador = -1,
    this.nomeAdministrador = '',
    this.contatoAdministrador = '',
    this.pixAdministrador = '',
    this.cpfAdministrador = '',
    this.identidadeAdministrador = '',
    this.responsavelInterno = -1,
    this.nomeResponsavelInterno = '',
    this.cpfResponsavelInterno = '',
    this.contatoResponsavelInterno = '',
    this.pixResponsavelInterno = '',
    this.identidadeResponsavelInterno = '',
    this.nomeMotorista = '',
    this.numeroCelularMotorista = '',
    this.cpfMotorista = '',
    this.pixMotorista = '',
    this.identidadeMotorista = '',
    this.numeroManifesto = '',
    this.numeroRomaneio = '',
    this.codigoRota = '',
    this.destinoRota = '',
    this.valorRota = 0,
    this.despesasRota = 0,
    this.placaCaminhao = '',
    this.isAprovado = false,
    this.idMotorista = -1,
    this.idNumeroRota = -1,
    this.idCaminhao = -1,
    this.horaInicio = '',
    this.horaFim = ''
  });

  String get informacoesResponsavel => 'Rota: $codigoRota\nDestino: $destinoRota\nGerente: $nomeGerenteExterno';
  String get informacoesGerente => 'Rota: $codigoRota\nDestino: $destinoRota\nResponsável: $nomeResponsavelInterno';

  factory Rotas.fromJson(Map<String, dynamic> item) => _$RotasFromJson(item);
  Map<String, dynamic> toJson() => _$RotasToJson(this);

  Map<String, dynamic> cadastroRota() => <String, dynamic>{
    'dataEmissao': dataEmissao,
    'gerenteExterno': gerenteExterno,
    'responsavelInterno': responsavelInterno,
    'numeroManifesto': numeroManifesto,
    'numeroRomaneio': numeroRomaneio,
    'nomeMotorista': nomeMotorista,
    'numeroCelularMotorista': numeroCelularMotorista,
    'cpfMotorista': cpfMotorista,
    'pixMotorista': pixMotorista,
    'identidadeMotorista': identidadeMotorista,
    'codigoRota': codigoRota,
    'destinoRota': destinoRota,
    'valorRota': valorRota,
    'despesasRota': despesasRota,
    'placaCaminhao': placaCaminhao,
    'idCaminhao': idCaminhao,
    'idMotorista': idMotorista,
    'idNumeroRota': idNumeroRota,
  };

  Map<String, dynamic> toEdit() => <String, dynamic>{
    'id': id,
    'dataEmissao': dataEmissao,
    'dataChegada': dataChegada,
    'gerenteExterno': gerenteExterno,
    'responsavelInterno': responsavelInterno,
    'numeroManifesto': numeroManifesto,
    'numeroRomaneio': numeroRomaneio,
    'nomeMotorista': nomeMotorista,
    'numeroCelularMotorista': numeroCelularMotorista,
    'cpfMotorista': cpfMotorista,
    'pixMotorista': pixMotorista,
    'identidadeMotorista': identidadeMotorista,
    'codigoRota': codigoRota,
    'destinoRota': destinoRota,
    'valorRota': valorRota,
    'despesasRota': despesasRota,
    'placaCaminhao': placaCaminhao,
    'idCaminhao': idCaminhao,
    'idMotorista': idMotorista,
    'idNumeroRota': idNumeroRota,
    'horaInicio': horaInicio,
    'horaFim': horaFim
  };

  Map<String, dynamic> cadastroRotaExtra() => <String, dynamic>{
    'dataEmissao': dataEmissao,
    'dataChegada': dataChegada,
    'idAdministrador': administrador,
    'numeroManifesto': numeroManifesto,
    'numeroRomaneio': numeroRomaneio,
    'nomeMotorista': nomeMotorista,
    'numeroCelularMotorista': numeroCelularMotorista,
    'cpfMotorista': cpfMotorista,
    'pixMotorista': pixMotorista,
    'identidadeMotorista': identidadeMotorista,
    'codigoRota': codigoRota,
    'destinoRota': destinoRota,
    'valorRota': valorRota,
    'despesasRota': despesasRota,
    'placaCaminhao': placaCaminhao,
  };


  Map<String, dynamic> toEditExtra() => <String, dynamic>{
    'id': id,
    'dataEmissao': dataEmissao,
    'dataChegada': dataChegada,
    'idAdministrador': administrador,
    'numeroManifesto': numeroManifesto,
    'numeroRomaneio': numeroRomaneio,
    'nomeMotorista': nomeMotorista,
    'numeroCelularMotorista': numeroCelularMotorista,
    'cpfMotorista': cpfMotorista,
    'pixMotorista': pixMotorista,
    'identidadeMotorista': identidadeMotorista,
    'codigoRota': codigoRota,
    'destinoRota': destinoRota,
    'valorRota': valorRota,
    'despesasRota': despesasRota,
    'placaCaminhao': placaCaminhao,
  };
}
