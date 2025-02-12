import '../../data/model/model.dart';
import '../../data/repository/tarefa_repository.dart';

class TarefaViewmodel {
  final TarefaRepository repository;

  TarefaViewmodel(this.repository);

  Future<void> addTarefa(Tarefa tarefa) async {
    await repository.insertTarefa(tarefa);
  }

  Future<List<Tarefa>> getTarefas() async {
    return await repository.getTarefa();
  }

  Future<void> updateTarefa(String id, Tarefa tarefa) async {
    await repository.updateTarefa(id, tarefa);
  }

  Future<void> deleteTarefa(String id) async {
    await repository.deleteTarefa(id);
  }
}
