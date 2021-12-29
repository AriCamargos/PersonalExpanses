import 'dart:math';
import 'package:despesas_pessoais/components/transaction_form.dart';
import 'package:despesas_pessoais/components/transaction_list.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({Key? key}) : super(key: key);

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transactions = [
    Transaction(
        id: 't1',
        title: 'Novo Tênis de Corrida',
        value: 310.76,
        date: DateTime.now()),
    Transaction(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.30,
      date: DateTime.now(),
    ),
  ];

  _addTransaction(String? title, double? value) {
    //Dados que serão gerados
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(), //Número aleatório
      title: title!,
      value: value!,
      date: DateTime.now(),
    );
    setState(() {
      _transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionForm(_addTransaction), //Comunicação Indireta - card
        TransactionList(_transactions), //Comunicação direta
      ],
    );
  }
}


//Comunicação direta = é quando tenho o componente pai passando dados para o componente filho para ele ser renderizado
// Comunicação indireta = é quando o filho se comunica com o pai
//Stetfull se altera de duas formas: mudança de estado ou mudança externa através do construtor
//Stateless se altera apenas de forma externa (construtor), ai ele passa um novo parâmetro e o componente atualizado 