class EditarManifesto {
  int id;
  String numeroManifesto;
  String dataChegada;
  String horaInicio;
  String horaFim;

  EditarManifesto({this.id = -1,
    this.numeroManifesto = '',
    this.dataChegada = '',
    this.horaInicio = '',
    this.horaFim = ''});

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'id': id,
      'numeroManifesto': numeroManifesto,
      'dataChegada': dataChegada,
      'horaInicio': horaInicio,
      'horaFim': horaFim
    };
  }
}
