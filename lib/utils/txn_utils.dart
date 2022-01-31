import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/models/expense.dart';
import 'package:sms_advanced/sms_advanced.dart';

class TransactionUtils {
  static const bankNameMap = {
    "BOIIND": 'BOI',
    "CANBNK": 'CANARA',
    "KVBANK": 'KVB',
    "HDFCBK": 'HDFC',
    "AxisBk": 'AXIS',
    "ICICIB": "ICICI",
    "SBI": "SBI",
    "CENTBK": "CENTRAL BANK",
    "IndBnk": "INDIAN BANK",
    "CBoI": "CENTRAL"
  };

  static Map<Color, double> totalAmounts(List<BankTransaction> txns) {
    final map = <Color, double>{};
    for (final txn in txns) {
      if (txn.debitedAmt != null) {
        map.update(Colors.red, (value) => value + txn.debitedAmt, ifAbsent: () => txn.debitedAmt);
      } else {
        map.update(Colors.green, (value) => value + txn.creditedAmt, ifAbsent: () => txn.creditedAmt);
      }
    }
    map.putIfAbsent(Colors.red, () => 0);
    map.putIfAbsent(Colors.green, () => 0);
    return map;
  }

  static Map<Color, int> totalCount(List<BankTransaction> txns) {
    final map = <Color, int>{};
    for (final txn in txns) {
      if (txn.debitedAmt != null) {
        map.update(Colors.red, (value) => value + 1, ifAbsent: () => 1);
      } else {
        map.update(Colors.green, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    map.putIfAbsent(Colors.red, () => 0);
    map.putIfAbsent(Colors.green, () => 0);
    return map;
  }
}

class TransactionSMSParser {
  static final List<RegExp> depositFormats = [
    RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* has been DEPOSITED", caseSensitive: false),
    RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* was DEPOSITED", caseSensitive: false),
    RegExp(r"DEPOSITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"has been DEPOSITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
  ];
  static final List<RegExp> creditFormats = [
    RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* has been CREDITED", caseSensitive: false),
    RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* CREDITED", caseSensitive: false),
    RegExp(r"CREDITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"CREDITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"has been CREDITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"was CREDITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"is CREDITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"had been CREDITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"is CREDITED by (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"CREDITED by (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
  ];
  static final List<RegExp> debitFormats = [
    RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* has been DEBITED", caseSensitive: false),
    RegExp(r"DEBITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"DEBITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"has been DEBITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"was DEBITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"DEBITED for (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"DEBITED by (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"is DEBITED by (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"is DEBITED with (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
    RegExp(r"is DEBITED for (INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
  ];

  static BankTransaction parseSingleSMS(SmsMessage message) {
    double parseAmount(String string) {
      RegExp exp = RegExp(r"\d+(,\d+)*\.?\d*");
      double amount = double.parse(exp.stringMatch(string).toString().replaceAll(",", ""));
      amount = double.parse(amount.toStringAsPrecision(2));
      return amount;
    }

    final txn = BankTransaction();
    for (final bankAddress in TransactionUtils.bankNameMap.keys) {
      if (message.sender.toLowerCase().endsWith(bankAddress.toLowerCase())) {
        txn.bank = TransactionUtils.bankNameMap[bankAddress];
        break;
      }
    }

    if (txn.bank == null) return null;

    for (final credit in (creditFormats + depositFormats)) {
      if (credit.firstMatch(message.body.toString()) != null) {
        txn.creditedAmt = parseAmount(credit.stringMatch(message.body.toString()));
        break;
      }
    }
    for (final debit in debitFormats) {
      if (debit.firstMatch(message.body.toString()) != null) {
        txn.debitedAmt = parseAmount(debit.stringMatch(message.body.toString()));
        break;
      }
    }

    if (txn.creditedAmt == null && txn.debitedAmt == null) {
      print(message.body);
      print("txn with no debit or credit");
      return null;
    }

    txn.year = message.date.year;
    txn.month = message.date.month;

    return txn;
  }

  static List<BankTransaction> parseSmsList(List<SmsMessage> messages) {
    final List<BankTransaction> result = [];
    for (final message in messages) {
      final txn = parseSingleSMS(message);
      if (txn != null) result.add(txn);
    }
    return result;
  }
}

class GroupUpUtil {
  // bank transactions
  static Map<int, Map<int, Map<String, List<BankTransaction>>>> groupSmsFromMessages(List<SmsMessage> messages) {
    /*
    *
    * return Structure:
    *
    * {
    * year: {
    *   month: {
    *     bank_name : [transactions]
    *     }
    *   }
    * }
    *
    */

    final result = <int, Map<int, Map<String, List<BankTransaction>>>>{};
    for (final message in messages) {
      final txn = TransactionSMSParser.parseSingleSMS(message);
      if (txn == null) continue;
      result.update(
        txn.year,
        (prevValue) => prevValue
          ..update(
            txn.month,
            (prevValue) => prevValue
              ..update(
                txn.bank,
                (prevValue) => prevValue..add(txn),
                ifAbsent: () => [txn],
              ),
            ifAbsent: () {
              final m = <String, List<BankTransaction>>{};
              m.update(txn.bank, (prevValue) => prevValue..add(txn), ifAbsent: () => [txn]);
              return m;
            },
          ),
        ifAbsent: () {
          final r = <int, Map<String, List<BankTransaction>>>{};
          r.update(
            txn.month,
            (prevValue) => prevValue
              ..update(
                txn.bank,
                (prevValue) => prevValue..add(txn),
                ifAbsent: () => [txn],
              ),
            ifAbsent: () {
              final m = <String, List<BankTransaction>>{};
              m.update(
                txn.bank,
                (prevValue) => prevValue..add(txn),
                ifAbsent: () => [txn],
              );
              return m;
            },
          );
          return r;
        },
      );
    }
    return result;
  }

  static Map<int, Map<int, Map<String, List<BankTransaction>>>> groupSmsFromTransactions(List<BankTransaction> txns) {
    /*
    *
    * return Structure:
    *
    * {
    * year: {
    *   month: {
    *     bank_name : [transactions]
    *     }
    *   }
    * }
    *
    */

    final result = <int, Map<int, Map<String, List<BankTransaction>>>>{};
    for (final txn in txns) {
      if (txn == null) continue;
      result.update(
        txn.year,
        (prevValue) => prevValue
          ..update(
            txn.month,
            (prevValue) => prevValue
              ..update(
                txn.bank,
                (prevValue) => prevValue..add(txn),
                ifAbsent: () => [txn],
              ),
            ifAbsent: () {
              final m = <String, List<BankTransaction>>{};
              m.update(txn.bank, (prevValue) => prevValue..add(txn), ifAbsent: () => [txn]);
              return m;
            },
          ),
        ifAbsent: () {
          final r = <int, Map<String, List<BankTransaction>>>{};
          r.update(
            txn.month,
            (prevValue) => prevValue
              ..update(
                txn.bank,
                (prevValue) => prevValue..add(txn),
                ifAbsent: () => [txn],
              ),
            ifAbsent: () {
              final m = <String, List<BankTransaction>>{};
              m.update(
                txn.bank,
                (prevValue) => prevValue..add(txn),
                ifAbsent: () => [txn],
              );
              return m;
            },
          );
          return r;
        },
      );
    }
    return result;
  }

  static Map<String, List<BankTransaction>> groupBankWise(List<BankTransaction> txns) {
    final map = <String, List<BankTransaction>>{};
    for (final txn in txns) {
      map.update(txn.bank, (value) => value..add(txn), ifAbsent: () => [txn]);
    }
    return map;
  }

  // expenses
  static Map<int, Map<int, List<Expense>>> groupExpenses(List<Expense> exps) {
    /*
    *
    * return Structure:
    *
    * {
    * year: {
    *   month: [expenses]
    * }
    *
    */

    final result = <int, Map<int, List<Expense>>>{};
    for (final txn in exps) {
      if (txn == null) continue;
      result.update(
        txn.date.year,
        (prevValue) => prevValue
          ..update(
            txn.date.month,
            (prevValue) => prevValue..add(txn),
            ifAbsent: () => [txn],
          ),
        ifAbsent: () {
          final r = <int, List<Expense>>{};
          r.update(
            txn.date.month,
            (prevValue) => prevValue..add(txn),
            ifAbsent: () => [txn],
          );
          return r;
        },
      );
    }
    return result;
  }
}
