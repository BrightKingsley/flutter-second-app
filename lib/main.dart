import "dart:io";

import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:flutter/cupertino.dart";

import "./models/transaction.dart";
import "./widgets/new_transaction.dart";
import "./widgets/chart.dart";
import "./widgets/transaction_list.dart";

void main() {
  //NOTE
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: "Quicksand",
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
          ),
          labelLarge: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
            toolbarTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                    titleLarge: const TextStyle(
                        fontFamily: "Opensans",
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
                .bodyMedium,
            titleTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                    titleLarge: const TextStyle(
                        fontFamily: "Opensans",
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
                .titleLarge),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
          secondary: Colors.amber,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  bool _showChart = false;

  @override
  void didChangeLifecycleSCate(AppLifecycleState state) {
    print("LIFECYCLE_STATE $state");
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((tx) => tx.date.isAfter(
              DateTime.now().subtract(
                const Duration(days: 7),
              ),
            ))
        .toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    if (txTitle.isEmpty ||
        txAmount.runtimeType != double ||
        chosenDate.toString().isEmpty) {
      return;
    }
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        context: ctx,
        builder: (_) {
          return NewTransaction(
            _addNewTransaction,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = AppBar(
      title: Text(
        "Personal Expenses",
        style: Theme.of(context).appBarTheme.textTheme?.titleLarge,
      ),
      titleTextStyle: const TextStyle(fontSize: 30, shadows: []),
      actions: [
        IconButton(
          onPressed: () => startAddNewTransaction(context),
          icon: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ],
    );

    final txChart = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          (isLandscape ? 0.7 : 0.3),
      child: Chart(
        _userTransactions,
      ),
    );

    final txListWidget = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SingleChildScrollView(
      child: Column(children: [
        if (isLandscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Text("Show Chart"),
              CupertinoSwitch(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  }),
            ],
          ),
        if (!isLandscape) txChart,
        if (!isLandscape) txListWidget,
        _showChart ? txChart : txListWidget,
      ]),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: pageBody,
      floatingActionButton: Platform.isLinux
          ? null
          : FloatingActionButton(
              onPressed: () => startAddNewTransaction(context),
              child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/*
 Scaffold(
              backgroundColor: Colors.white,
              appBar: appBar,
              body: pageBody,
              floatingActionButton: Platform.isLinux
                  ? null
                  : FloatingActionButton(
                      onPressed: () => startAddNewTransaction(context),
                      child: const Icon(Icons.add)),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
 */

/*
 const TextTheme(
            titleSmall: TextStyle(fontFamily: "Poppins", fontSize: 18)),
        appBarTheme: AppBarTheme(
            toolbarTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                    titleLarge: const TextStyle(
                        fontFamily: "Opensans",
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
                .bodyMedium,
            titleTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                    titleLarge: const TextStyle(
                        fontFamily: "Opensans",
                        fontSize: 20,
                        fontWeight: FontWeight.normal))
                .titleLarge),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.amber),
 */
