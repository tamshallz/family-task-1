import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'expense_model.g.dart';

/// Creating Class that stores family info:

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  // class fields

  @HiveField(1)
  String itemName;
  @HiveField(2)
  int quantity;
  @HiveField(3)
  double price;
  @HiveField(4)
  String description;
  @HiveField(5)
  DateTime date;
  @HiveField(6)
  Payment payment;

// class constructor
  ExpenseModel({
    this.date,
    this.description,
    this.itemName,
    this.price,
    this.quantity,
    this.payment,
  });
}

// ENUM
@HiveType(typeId: 1)
enum Payment {
  @HiveField(0)
  Credit,
  @HiveField(1)
  Cash,
}
const paymentString = <Payment, String>{
  Payment.Cash: "Cash",
  Payment.Credit: "Credit",
};
