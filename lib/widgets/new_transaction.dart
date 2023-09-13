import 'package:flutter/material.dart';
import "package:intl/intl.dart";

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction(this.addTx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text.isNotEmpty
        ? double.parse(_amountController.text)
        : 0;

    if (enteredTitle.isEmpty ||
        _amountController.text.isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime(2023),
            initialDate: DateTime.now(),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 100 + MediaQuery.of(context).viewInsets.bottom,
              left: 10,
              right: 10,
              top: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              controller: _titleController,
              cursorColor: Colors.purple,
              decoration: const InputDecoration(
                filled: true,
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.purple),
                focusColor: Colors.purple,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)),
              ),
              onSubmitted: (_) => _submitData(),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _amountController,
              cursorColor: Colors.purple,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                filled: true,
                labelText: "Amount",
                labelStyle: TextStyle(color: Colors.purple),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple)),
              ),
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text((_selectedDate == null)
                      ? "No Date Chosen"
                      : "Picked date ${DateFormat.yMd().format(_selectedDate!)}"),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        _presentDatePicker();
                      },
                      child: Text(
                        "choose date",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
            ElevatedButton(
                style: const ButtonStyle(),
                onPressed: _submitData,
                child: const Text(
                  "Add Transaction",
                  // style: TextStyle(color: Colors.white),
                ))
          ]),
        ),
      ),
    );
  }
}
