import 'package:signup/models/expense.dart';

class ExpenseUtils {
  static Map<String, int> expenseModeCountMap(List<Expense> exps) {
    final map = <String, int>{};
    for (final exp in exps) {
      map.update(exp.expenseMode, (value) => value + 1, ifAbsent: () => 1);
    }
    return map;
  }

  static Map<String, int> expenseCategoryCountMap(List<Expense> exps) {
    final map = <String, int>{};
    for (final exp in exps) {
      map.update(exp.expenseCategory, (value) => value + 1, ifAbsent: () => 1);
    }
    return map;
  }
}
