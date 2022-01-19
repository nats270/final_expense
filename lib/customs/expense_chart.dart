// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'dart:math' show pi;
//
// class ExpenseChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;
//
//   ExpenseChart(
//     this.seriesList,
//     {this.animate}) ;
//
//   @override
//   Widget build(BuildContext context) {
//     return charts.PieChart(
//       seriesList,
//       animate: animate,
//       animationDuration: Duration(seconds: 8),
//       defaultRenderer: charts.ArcRendererConfig<String>(
//          arcWidth: 17,
//          startAngle: 4/5*pi,
//          strokeWidthPx: 0,
//          arcRendererDecorators: [
//             charts.ArcLabelDecorator(
//              labelPadding: 0,
//              showLeaderLines: false,
//              outsideLabelStyleSpec: const charts.TextStyleSpec(
//                fontSize: 12,
//                color: charts.MaterialPalette.white,
//              ),
//            ),
//          ],
//       ),
//       behaviors: [
//         charts.DatumLegend(
//           position: charts.BehaviorPosition.end,
//           outsideJustification: charts.OutsideJustification.start,
//           horizontalFirst: false,
//           desiredMaxColumns: 1,
//           cellPadding: const EdgeInsets.only(
//             right: 4,
//             bottom: 4,
//           ),
//           entryTextStyle: charts.TextStyleSpec(
//             fontSize: 12,
//             color: charts.MaterialPalette.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
