import '../../core/database.dart';
import '../model/model.dart';

class TarefaRepository {
  final String collection = 'tarefas';

  Future<void> insertTarefa(Tarefa tarefa) async {
    await DatabaseHelper.addDocument(collection, tarefa.toMap());
  }

  Future<List<Tarefa>> getTarefa() async {
    List<Map<String, dynamic>> tarefaMaps =
        await DatabaseHelper.getDocuments(collection);
    return tarefaMaps.map((map) {
      return Tarefa(
        id: map['id'], // O Firestore gera um ID string
        nome: map['nome'],
        descricao: map['descricao'] ?? '',
        status: map['status'],
        dataInicio: map['dataInicio'] ?? '',
        dataFim: map['dataFim'] ?? '',
      );
    }).toList();
  }

  Future<void> updateTarefa(String id, Tarefa tarefa) async {
    await DatabaseHelper.updateDocument(collection, id, tarefa.toMap());
  }

  Future<void> deleteTarefa(String id) async {
    await DatabaseHelper.deleteDocument(collection, id);
  }
}
