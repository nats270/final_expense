import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:signup/models/bnk_transaction.dart';
import 'package:signup/models/expense.dart';
import 'package:signup/utils/auth_database_helper.dart';
import 'package:signup/utils/permission_utils.dart';
import 'package:signup/utils/txn_utils.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sqflite/sqflite.dart';

class TransactionDatabaseHelper {
  // Sqlite Part
  static Database ? _sqliteDatabaseInstance;

  static const String _tableName = "bnk_transactions";

  static Future<Database?> get _sqliteDatabase async {
    _sqliteDatabaseInstance ??= await _initializeDatabase();
    return _sqliteDatabaseInstance;
  }

  static Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'transactions.db');

    var transactionsDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return transactionsDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute(
      '''CREATE TABLE $_tableName(
id TEXT PRIMARY KEY,
bank TEXT,
month INTEGER, 
year INTEGER,
debitedAmt REAL, 
creditedAmt REAL
)''',
    );
  }

  static Future<int> _insertSqliteTransaction(BankTransaction bnkTransaction) async {
    Database? db = await _sqliteDatabase;
    var result = db!.insert(_tableName, bnkTransaction.toMap());
    return result;
  }

  static Future<List<BankTransaction>> getAllSqliteTransactions() async {
    Database? db = await _sqliteDatabase;
    var result = await db!.query(_tableName);
    return result.map((e) => BankTransaction.fromMapObject(e)).toList();
  }

  static Future<List<BankTransaction>> getBankWiseTransactions(String bankName) async {
    Database? db = await _sqliteDatabase;
    var result = await db!.query(
      _tableName,
      where: 'bank = ?',
      whereArgs: [bankName],
      orderBy: 'year DESC, month DESC',
    );

    return result.map((e) => BankTransaction.fromMapObject(e)).toList();
  }

  static Future<int> _deleteSqliteRecords() async {
    Database? db = await _sqliteDatabase;
    int result = await db!.delete(_tableName);
    return result;
  }

  // Firebase Part
  static final _firebaseFireStore = FirebaseFirestore.instance;

  static final _txnCollection = _firebaseFireStore.collection('transactions').doc(FirebaseAuthService.currentUser!.uid).collection("userTxn");

  static Future<void> _updateFirebaseTxn(BankTransaction transaction) async {
    final doc = _txnCollection.doc(transaction.id);
    transaction.id ??= doc.id;
    if ((await doc.get()).exists) {
      doc.update(transaction.toMap());
    } else {
      doc.set(transaction.toMap());
    }
  }

  static Future<void> _deleteFirebaseRecords() async {
    final docs = (await _txnCollection.snapshots().first).docs;
    for (final doc in docs) {
      doc.reference.delete();
    }
  }

  // combo
  static Future<void> insertAllTxn(List<BankTransaction> transactions) async {
    for (final txn in transactions) {
      await insertTxn(txn);
    }
  }

  static Future<void> insertTxn(BankTransaction transaction) async {
    await _updateFirebaseTxn(transaction);
    await _insertSqliteTransaction(transaction);
  }

  static Future<void> deleteRecords() async {
    await _deleteSqliteRecords();
    _deleteFirebaseRecords();
  }

  static Future<void> syncFirebaseRecords() async {
    await PermissionUtils.requestPermission();
    await deleteRecords();
    final query = SmsQuery();
    final smsList = await query.querySms();
    for (final sms in smsList) {
      final txn = TransactionSMSParser.parseSingleSMS(sms);
      if (txn != null) {
        await _updateFirebaseTxn(txn);
        await insertTxn(txn);
      }
    }
  }
}

class ExpenseDatabaseHelper {
  // Sqlite Part
  static const _tableName = "manual_expenses";
  static const _databaseName = 'expenses.db';
  static const _databaseVersion = 1;

  static Database ? _databaseInstance;

  static Future<Database?> get _database async {
    if (_databaseInstance != null) return _databaseInstance;
    _databaseInstance = await _initDatabase();
    return _databaseInstance;
  }

  static Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreateDB);
  }

  static void _onCreateDB(Database db, int version) async {
    await db.execute('''CREATE TABLE $_tableName(
id TEXT PRIMARY KEY,
expenseMode TEXT NOT NULL,
expenseCategory TEXT NOT NULL,
date TEXT NOT NULL,
amount REAL NOT NULL
)''');
  }

  static Future<void> _insertSqliteExpense(Expense exp) async {
    Database? db = await _database;
    await db!.insert(_tableName, exp.toMap());
  }

  static Future<void> _updateSqliteExpense(Expense exp) async {
    Database? db = await _database;
    await db!.update(_tableName, exp.toMap(), where: 'id=?', whereArgs: [exp.id]);
  }

  static Future<void> _deleteSqliteExpense(Expense exp) async {
    Database? db = await _database;
    await db!.delete(_tableName, where: 'id=?', whereArgs: [exp.id]);
  }

  static Future<List<Expense>> fetchAllSqliteRecords() async {
    Database? db = await _database;
    List<Map<String, dynamic>> detail = await db!.query(_tableName);
    return detail.isEmpty ? [] : detail.map((e) => Expense.fromMap(e)).toList();
  }

  static Future<int> _deleteSqliteRecords() async {
    Database? db = await _database;
    int result = await db!.delete(_tableName);
    return result;
  }

  // Firebase Part
  static final _firebaseFireStore = FirebaseFirestore.instance;
  static final _expenseCollection = _firebaseFireStore.collection('transactions').doc(FirebaseAuthService.currentUser!.uid).collection("expenses");

  static Future<void> _updateFirebaseExpense(Expense exp) async {
    final doc = _expenseCollection.doc(exp.id);
    exp.id ??= doc.id;
    if ((await doc.get()).exists) {
      doc.update(exp.toMap());
    } else {
      doc.set(exp.toMap());
    }
  }

  static Future<void> _deleteFirebaseExpense(Expense exp) async {
    final doc = _expenseCollection.doc(exp.id);
    if ((await doc.get()).exists) {
      await doc.delete();
    }
  }

  // combo
  static Future<void> insertExpense(Expense exp) async {
    await _updateFirebaseExpense(exp);
    await _insertSqliteExpense(exp);
  }

  static Future<void> updateExpense(Expense exp) async {
    await _updateFirebaseExpense(exp);
    await _updateSqliteExpense(exp);
  }

  static Future<void> deleteExpense(Expense exp) async {
    await _deleteSqliteExpense(exp);
    _deleteFirebaseExpense(exp);
  }

  static Future syncFirebaseRecords() async {
    final exps = await fetchAllSqliteRecords();
    final expIds = exps.map((e) => e.id).toList();
    final docs = (await _expenseCollection.snapshots().first).docs;
    for (final doc in docs) {
      if (!expIds.contains(doc.id)) {
        _insertSqliteExpense(Expense.fromMap(doc.data()));
      }
    }
  }
}
