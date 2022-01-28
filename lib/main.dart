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
    /* SystemChrome.setPreferredOrientations([ //Orientação para qndo girar a tela automaticamente o app não girar, ficar travado
      DeviceOrientation.portraitUp
    ]); */

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      //Definição do tema
      theme: ThemeData(
        primarySwatch: Colors.purple,
        errorColor: Colors.red,
        colorScheme: ColorScheme.light(
          secondary: Colors.amber,
        ),
        fontFamily: 'Quicksand',
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
  bool _showChart = false; //Mudado na linha 139

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
    final mediaQuery = MediaQuery.of(
        context); //Faço do método uma constante, fica mais fácil performático.
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text(
        'Despesas Pessoais',
        style: TextStyle(
            fontSize:
                20 /* *
              mediaQuery
                  .textScaleFactor,  */ //Escala de responsividade no tamanho da fonte
            ),
      ),
      actions: [
        if (isLandscape) //Se estiver na tela giratória vai mostrar isso
          IconButton(
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              }); //Altera se vai mostrar ou não o gráfico
            },
            //Condição - se tiver habilitado a função _showChart mostra o icone lista, senão mostra o icone chart
            icon: Icon(_showChart ? Icons.list : Icons.pie_chart),
          ),
        IconButton(
          onPressed: () => _openTransectionFormModal(context),
          icon: Icon(Icons.add),
        ),
      ],
    );
    final availabelHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Tirei o botão da interface, ai vai ficar apenas na appBar
            /* Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Exibir gráfico',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, letterSpacing: 0.1),
                ),
                Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    })
              ],
            ) */
            //Com o IF podemos deixar a operação mais complexo, diferente da operação ternária que é um ou o outro
            if (_showChart ||
                !isLandscape) //Condição se o celular estiver no modo paisagem
              Container(
                height: availabelHeight *
                    (isLandscape
                        ? 0.6
                        : 0.25), //Alterou o tamanho do gráfico na tela rotativa
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
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
