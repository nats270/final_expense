import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signup/Screens/expense_add_page.dart';
import 'package:signup/models/expense.dart';
import 'package:signup/utils/txn_database_helper.dart';

class ExpenseListPage extends StatefulWidget {
  static const routeName = "/expense-list-page";

  const ExpenseListPage({Key key}) : super(key: key);

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
        actions: [
          IconButton(
            onPressed: () async {
              await ExpenseDatabaseHelper.syncFirebaseRecords();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text("Sync Complete")));
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed(ExpenseAddPage.routeName);
              setState(() {});
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<Expense>>(
        future: ExpenseDatabaseHelper.fetchAllSqliteRecords(),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snap.data;
          if (data == null) {
            return const Center(
              child: Text("No expenses to show!"),
            );
          }
          data.sort((a, b) => b.date.compareTo(a.date));
          return ListView.separated(
            itemBuilder: (c, idx) => ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat("dd MMM yyyy").format(data[idx].date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(data[idx].expenseCategory),
              subtitle: Text(data[idx].expenseMode),
              trailing: Text("Rs. ${data[idx].amount.toStringAsFixed(2)}"),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 3),
            itemCount: data.length,
          );
        },
      ),
    );
  }
}
