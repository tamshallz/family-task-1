import 'package:hive/hive.dart';

part 'expense_model.g.dart';

/// Creating Class that stores family info:

@HiveType(typeId: 0)
class ExpenseModel {
  // class fields
  // @HiveField(0) String id;
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
    // this.id,
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
