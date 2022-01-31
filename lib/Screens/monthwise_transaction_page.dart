import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/utils/txn_database_helper.dart';
import 'package:signup/utils/txn_utils.dart';

import '../constants.dart';

class MonthWiseTransactionPage extends StatefulWidget {
  static const routeName = "/monthly-txn-page";

  const MonthWiseTransactionPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MonthWiseTransactionPageState();
}

class _MonthWiseTransactionPageState extends State<MonthWiseTransactionPage> {
  List<BankTransaction> transactionList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Month-wise Transactions"),
        actions: [
          IconButton(
            onPressed: () async {
              await TransactionDatabaseHelper.syncFirebaseRecords();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text("Sync Complete")));
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<BankTransaction>>(
        future: TransactionDatabaseHelper.getAllSqliteTransactions(),
        builder: (ctx, snapshot) {
          final data = snapshot.connectionState == ConnectionState.done ? GroupUpUtil.groupSmsFromTransactions(snapshot.data) : null;
          return data == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (c, idx) => _YearWiseMonthWiseBankWiseTxn(data: data.entries.toList()[idx]),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: data.length,
                );
        },
      ),
    );
  }
}

class _YearWiseMonthWiseBankWiseTxn extends StatelessWidget {
  final MapEntry<int, Map<int, Map<String, List<BankTransaction>>>> data;

  const _YearWiseMonthWiseBankWiseTxn({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.key.toString(),
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        ...data.value.entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat("MMMM").format(DateTime(DateTime.now().year, e.key)),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...e.value.entries
                        .map(
                          (e) => Builder(
                            builder: (c_) {
                              final val = e.value.fold<Map<String, double>>(
                                {"debit": 0, "credit": 0},
                                (previousValue, element) {
                                  if (element.debitedAmt != null) {
                                    previousValue["debit"] += element.debitedAmt;
                                  } else {
                                    previousValue["credit"] += element.creditedAmt;
                                  }
                                  return previousValue;
                                },
                              );
                              return IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text(
                                      e.key,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const VerticalDivider(),
                                    Expanded(
                                      child: Text("Debit: ${val["debit"].toStringAsFixed(2)}", textAlign: TextAlign.right),
                                    ),
                                    Expanded(
                                      child: Text("Credit: ${val["credit"].toStringAsFixed(2)}", textAlign: TextAlign.right),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
