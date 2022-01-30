//import './models/details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/models/details.dart';
import 'package:signup/utils/auth_database_helper.dart';

import '../constants.dart';

const deepPurpleColor = Colors.deepPurple;

void main() {
  runApp(const ListPage());
}

class ListPage extends StatelessWidget {
  const ListPage({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: 'Expense Card');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController dateCtl = TextEditingController();

  Details _details = Details(amount: '', date: '', itemslist: '', items: '', id: 1);
  List<Details> _detail = [];
  AuthDatabaseHelper _dbHelper;

  final _formKey = GlobalKey<FormState>();
  final _ctrlAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = AuthDatabaseHelper.instance;
    });
    _refreshDetailsList();
  }

  String dropdownValueMode = 'CASH';

  // List of items in our dropdown menu
  var modes = [
    'CASH',
    'UPI',
    'NET BANKING',
    'DEBIT CARD',
    'CREDIT CARD',
  ];

  String dropdownValueCategory = 'SHOPPING';

  var categories = [
    'SHOPPING',
    'GIFT',
    'BUSINESS',
    'GAMING',
    'FOOD',
    'CHARITY',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        backgroundColor: kPrimaryLightColor,
        title: Center(
          child: Text(
            widget.title,
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(color: kPrimaryColor),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.savings),
            onPressed: () {},
          )
        ],
      ),
      // appBar: AppBar(
      //   leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
      //     Navigator.pop(context);
      //   },),
      //   backgroundColor: deepPurpleColor,
      //   title: Center(
      //     child: Text(
      //       widget.title,
      //       style: const TextStyle(
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),
      body: Column(
        children: <Widget>[_list()],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _refreshDetailsList() async {
    List<Details> x = await _dbHelper.fetchDetail();
    setState(() {
      _detail = x;
    });
  }

  // _onAdd() async {
  //   var form = _formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     if (_details.id == null) {
  //       await _dbHelper.insertDetails(_details);
  //     } else {
  //       await _dbHelper.updateDetails(_details);
  //     }
  //     _refreshDetailsList();
  //     _resetForm();
  //   }
  // }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlAmount.clear();
      dateCtl.clear();
      dropdownValueCategory = categories[0];
      dropdownValueMode = modes[0];
      _details.id = null;
    });
  }

  _list() => Expanded(
        child: Card(
          margin: const EdgeInsets.all(5),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) => ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.money),
              ),
              title: Text(
                _detail[index].itemslist.toString(),
              ),
              subtitle:
                  //Text(this._detail[index].date),
                  SingleChildScrollView(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_detail[index].amount.toString()),
                  const SizedBox(height: 4, width: 4),
                  Text(_detail[index].items.toString()),
                  const SizedBox(height: 4, width: 4),
                  Text(_detail[index].date.toString()),
                ]),
              ),
              onTap: () {
                setState(() {
                  _details = _detail[index];
                  _ctrlAmount.text = _detail[index].amount;
                });
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.deepPurple),
                onPressed: () async {
                  await _dbHelper.deleteDetails(_detail[index].id);
                  _resetForm();
                  _refreshDetailsList();
                },
              ),
            ),
            itemCount: _detail.length,
            separatorBuilder: (_, __) => const Divider(height: 5),
          ),
        ),
      );
}
