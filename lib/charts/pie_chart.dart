import 'package:flutter/material.dart';

import '../constants.dart';

class PieChartWidget extends StatefulWidget {
  final String name;

  const PieChartWidget(this.name, {Key key}) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.name,
          style: const TextStyle(color: kPrimaryColor),
        ),
        backgroundColor: kPrimaryLightColor,
      ),
      body: SizedBox(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.next_week),
        onPressed: () {},
      ),
    );
  }
}
