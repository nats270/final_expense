import 'package:flutter/material.dart';

class PieData{
  static List<Details> details = [
    Details(itemslist : 'SHOPPING' , color : const Color(0xff0293ee) , percent : 30),
    Details(itemslist : 'GIFT' , color : const Color(0xffF67890) , percent : 20),
    Details(itemslist : 'BUSINESS', color : const Color(0xFF86D00F), percent : 15),
    Details(itemslist : 'FOOD', color : const Color(0xB0FA4D92) , percent : 15),
    Details(itemslist : 'GAMING',  color : const Color(0xD9DC2620), percent : 10),
    Details(itemslist : 'CHARITY',  color : const Color(0x3e40ffd9), percent : 10)
  ];
}


class Details{

  static const tblDetails ='detail';
  static const tblId ='id';
  static const tblItems ='items';
  static const tblItemslist ='itemslist';
  static const tblAmount ='amount';
  static const tblDate ='date';

  Details({
    this.id,
    this.items,
    this.amount,
    this.date,
    this.itemslist,
    this.percent,
    this.color});

  //Details({required this.id,required this.title,required this.description,required this.amount,required this.listitem,required this.date})

  Details.fromMap(Map<String,dynamic> map){
    id = map[tblId];
    items = map[tblItems];
    amount = map[tblAmount];
    date = map[tblDate];
    itemslist = map[tblItemslist];

  }

  int id;
  String items;
  String amount;
  String date;
  String itemslist;
  Color color;
  int percent;


  Map<String,dynamic> toMap(){
    var map = <String,dynamic> {
      tblItems: items,
      tblItemslist: itemslist,
      tblAmount: amount,
      tblDate: date,
    };
    if (id != null) {
      map[tblId]=id;
    }
    return map;
  }
}