import 'package:hive/hive.dart';
import './Models/expense_model.dart';


class Boxes {
  static Box<ExpenseModel> getExpenses() =>
      Hive.box<ExpenseModel>('expenses');
}