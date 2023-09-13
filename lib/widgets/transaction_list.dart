import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) => Column(children: [
                    Text(
                      "no transactions available",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ]))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.all(4),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                            child: Text("\$${transactions[index].amount}")),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? TextButton.icon(
                            style: ButtonStyle(
                                iconColor: MaterialStatePropertyAll(
                                    Theme.of(context).colorScheme.error)),
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: const Icon(Icons.delete),
                            label: Text(
                              "delete",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          )
                        : IconButton(
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            )),
                  ),
                );
              },
              itemCount: transactions.length,
              // children: transactions
              //     .map((tx) => )
              //     .toList(),
            ),
    );
  }
}

/* 
Card(
                          shadowColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      "\$${transactions[index].amount.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transactions[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                    Text(
                                        DateFormat.yMMMd()
                                            .format(transactions[index].date),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 16))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
 */