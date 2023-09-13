import 'package:flutter/material.dart';
import 'package:flutter_second_app/models/transaction.dart';
import 'package:flutter_second_app/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart(this.recentTransactions, {super.key});

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      //TODO

      return {
        "day": DateFormat.E().format(weekday).substring(0, 1),
        "amount": totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item["amount"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        shadowColor: Theme.of(context).primaryColorLight,
        elevation: 6,
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionsValues
                .map((data) => Flexible(
                      fit: FlexFit.tight,
                      //CUSTOM_WIDGET
                      child: ChartBar(
                          label: data["day"].toString(),
                          spendingAmount: (data["amount"] as double),
                          spendingPctOfTotal: totalSpending == 0.0
                              ? 0.0
                              : (data["amount"] as double) / totalSpending),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
