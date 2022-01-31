import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/utils/report_utils.dart';
import 'package:signup/utils/txn_database_helper.dart';
import 'package:signup/utils/txn_utils.dart';
import 'package:signup/widgets/navigation_drawer.dart';

class SMSAnalysisReportScreen extends StatefulWidget {
  static const routeName = "/sms-analysis-report-screen";

  const SMSAnalysisReportScreen({Key key}) : super(key: key);

  @override
  _SMSAnalysisReportScreenState createState() => _SMSAnalysisReportScreenState();
}

class _SMSAnalysisReportScreenState extends State<SMSAnalysisReportScreen> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<BankTransaction> _txns;
  Map<int, Map<int, Map<String, List<BankTransaction>>>> _detailedTransactions;
  bool bar = false;
  int year = -1, month = -1;

  @override
  void initState() {
    _controller = TabController(
      length: tabAndBody.length,
      initialIndex: 0,
      vsync: this,
    );
    Future.delayed(Duration.zero).then((_) async {
      _txns = await TransactionDatabaseHelper.getAllSqliteTransactions();
      _detailedTransactions = GroupUpUtil.groupSmsFromTransactions(_txns);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabAndBody.length,
      child: Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text('SMS Analysis Report'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    const colorBoxSize = 10.0;
                    return AlertDialog(
                      title: const Center(child: Text("Legend")),
                      content: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                        child: ListView(
                          shrinkWrap: true,
                          children: {"Credit": Colors.green, "Debit": Colors.red}
                              .entries
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(
                                    children: [
                                      Container(height: colorBoxSize, width: colorBoxSize, color: e.value),
                                      const SizedBox(width: 5),
                                      Text(e.key),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.help_outline),
            ),
          ],
          bottom: TabBar(
            controller: _controller,
            tabs: tabAndBody.keys.toList(),
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: tabAndBody.values.toList(),
        ),
      ),
    );
  }

  Map<Tab, Widget> get tabAndBody {
    return {
      const Tab(child: Text("Yearly")): yearlyStats,
      const Tab(child: Text("Monthly")): monthlyStats,
    };
  }

  Widget get yearlyStats {
    if (_detailedTransactions == null) return const Center(child: CircularProgressIndicator());
    final yearly = <int, Map<String, List<BankTransaction>>>{};
    for (var element in _detailedTransactions.entries) {
      yearly.update(
        element.key,
        (value) {
          for (final monthEntry in element.value.entries) {
            for (final bankEntry in monthEntry.value.entries) {
              value.update(bankEntry.key, (value) => value..addAll(bankEntry.value), ifAbsent: () => bankEntry.value);
            }
          }
          return value;
        },
        ifAbsent: () {
          final map = <String, List<BankTransaction>>{};
          for (final monthEntry in element.value.entries) {
            for (final bankEntry in monthEntry.value.entries) {
              map.update(bankEntry.key, (value) => value..addAll(bankEntry.value), ifAbsent: () => bankEntry.value);
            }
          }
          return map;
        },
      );
    }
    if (year == -1) {
      year = yearly.keys?.first ?? 2022;
    }
    final data = yearly[year];
    const yearSize = 40.0, headingSize = 20.0, textSize = 16.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  "Select Year",
                  style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  items: yearly.keys
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(
                            e.toString(),
                            style: const TextStyle(fontSize: textSize),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  value: year,
                  onChanged: (val) {
                    setState(() {
                      year = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Center(
                child: Text(
                  year.toString(),
                  style: const TextStyle(fontSize: yearSize, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: data.entries.map((e) {
                  final bankName = e.key;
                  final bankData = e.value;
                  final totalAmounts = TransactionUtils.totalAmounts(bankData);
                  final totalCounts = TransactionUtils.totalCount(bankData);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          bankName,
                          style: const TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ReportUtils.pieChartTransactionBankWise(bankData),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 5,
                              child: ReportUtils.barChartTransactionBankWise(bankData),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: headingSize),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Credit: Rs. ${totalAmounts[Colors.green]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Debit: Rs. ${totalAmounts[Colors.red]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Credit Txns: ${totalCounts[Colors.green]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Debit Txns: ${totalCounts[Colors.red]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get monthlyStats {
    if (_detailedTransactions == null) return const Center(child: CircularProgressIndicator());
    if (year == -1) {
      year = _detailedTransactions.keys.first;
    }
    final yearData = _detailedTransactions[year];
    if (month == -1) {
      month = yearData.keys.first;
    }
    final data = yearData[month];
    const yearSize = 40.0, headingSize = 20.0, textSize = 16.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  items: _detailedTransactions.keys
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(
                            e.toString(),
                            style: const TextStyle(fontSize: textSize),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  value: year,
                  onChanged: (val) {
                    setState(() {
                      year = val;
                      month = -1;
                    });
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  items: yearData.keys
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(
                            DateFormat("MMMM").format(DateTime(DateTime.now().year, e)),
                            style: const TextStyle(fontSize: textSize),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  value: month,
                  onChanged: (val) {
                    setState(() {
                      month = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Center(
                child: Text(
                  year.toString(),
                  style: const TextStyle(fontSize: yearSize, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: data.entries.map((e) {
                  final bankName = e.key;
                  final bankData = e.value;
                  final totalAmounts = TransactionUtils.totalAmounts(bankData);
                  final totalCounts = TransactionUtils.totalCount(bankData);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          bankName,
                          style: const TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ReportUtils.pieChartTransactionBankWise(bankData),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 5,
                              child: ReportUtils.barChartTransactionBankWise(bankData),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: headingSize),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Credit: Rs. ${totalAmounts[Colors.green]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Debit: Rs. ${totalAmounts[Colors.red]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Credit Txns: ${totalCounts[Colors.green]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Debit Txns: ${totalCounts[Colors.red]}",
                              style: const TextStyle(fontSize: textSize),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
