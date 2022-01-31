import 'dart:ui';

class Expense {
  static const expenseModeColors = {
    'CASH': Color(0xff0293ee),
    'UPI': Color(0xffF67890),
    'NET BANKING': Color(0xFF86D00F),
    'DEBIT CARD': Color(0xD9DC2620),
    'CREDIT CARD': Color(0xB0FA4D92),
  };

  static const expenseCategoryColors = {
    'SHOPPING': Color(0xff0293ee),
    'GIFT': Color(0xffF67890),
    'BUSINESS': Color(0xFF86D00F),
    'GAMING': Color(0xD9DC2620),
    'FOOD': Color(0xB0FA4D92),
    'CHARITY': Color(0x3e40ffd9),
  };

  String id;
  String expenseMode;
  String expenseCategory;
  double amount;
  DateTime date;

  Expense.empty();

  Expense.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    expenseMode = map["expenseMode"];
    expenseCategory = map["expenseCategory"];
    amount = map["amount"];
    date = DateTime.parse(map["date"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "amount": amount,
      "date": date.toIso8601String(),
      "expenseMode": expenseMode,
      "expenseCategory": expenseCategory,
    };
  }
}
