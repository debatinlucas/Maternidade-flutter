class MaeData {
  int? id, numero;
  String? cep, nome, logradouro, bairro, cidade, fixo, celular, comercial;
  DateTime? data_nascimento;

  MaeData({
    this.id,
    this.numero,
    this.cep,
    this.nome,
    this.logradouro,
    this.bairro,
    this.cidade,
    this.fixo,
    this.celular,
    this.comercial,
    this.data_nascimento
  });

  factory MaeData.fromJson(Map<String, dynamic> json) {
    return MaeData(
        id: json['id'],
        numero: json['numero'],
        cep: json['cep'],
        nome: json['nome'],
        logradouro: json['logradouro'],
        bairro: json['bairro'],
        cidade: json['cidade'],
        fixo: json['fixo'],
        celular: json['celular'],
        comercial: json['comercial'],
        data_nascimento: DateTime.parse(json['data_nascimento'])
    );
  }
}
