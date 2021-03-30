import 'package:flutter/cupertino.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:expenses/models/transaction.dart';
import 'components/chart.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //Serve para deixar a aplicação sempre na mesma posição, não permitindo rotatividade
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp
    // ]);

    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Roboto',
      ),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override 
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
  }

  @override 
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  final List<Transaction> _transactions = [
  ];

    //ShowChart é para mostrar o gráfico ou a lista de transação, visto que em alguns celulares, não caberá os dois simultâneamente

    bool _showChart = false;


  //Essa função serve para verificar as transações de até 7 dias atrás
  List<Transaction> get _recentTransaction{
    return _transactions.where((tr){
        return tr.date.isAfter(DateTime.now().subtract(
          Duration(days: 7)
        ));
    }).toList();
  }

  //Função para adicionar transações
  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    //Mudar o estado na ação ao criar transação
    setState(() {
      _transactions.add(newTransaction);
    });
    //Essa função abaixo serve para poder fechar o modal que abre para adicionar uma nova transação.
    Navigator.of(context).pop();
  }

  //Remover uma transação ao clicar o lixo
  _removeTransaction(String id){
    setState(() {
      _transactions.removeWhere((tr){
      return tr.id == id;
      });
    });
  }

  //Abrir modal para adicionar transação
  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForms(_addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function fn){
    return Platform.isIOS ? GestureDetector(onTap: fn, child: Icon(icon))
    : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final action = <Widget>[
           if(isLandscape) 
            _getIconButton(
            (_showChart ? iconList : chartList),
             () {
              setState(() {
                _showChart = !_showChart;
              });
            }
          ),
          _getIconButton(
            Icons.add,
            () => _openTransactionFormModal(context),
          ),
        ];

    final PreferredSizeWidget appBar = Platform.isIOS ? 
      CupertinoNavigationBar(
        middle: Text('Despesas Pessoais'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: action,
        
        ),
      )
    : AppBar(
        title: Text('Despesas Pessoais'),
        actions: action,
      );

    //Conta para determinar qual a porcentagem que cada componente vai usar dentro da tela
    final availableHeight = mediaQuery.size.height - 
          appBar.preferredSize.height - 
          mediaQuery.padding.top;

    final bodyPage = SafeArea
    (child:  SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if(isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Exibir Gráfico'),
                  Switch.adaptive(
                    value: _showChart, 
                    onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      },
                    ),
                ],
              ),
              if(_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ?  0.7 : 0.25),
                child: Chart(_recentTransaction),
                ), 
                if(!_showChart || !isLandscape) 
              Container(
                height: availableHeight *(isLandscape ?  1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
            ]
          ),
      ),
    );



    //Scaffold é como se fosse o pai, que te permite usar outros componentes do material:flutter
    return Platform.isIOS ? CupertinoPageScaffold(

      child: bodyPage
      ) 
      : Scaffold(
    //O AppBar é o texto que aparece no header
      appBar: appBar,
    //Aqui dentro do body criou colunas, para que fique um encima do outro (O gráfico e os cardzinhos)
      body: bodyPage,
        floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//Container: Aceita apenas o child como elemento filho

//Colum/Row: Aceita vários que é o children

// fit tight serve para ocupar todo espaço do container

// fit loose usa apenas espaço necessário do texto que está dentro do container

