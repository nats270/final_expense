import 'package:flutter/material.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/utils/txn_database_helper.dart';
import 'package:signup/utils/txn_utils.dart';
import 'package:signup/utils/values.dart';

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
        backgroundColor: kPrimaryLightColor,
        title: const Text(
          "Month-wise Transactions",
          style: TextStyle(color: kPrimaryColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await TransactionDatabaseHelper.syncFirebaseRecords();
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
          final data = snapshot.connectionState == ConnectionState.done ? TransactionGroupUp.groupSmsFromTransactions(snapshot.data) : null;
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
                      monthMap[e.key],
                      style: const TextStyle(fontSize: 18),
                    ),
                    ...e.value.entries
                        .map(
                          (e) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.key),
                              Builder(builder: (c_) {
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
                                return Row(
                                  children: [
                                    Expanded(child: Text("Debit: ${val["debit"]}")),
                                    Expanded(child: Text("Credit: ${val["credit"]}")),
                                  ],
                                );
                              }),
                            ],
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
