import 'package:flutter/material.dart';
import 'package:signup/constants.dart';
import 'package:signup/models/expense.dart';
import 'package:signup/utils/txn_database_helper.dart';

class ExpenseAddPage extends StatefulWidget {
  static const routeName = "/expense-add-page";

  const ExpenseAddPage({Key key}) : super(key: key);

  @override
  State<ExpenseAddPage> createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  TextEditingController dateCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _ctrlAmount = TextEditingController();
  DateTime date;
  String expenseMode = Expense.expenseModeColors.keys.first;
  String expenseCategory = Expense.expenseCategoryColors.keys.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Expense Mode',
                    style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5, left: 3),
                    child: DropdownButtonFormField(
                      value: expenseMode,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: Expense.expenseModeColors.keys.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                      onChanged: (newValue) => setState(() => expenseMode = newValue),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Expense Category',
                    style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5, left: 3),
                    child: DropdownButtonFormField(
                      value: expenseCategory,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: Expense.expenseCategoryColors.keys.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                      onChanged: (newValue) => setState(() => expenseCategory = newValue),
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _ctrlAmount,
              keyboardType: TextInputType.number,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                  return 'please enter amount';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Enter amount ',
                labelStyle: TextStyle(color: kPrimaryColor),
              ),
            ),
            TextFormField(
              controller: dateCtl,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter date';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: kPrimaryColor),
                labelText: "Date of Transaction",
                hintText: "Enter date",
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                date = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    )) ??
                    DateTime.now();
                dateCtl.text = date.toString().substring(0, 11);
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: kPrimaryColor,
                onPressed: () async {
                  var form = _formKey.currentState;
                  if (form.validate()) {
                    final exp = Expense.empty();
                    exp.expenseMode = expenseMode;
                    exp.expenseCategory = expenseCategory;
                    exp.amount = double.parse(_ctrlAmount.text);
                    exp.date = date;
                    await ExpenseDatabaseHelper.insertExpense(exp);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text("Expense record added!")));
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text("One/ more fields empty!")));
                  }
                },
                child: const Icon(Icons.add, color: kPrimaryLightColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
