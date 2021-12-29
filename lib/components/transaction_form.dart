import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  final void Function(String, double) onSubmit;

  TransactionForm(this.onSubmit);

  _submitForm() {
    final title = titleController.text; //Capturo os dados do formulário
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      //Validação de titulo e valor
      return 'Dados incompletos';
    }

    onSubmit(title, value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller:
                  titleController, //Estado do controller será alterado quando eu fizer as alterações
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextField(
              controller: valueController,
              onSubmitted: (_) => _submitForm(),
              keyboardType: TextInputType.numberWithOptions(
                  decimal:
                      true), //Colocar porque no iOS não mostra se não colocar isso
              decoration: InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text(
                    'Nova Transação',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
