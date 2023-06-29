class MedicoData {
  int? crm;
  String? nome, especialidade, celular;

  MedicoData({
    this.crm,
    this.nome,
    this.especialidade,
    this.celular
  });

  factory MedicoData.fromJson(Map<String, dynamic> json) {
    return MedicoData(
      crm: json['crm'],
      nome: json['nome'],
      especialidade: json['especialidade'],
      celular: json['celular']
    );
  }
}
