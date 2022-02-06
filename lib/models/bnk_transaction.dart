class BankTransaction {
  String ? id;
  String ? bank;
  int ? month;
  int ? year;
  double ? debitedAmt;
  double ? creditedAmt;

  BankTransaction({this.bank, this.month, this.year, this.debitedAmt, this.creditedAmt});

  //Convert a BnkTransaction object into a Map object
  Map<String, dynamic> toMap() => {
        "id": id,
        'bank': bank,
        'month': month,
        'year': year,
        'debitedAmt': debitedAmt,
        'creditedAmt': creditedAmt,
      };

  //Extract a BnkTransaction object from a Map object
  BankTransaction.fromMapObject(Map<String, dynamic> map) {
    id = map["id"];
    bank = map['bank'];
    month = map['month'];
    year = map['year'];
    debitedAmt = map['debitedAmt'];
    creditedAmt = map['creditedAmt'];
  }
}
