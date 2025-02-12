import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/model.dart';
import '../../data/repository/tarefa_repository.dart';
import '../viewmodel/tarefa_viewmodel.dart';

class EditTarefaPage extends StatefulWidget {
  final Tarefa tarefa;

  const EditTarefaPage({super.key, required this.tarefa});

  @override
  State<EditTarefaPage> createState() => _EditTarefaPageState();
}

class _EditTarefaPageState extends State<EditTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController dataInicioController;
  late TextEditingController dataFimController;
  final TarefaViewmodel _viewModel = TarefaViewmodel(TarefaRepository());
  String? _status;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.tarefa.nome);
    descricaoController = TextEditingController(text: widget.tarefa.descricao);
    dataInicioController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(
            DateTime.tryParse(widget.tarefa.dataInicio) ?? DateTime.now()));
    dataFimController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(
            DateTime.tryParse(widget.tarefa.dataFim) ?? DateTime.now()));
    _status = widget.tarefa.status;
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    dataInicioController.dispose();
    dataFimController.dispose();
    super.dispose();
  }

  Future<void> saveEdits() async {
    if (_formKey.currentState!.validate()) {
      final updatedTarefa = Tarefa(
        id: widget.tarefa.id,
        nome: nomeController.text,
        descricao: descricaoController.text,
        status: _status ?? "Pendente",
        dataInicio: DateFormat('dd/MM/yyyy')
            .parse(dataInicioController.text)
            .toIso8601String(),
        dataFim: DateFormat('dd/MM/yyyy')
            .parse(dataFimController.text)
            .toIso8601String(),
      );

      try {
        await _viewModel.updateTarefa(
            widget.tarefa.id.toString(), updatedTarefa);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar a tarefa: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Editar Tarefa'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                      nomeController, 'Nome', 'Por favor entre com um nome'),
                  const SizedBox(height: 16),
                  _buildTextField(descricaoController, 'Descrição',
                      'Por favor entre com a descrição',
                      maxLines: 5),
                  const SizedBox(height: 16),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  _buildDateField(dataInicioController, 'Data de Início'),
                  const SizedBox(height: 16),
                  _buildDateField(dataFimController, 'Data de Fim'),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: saveEdits,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    icon: const Icon(Icons.save, size: 24),
                    label: const Text('Salvar', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorMsg,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(
          labelText: 'Status', border: OutlineInputBorder()),
      items: const [
        DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
        DropdownMenuItem(value: 'Em andamento', child: Text('Em andamento')),
        DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
      ],
      onChanged: (value) => setState(() => _status = value),
      validator: (value) => value == null || value.isEmpty
          ? 'Por favor selecione um status'
          : null,
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Por favor entre com $label' : null,
    );
  }
}
