import 'package:flutter/material.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/newScreens/bank_list_item.dart';
import 'package:signup/utilstwo/database_helper.dart';
import 'package:signup/utilstwo/values.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Set<String> bnkSet;
  Map<String, List<SmsMessage>> bankWiseMsgs = {};

  final SmsQuery _query = SmsQuery();

  bool _loading = true;
  int count = 0;

  void updateBankList() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BnkTransaction>> bnkTransactionListFuture = _databaseHelper.getBnkTransactionList();
      bnkTransactionListFuture.then((bnkTransactionList) {
        setState(() {
          _loading = false;
          for (var listItem in bnkTransactionList) {
            bnkSet.add(listItem.bank);
          }
          count = bnkSet.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bnkSet == null) {
      bnkSet = Set();
      updateBankList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Accounts'),
        backgroundColor: Colors.deepPurple[700],
      ),
      body: _homePageWidgets(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[700],
        child: const Icon(Icons.refresh),
        tooltip: 'Scan Messages',
        onPressed: () async {
          _databaseHelper.delete().then((res) {
            setState(() {
              _loading = true;
            });
            _query.querySms(kinds: [SmsQueryKind.Inbox]).then(_getMsgs);
          });
        },
      ),
    );
  }

  Widget _homePageWidgets() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (bnkSet.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Looks Like, its empty here \n Click Refresh button to scan Transaction",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey.withOpacity(0.5)),
          ),
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          children: bnkSet.map((String string) {
            return BankListItem(string);
          }).toList(growable: false),
        ));
  }

  void _getMsgs(List<SmsMessage> messages) async {
    // List<SmsMessage> _messages = List();
    List<SmsMessage> _messages = [];
    _messages = messages;
    print(_messages);
    if (_messages != null) {
      mapMsgsToBankNames(_messages);
    }
  }

  void mapMsgsToBankNames(List<SmsMessage> _messages) {
    final bankNameMap = {
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
    bankWiseMsgs = {
      'BOI': [],
      'CANARA': [],
      'KVB': [],
      'HDFC': [],
      'AXIS': [],
      'ICICI' :[],
      'SBI' :[],
      'CENTRAL BANK': [],
      'INDIAN BANK': [],
      'CENTRAL':[],
    };
    for (var i = 0; i < _messages.length; i++) {
      String msgAddress = _messages[i].address;
      SmsMessage msg = _messages[i];
      for (var key in bankNameMap.keys) {
        if (msgAddress.toLowerCase().endsWith(key.toLowerCase())) {
          bankWiseMsgs[bankNameMap[key]].add(msg);
        }
      }
    }
    makingTransactionObjects();
  }

  void makingTransactionObjects() {
    bankWiseMsgs.forEach((bnkName, msgs) async {
      if (msgs.isNotEmpty) {
        var currMonth = DateTime.now().month;
        var prevMonth = previousMonth(currMonth);
        var prevMonth2 = previousMonth(prevMonth);
        var currYear = whichYear(DateTime.now().year, DateTime.now().month);
        var prevYear = whichYear(currYear, currMonth);
        var year3 = whichYear(prevYear, prevMonth);
        double creditedAmt1 = 0;
        double creditedAmt2 = 0;
        double creditedAmt3 = 0;
        double debitedAmt1 = 0;
        double debitedAmt3 = 0;
        double debitedAmt2 = 0;

        // List<RegExp> credits = [
        //   RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* has been CREDITED", caseSensitive: false),
        //   RegExp(r"CREDITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
        // ];
        // List<RegExp> debits = [
        //   RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* has been DEBITED", caseSensitive: false),
        //   RegExp(r"DEBITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
        //];
        List<RegExp> deposits = [
          RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* has been DEPOSITED", caseSensitive: false),
          RegExp(r"(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*.* was DEPOSITED", caseSensitive: false),
          RegExp(r"DEPOSITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
          RegExp(r"has been DEPOSITED.*(INR|Rs\.|Rs) *\d+(,\d+)*\.?\d*", caseSensitive: false),
        ];

        List<RegExp> credits = [
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
        List<RegExp> debits = [
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

        for (var msg in msgs) {
          for (final credit in credits) {
            if (credit.firstMatch(msg.body.toString()) != null) {
              var string = credit.stringMatch(msg.body.toString());
              if (msg.date.month == currMonth) {
                creditedAmt1 += _getAmountFromString(string);
              } else if (msg.date.month == prevMonth) {
                creditedAmt2 += _getAmountFromString(string);
              } else if (msg.date.month == prevMonth2) {
                creditedAmt3 += _getAmountFromString(string);
              }
            }
          }
          for (final debit in debits) {
            if (debit.firstMatch(msg.body.toString()) != null) {
              var string = debit.stringMatch(msg.body.toString());
              if (msg.date.month == currMonth) {
                debitedAmt1 += _getAmountFromString(string);
              } else if (msg.date.month == prevMonth) {
                debitedAmt2 += _getAmountFromString(string);
              } else if (msg.date.month == prevMonth2) {
                debitedAmt3 += _getAmountFromString(string);
              }
            }
          }
          for (final deposit in deposits) {
            if (deposit.firstMatch(msg.body.toString()) != null) {
              var string = deposit.stringMatch(msg.body.toString());
              if (msg.date.month == currMonth) {
                creditedAmt1 += _getAmountFromString(string);
              } else if (msg.date.month == prevMonth) {
                creditedAmt2 += _getAmountFromString(string);
              } else if (msg.date.month == prevMonth2) {
                creditedAmt3 += _getAmountFromString(string);
              }
            }
          }

          print(msg.body);
        }
        BnkTransaction transMonth1 = BnkTransaction(bnkName, currMonth, currYear, debitedAmt1, creditedAmt1);
        BnkTransaction transMonth2 = BnkTransaction(bnkName, prevMonth, prevYear, debitedAmt2, creditedAmt2);
        BnkTransaction transMonth3 = BnkTransaction(bnkName, prevMonth2, year3, debitedAmt3, creditedAmt3);

        _databaseHelper.insert(transMonth1);
        _databaseHelper.insert(transMonth2);
        _databaseHelper.insert(transMonth3);
      }
    });
    updateBankList();
  }

  double _getAmountFromString(String string) {
    RegExp exp = RegExp(r"\d+(,\d+)*\.?\d*");
    double amount = double.parse(exp.stringMatch(string).toString().replaceAll(",", ""));
    amount = double.parse(amount.toStringAsPrecision(2));
    return amount;
  }
}
