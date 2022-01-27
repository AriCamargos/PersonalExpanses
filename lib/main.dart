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
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      //Where é uma forma de filtrar
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7), //data de agora subtraindo 7 dias
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    //Dados que serão gerados
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(), //Número aleatório
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); //Faz com que o modal seja fechado
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  //Modal
  _openTransectionFormModal(BuildContext context) {
    //Método que abre o modal
    showModalBottomSheet(
      //receber 2 parametros
      context: context,
      // ignore: null_check_always_fails
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
            fontSize:
                20 /* *
              MediaQuery.of(context)
                  .textScaleFactor,  */ //Escala de responsividade no tamanho da fonte
            ),
      ),
      actions: [
        IconButton(
          onPressed: () => _openTransectionFormModal(context),
          icon: Icon(Icons.add),
        ),
      ],
    );
    final availabelHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: availabelHeight * 0.25,
              child: Chart(_recentTransactions),
            ),
            Container(
              height: availabelHeight * 0.75,
              child: TransactionList(_transactions, _removeTransaction),
            ),
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
