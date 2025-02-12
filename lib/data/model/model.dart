class Tarefa {
  String? id;
  String nome;
  String descricao;
  String status;
  String dataInicio;
  String dataFim;

  Tarefa({
    this.id,
    required this.nome,
    required this.descricao,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'status': status,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
    };
  }
}
