class BebeData {
  int? id, id_mae, crm_medico, altura;
  String? nome;
  double? peso;
  DateTime? data_nascimento;

  BebeData({
    this.id,
    this.id_mae,
    this.crm_medico,
    this.altura,
    this.nome,
    this.data_nascimento,
    this.peso
  });

  factory BebeData.fromJson(Map<String, dynamic> json) {
    return BebeData(
        id: json['id'],
        id_mae: json['id_mae'],
        crm_medico: json['crm_medico'],
        altura: json['altura'],
        nome: json['nome'],
        data_nascimento: DateTime.parse(json['data_nascimento']),
        peso: json['peso']
    );
  }
}
