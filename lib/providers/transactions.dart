import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final String title;
  final double value;
  final String category;
  final IconData iconData;
  final Color color;

  const Transaction({
    @required this.id,
    @required this.title,
    @required this.value,
    @required this.category,
    @required this.iconData,
    @required this.color,
  });
}

class Transactions with ChangeNotifier {
  final List<Transaction> _transactions = [
    const Transaction(
      id: 1,
      title: 'Dinner',
      value: 128,
      category: 'Meals',
      iconData: Icons.fastfood,
      color: Color(0xffe8505b),
    ),
    const Transaction(
      id: 2,
      title: 'Birthday Present',
      value: 48,
      category: 'Gifts',
      iconData: Icons.cake,
      color: Color(0xfffe91ca),
    ),
    const Transaction(
      id: 3,
      title: 'PC Game',
      value: 28,
      category: 'Gaming',
      iconData: Icons.gamepad,
      color: Color(0xfff6d743),
    ),
    const Transaction(
      id: 4,
      title: 'Softwares',
      value: 150,
      category: 'Business',
      iconData: Icons.work,
      color: Color(0xff40bad5),
    ),
    const Transaction(
      id: 5,
      title: 'Books',
      value: 35,
      category: 'Entertainment',
      iconData: Icons.casino,
      color: Color(0xfff57b51),
    ),
    const Transaction(
      id: 6,
      title: 'Breakfast',
      value: 15,
      category: 'Meals',
      iconData: Icons.fastfood,
      color: Color(0xffe8505b),
    )
  ];
  List<Transaction> get transactions {
    return _transactions;
  }
}
