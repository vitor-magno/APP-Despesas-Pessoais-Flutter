import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import '../components/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
// Context diz qual component ta sendo renderizado
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
          builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Nenhuma transação cadastrada',
                ),
                const SizedBox(height: 20),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : 
        ListView(
          children: transactions.map((tr){
            return TransactionItem(
              key: ValueKey(tr.id),
              tr: tr, 
              onRemove: onRemove
              );
          }).toList()
        );
        // ListView.builder(
        //     itemCount: transactions.length,
        //     itemBuilder: (ctx, index) {
        //       final tr = transactions[index];
        //       var tr2 = tr;
        //       return TransactionItem(
        //         tr: tr, 
        //         onRemove: onRemove,
        //         );
        //     },
        //   );
        }
      }

