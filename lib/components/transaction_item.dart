import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.tr,
    @required this.onRemove,
  }) : super(key: key);

  final Transaction tr;
  final void Function(String p1) onRemove;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {


  //Variedade de cores nos valores dos formulários
  static const colors = [
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.blue,
    Colors.black,
  ];

  Color _backgroundColor;

  @override
  void initState(){
    super.initState();
    int i = Random().nextInt(5);
    _backgroundColor = colors[i];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
    //ListTile é como se fosse o NGFOR
      child: ListTile(
      //Circle avatar é pra deixar a bolinha com os valores dentro
        leading: CircleAvatar(
          backgroundColor: _backgroundColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('R\$${widget.tr.value}'),
            ),
          ),
        ),
        title: Text(
          widget.tr.title,
        ),
        subtitle: Text(DateFormat('d MMM y').format(widget.tr.date)),
        trailing: MediaQuery.of(context).size.width > 480 ?
            FlatButton.icon(
              onPressed: () => widget.onRemove(widget.tr.id), 
              icon: const Icon(Icons.delete), 
              label: const Text('Excluir'),
              textColor: Theme.of(context).errorColor,
          )
         : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.onRemove(widget.tr.id),
        ),
      ),
    );
  }
}