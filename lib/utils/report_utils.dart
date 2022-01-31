import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/models/expense.dart';
import 'package:signup/utils/txn_utils.dart';

class ReportUtils {
  static PieChart generalPieChart(Map<Color, double> colorValueMap) {
    double total = colorValueMap.values.fold(0, (previousValue, element) => previousValue + element);
    return PieChart(
      PieChartData(
        sectionsSpace: 5,
        sections: colorValueMap.entries
            .map(
              (e) => PieChartSectionData(
                color: e.key,
                title: (e.value / total).toStringAsFixed(2) + "%",
                value: e.value,
                showTitle: true,
              ),
            )
            .toList(),
      ),
    );
  }

  static BarChart generalBarChart(Map<Color, double> colorValueMap) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
        barGroups: colorValueMap.entries
            .map(
              (e) => BarChartGroupData(
                barRods: [
                  BarChartRodData(
                    y: e.value,
                    width: 5,
                    colors: [e.key],
                  ),
                ],
                // title: e.key,
                // value: e.value,
                // showTitle: true,
                x: colorValueMap.entries.toList().indexOf(e),
              ),
            )
            .toList(),
      ),
    );
  }

  static PieChart pieChartExpensesModeValueWise(List<Expense> exps) {
    final map = <Color, double>{};
    for (final exp in exps) {
      map.update(Expense.expenseModeColors[exp.expenseMode], (value) => value + exp.amount, ifAbsent: () => exp.amount);
    }
    return generalPieChart(map);
  }

  static BarChart barChartExpensesModeValueWise(List<Expense> exps) {
    final map = <Color, double>{};
    for (final exp in exps) {
      map.update(Expense.expenseModeColors[exp.expenseMode], (value) => value + exp.amount, ifAbsent: () => exp.amount);
    }
    return generalBarChart(map);
  }

  static PieChart pieChartExpensesCategoryValueWise(List<Expense> exps) {
    final map = <Color, double>{};
    for (final exp in exps) {
      map.update(Expense.expenseCategoryColors[exp.expenseCategory], (value) => value + exp.amount, ifAbsent: () => exp.amount);
    }
    return generalPieChart(map);
  }

  static BarChart barChartExpensesCategoryValueWise(List<Expense> exps) {
    final map = <Color, double>{};
    for (final exp in exps) {
      map.update(Expense.expenseCategoryColors[exp.expenseCategory], (value) => value + exp.amount, ifAbsent: () => exp.amount);
    }
    return generalBarChart(map);
  }

  static PieChart pieChartTransactionBankWise(List<BankTransaction> txns) {
    return generalPieChart(TransactionUtils.totalAmounts(txns));
  }

  static BarChart barChartTransactionBankWise(List<BankTransaction> txns) {
    return generalBarChart(TransactionUtils.totalAmounts(txns));
  }
}
