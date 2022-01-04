import 'package:despesas_pessoais/components/chart.dart';
import 'components/chart.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'dart:math';

main() => runApp(ExpansesApp());

class ExpansesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      //Definição do tema
      theme: ThemeData(
          colorScheme: ThemeData.light().colorScheme.copyWith(
                primary: Colors.purple,
                secondary: Colors.amber,
              ),
          textTheme: ThemeData.light().textTheme.copyWith(
                caption: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          appBarTheme: const AppBarTheme(
              //Tema do appBar
              titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        id: 't0',
        title: 'Conta antiga',
        value: 400.76,
        date: DateTime.now().subtract(Duration(days: 33))),
    Transaction(
        id: 't2',
        title: 'Conta de Luz',
        value: 211.30,
        date: DateTime.now().subtract(Duration(days: 4))),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions
        .where(
          (tr) => tr.date.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  // ignore: unused_element
  _addTransaction(String title, double value) {
    //Dados que serão gerados
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(), //Número aleatório
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //Faz com que o modal seja fechado
  }

  _openTransectionFormModal(BuildContext context) {
    //Método que abre o modal
    showModalBottomSheet(
      //receber 2 parametros
      context: context,
      // ignore: null_check_always_fails
      builder: (_) => TransactionForm(_addTransaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoais'),
        actions: [
          IconButton(
            onPressed: () => _openTransectionFormModal(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),
            TransactionList(_transactions),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransectionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Alinhamento do botão flutuante
    );
  }
}
