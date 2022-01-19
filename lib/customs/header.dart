// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:signup/constants.dart';
// import 'package:signup/providers/transactions.dart';
// import '../models/expense.dart';
// import './expense_chart.dart';
//
// class Header extends StatelessWidget {
//   final Function addTransaction;
//
//   const Header(this.addTransaction);
//
//   static final List<charts.Series<Expense, String>> _series =
//     [
//       charts.Series<Expense, String>(
//         id: 'Expense',
//         domainFn: (Expense expense, _) => expense.category,
//         measureFn: (Expense expense, _) => expense.value,
//         labelAccessorFn: (Expense expense, _) => '\$${expense.value}',
//         colorFn: (Expense expense, _) =>
//             charts.ColorUtil.fromDartColor(expense.color),
//         data: [
//           Expense('Business', 150, Color(0xff40bad5)),
//           Expense('Games', 80, Color(0xffe8505b)),
//           Expense('Shopping', 70, Color(0xfffe91ca)),
//           Expense('Gifts', 30, Color(0xfff6d743)),
//           Expense('Entertainment', 43, Color(0xfff57b51)),
//         ],
//       )
//     ];
//
//
//  // const Header({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     //final primaryColor = Theme.of(context).primaryColor;
//
//     return Container(
//       width: double.infinity,
//       height: mediaQuery.size.height * 0.4,
//       color: kPrimaryColor,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               height: 150,
//               child: ExpenseChart(
//                 _series,
//                 animate: true,
//               ),
//             ),
//             const SizedBox(height: 14,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children:<Widget>[
//                 OutlineButton(
//                     onPressed: addTransaction,
//                     borderSide: const BorderSide(
//                       width: 1,
//                       color: Colors.white,
//                     ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Container(
//                     width: 124,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         const Icon(
//                           Icons.playlist_add,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(width: 4,height: 3,),
//                         const Text(
//                           'Add Transaction',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 FlatButton(
//                   onPressed: () {},
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child : Container(
//                     width: 124,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           'REPORTS',
//                           style: TextStyle(
//                             color: kPrimaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Icon(
//                           Icons.navigate_next,
//                           color: kPrimaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16,),
//             Padding(
//               padding: const EdgeInsets.only(left: 12,),
//               child: const Text(
//                 'Transactions',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
