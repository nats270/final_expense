//import './models/details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/constants.dart';
import 'package:signup/models/details.dart';
import 'package:signup/utils/database_helper.dart';
import 'package:signup/widgets/list.dart';

const deepPurpleColor = Colors.deepPurple;

void main() {
  runApp(const MyAppp());
}

class MyAppp extends StatelessWidget {
  const MyAppp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyHomePage(title: 'Expense List');
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
  DatabaseHelper _dbHelper;

  final _formKey = GlobalKey<FormState>();
  final _ctrlAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      //print('db location :' +dataDirectory.path);
      _dbHelper = DatabaseHelper.instance;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.deepPurple,
          onPressed: (){
            Navigator.pop(context);
          },),
        backgroundColor: kPrimaryLightColor,
        title: Center(
          child: Text(
            widget.title,
            style: GoogleFonts.raleway(textStyle:TextStyle(
              color: kPrimaryColor,
            ),),
          ),
        ),
       actions: [
         IconButton(
           icon: Icon(Icons.savings,
           color: Colors.deepPurple,),)
       ],
      ),
      body: Column(
        children: <Widget>[_form(), list()],
      ),
      bottomNavigationBar: BottomAppBar(
        color: kPrimaryLightColor,
        child: IconButton(
          icon: Icon(
              Icons.refresh,
              color: kPrimaryColor,
          ),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListPage()));
          },
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('Add Expense Mode', style: TextStyle(color: Colors.deepPurple)),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 3),
                child: DropdownButtonFormField(
                  value: dropdownValueMode,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: modes.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onSaved: (String newValue) => setState(() => _details.items = newValue),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValueMode = newValue;
                    });
                  },
                ),
              ),
              const Text('Add Expense Category', style: TextStyle(color: Colors.deepPurple)),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 3),
                child: DropdownButtonFormField(
                  value: dropdownValueCategory,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((itemsList) {
                    return DropdownMenuItem(
                      value: itemsList,
                      child: Text(itemsList),
                    );
                  }).toList(),
                  onSaved: (String newValue) => setState(() => _details.itemslist = newValue),
                  onChanged: (String newValue) {
                    setState(
                      () {
                        dropdownValueCategory = newValue;
                      },
                    );
                  },
                ),
              ),
              SingleChildScrollView(
                child: TextFormField(
                  controller: _ctrlAmount,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.deepPurple,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter amount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter amount ',
                    labelStyle: TextStyle(color: Colors.deepPurple),
                  ),
                  onSaved: (val) => setState(() => _details.amount = val),
                ),
              ),
              TextFormField(
                controller: dateCtl,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter date';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  labelText: "Date of Transaction",
                  hintText: "Enter date",
                ),
                onTap: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());

                  date = (await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100)));

                  dateCtl.text = date.toString().substring(0, 11);
                },
                onSaved: (dateCtl) => setState(() => _details.date = dateCtl),
              ),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                CircleAvatar(
                  backgroundColor: kPrimaryLightColor,
                  child: IconButton(
                      onPressed: (){
                        _onAdd();
                  },
                      icon: const Icon(Icons.add, color: kPrimaryColor ,),
                  ),
                ),

                // RaisedButton.icon(
                //   onPressed: () {
                //     _onAdd();
                //   },
                //   //Navigator.of(context).push(MaterialPageRoute(builder: (_) => ListPage()));
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //   color: Colors.deepPurple,
                //   icon: const Icon(Icons.add, color: Colors.white),
                //   label: const Text('ADD', style: TextStyle(color: Colors.white)),
                // ),
                // RaisedButton.icon(
                //   onPressed: () {
                //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListPage()));
                //     //Navigator.of(context).push(MaterialPageRoute(builder: (_) => PieChartPage()));
                //   },
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //   color: Colors.deepPurple,
                //   icon: const Icon(Icons.refresh, color: Colors.white),
                //   label: const Text('REFRESH', style: TextStyle(color: Colors.white)),
                // ),
              ]),
            ],
          ),
        ),
      );

  _refreshDetailsList() async {
    List<Details> x = await _dbHelper.fetchDetail();
    setState(() {
      _detail = x;
    });
  }

  _onAdd() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_details.id == null) {
        await _dbHelper.insertDetails(_details);
      } else {
        await _dbHelper.updateDetails(_details);
      }
      _refreshDetailsList();
      _resetForm();
    }
  }

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

  list() => Expanded(
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
