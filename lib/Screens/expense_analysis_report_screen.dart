import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signup/models/expense.dart';
import 'package:signup/utils/expense_utils.dart';
import 'package:signup/utils/report_utils.dart';
import 'package:signup/utils/txn_database_helper.dart';
import 'package:signup/utils/txn_utils.dart';
import 'package:signup/widgets/navigation_drawer.dart';

class ExpenseAnalysisReportScreen extends StatefulWidget {
  static const routeName = "/expense-analysis-report-screen";

  const ExpenseAnalysisReportScreen({Key ? key}) : super(key: key);

  @override
  _ExpenseAnalysisReportScreenState createState() => _ExpenseAnalysisReportScreenState();
}

class _ExpenseAnalysisReportScreenState extends State<ExpenseAnalysisReportScreen> with SingleTickerProviderStateMixin {
  late TabController _controller;
  late List<Expense> _expenses;
  late Map<int, Map<int, List<Expense>>> _detailedExpenses;
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
      _expenses = await ExpenseDatabaseHelper.fetchAllSqliteRecords();
      _detailedExpenses = GroupUpUtil.groupExpenses(_expenses);
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
          title: const Text('Expense Analysis Report'),
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
                          children: [
                            const Text(
                              "Modes:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: Expense.expenseModeColors.entries
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
                            const Divider(),
                            const Text(
                              "Categories:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children: Expense.expenseCategoryColors.entries
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
                          ],
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
    if (_detailedExpenses == null) return const Center(child: CircularProgressIndicator());
    final yearly = <int, List<Expense>>{};
    for (var element in (_detailedExpenses.entries)) {
      yearly.putIfAbsent(
        element.key,
        () => element.value.entries.fold<List<Expense>>(
          <Expense>[],
          (List<Expense> previousValue, MapEntry<int, List<Expense>> element) => previousValue..addAll(element.value),
        ),
      );
    }
    if (year == -1) {
      year = yearly.keys.first;
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
                            style: TextStyle(fontSize: textSize),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  value: year,
                  onChanged: (val) {
                    setState(() {
                      year = val.hashCode;
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
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Mode Values",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ReportUtils.pieChartExpensesModeValueWise(data!),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: ReportUtils.barChartExpensesModeValueWise(data),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: headingSize / 2),
              const Divider(),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Mode Count",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: ExpenseUtils.expenseModeCountMap(data).entries.map((e) {
                  return Row(
                    children: [
                      Expanded(child: Text(e.key, style: const TextStyle(fontSize: textSize, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: Text(e.value.toString(), style: const TextStyle(fontSize: textSize)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Category Values",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ReportUtils.pieChartExpensesCategoryValueWise(data),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: ReportUtils.barChartExpensesCategoryValueWise(data),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Category Count",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: ExpenseUtils.expenseCategoryCountMap(data).entries.map((e) {
                  return Row(
                    children: [
                      Expanded(child: Text(e.key, style: const TextStyle(fontSize: textSize, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: Text(e.value.toString(), style: const TextStyle(fontSize: textSize)),
                        ),
                      ),
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
    if (_detailedExpenses == null) return const Center(child: CircularProgressIndicator());
    if (year == -1) {
      year = _detailedExpenses.keys.first;
    }
    final yearData = _detailedExpenses[year];
    if (month == -1) {
      month = yearData!.keys.first;
    }
    final data = yearData![month];
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
                  items: _detailedExpenses.keys
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
                      year = val.hashCode;
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
                      month = val.hashCode;
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
                  DateFormat("MMMM").format(DateTime(DateTime.now().year, month)) + " " + year.toString(),
                  style: const TextStyle(fontSize: yearSize, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Mode Values",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ReportUtils.pieChartExpensesModeValueWise(data!),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: ReportUtils.barChartExpensesModeValueWise(data),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: headingSize / 2),
              const Divider(),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Mode Count",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: ExpenseUtils.expenseModeCountMap(data).entries.map((e) {
                  return Row(
                    children: [
                      Expanded(child: Text(e.key, style: const TextStyle(fontSize: textSize, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: Text(e.value.toString(), style: const TextStyle(fontSize: textSize)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Category Values",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ReportUtils.pieChartExpensesCategoryValueWise(data),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 5,
                      child: ReportUtils.barChartExpensesCategoryValueWise(data),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "By Category Count",
                  style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: ExpenseUtils.expenseCategoryCountMap(data).entries.map((e) {
                  return Row(
                    children: [
                      Expanded(child: Text(e.key, style: const TextStyle(fontSize: textSize, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: Text(e.value.toString(), style: const TextStyle(fontSize: textSize)),
                        ),
                      ),
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
