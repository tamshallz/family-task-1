import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

/// IN-APP IMPORT
import '../Models/expense_model.dart';
import '../boxes.dart';
import '../widget/expense_dialog.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({this.title});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<ExpenseModel> expensesBox;
  DateTime date;
  Payment payment;
  @override
  void dispose() {
    Hive.box('expenses').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC6B5ED),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Expense App',
          style: GoogleFonts.alef(
            fontSize: 30,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<ExpenseModel>>(
        valueListenable: Boxes.getExpenses().listenable(),
        builder: (context, box, _) {
          final expenses = box.values.toList().cast<ExpenseModel>();

          return buildContent(expenses, ValueKey(expenses));
        },
      ),

      /// * FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ExpenseDialog(
            onClickedDone: addExpense,
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<ExpenseModel> expenses, Key key) {
    //* For Calculating the total expenses
    final netExpense = expenses.fold(
        0,
        (previousValue, element) => element.itemName.isNotEmpty
            ? previousValue + element.price
            : previousValue - element.price);

    final newExpenseString = '${netExpense.toStringAsFixed(2)}';
    final color = netExpense > 0 ? Colors.purple : Colors.red;
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No expenses added yet!',
          style: GoogleFonts.alef(fontSize: 25),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Total Expenses Made So Far:',
                  style: GoogleFonts.alef(fontSize: 25, color: Colors.white70),
                ),
                Text(
                  '₦$newExpenseString',
                  style: GoogleFonts.roboto(
                      fontSize: 30, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                final expense = expenses[index];
                String payment = paymentString[expense.payment];

                return buildEachExpenseDetail(context, expense, key, payment);
              },
            ),
          ),
        ],
      );
    }
  }

  /// *
  Widget buildEachExpenseDetail(BuildContext context, ExpenseModel expenseModel,
      Key key, String payment) {
    // final color = transaction.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(expenseModel.date);
    final price = '₦' + expenseModel.price.toStringAsFixed(0);

    return Dismissible(
      key: key,
      background: redDismissibleContainer(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            deleteExpense(expenseModel);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${expenseModel.itemName} Deleted!'),
            ),
          );
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Delete Confirmation"),
              content: Text(
                "Are you sure you want to delete ${expenseModel.itemName} from your expenses list",
                style: GoogleFonts.alef(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: ListTile(
          dense: true,
          onTap: () {
            Color textColor = Colors.white;
            buildOnTapShowDetail(
              context,
              expenseModel,
              textColor,
              payment,
            );
          },
          leading: ClipOval(
            child: Container(
              color: Colors.purple,
              height: 50,
              width: 50,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              expenseModel?.itemName ?? "No name added",
              style: GoogleFonts.acme(
                fontSize: 25,
              ),
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                date,
                style: GoogleFonts.acme(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.grey.shade300,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ExpenseDialog(
                    expenseModel: expenseModel,
                    onClickedDone: (itemName, description, price, quantity,
                            date, payment) =>
                        editExpense(expenseModel, itemName, description, price,
                            quantity, date, payment),
                  ),
                ),
              ),
            ],
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 5, right: 10),
            child: Text(
              price,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9D86DE),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

//! Function to show detail of each Card
  Future buildOnTapShowDetail(BuildContext context, ExpenseModel expenseModel,
      Color textColor, String payment) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          color: Theme.of(context).primaryColor,
          height: MediaQuery.of(context).size.height / 2.3,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Text(expenseModel.itemName[0].toUpperCase(),
                      style: GoogleFonts.acme(fontSize: 30)),
                ),
                Text(
                  expenseModel.itemName,
                  style: GoogleFonts.acme(fontSize: 35, color: textColor),
                ),
                Text(
                  expenseModel.description,
                  style: GoogleFonts.acme(fontSize: 20, color: textColor),
                ),
                Text(
                  'Payment Mode: $payment',
                  style: GoogleFonts.acme(fontSize: 20, color: textColor),
                ),
                Text(
                  'Created On:    ${DateFormat.yMMMMEEEEd().format(expenseModel.date)}',
                  style: GoogleFonts.acme(fontSize: 15, color: textColor),
                ),
                Text(
                  'Quantity: ${expenseModel.quantity}',
                  style: GoogleFonts.acme(fontSize: 20, color: textColor),
                ),
                Text(
                  'Cost Price:  ₦${expenseModel.price}',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//! Function to ADD item to the Box
  Future addExpense(String itemName, String description, double price,
      int quantity, DateTime date, Payment payment) async {
    final expense = ExpenseModel()
      ..itemName = itemName
      ..description = description
      ..date = DateTime.now()
      ..price = price
      ..quantity = quantity
      ..payment = payment;

    final box = Boxes.getExpenses();
    box.add(expense);
  }

//! Function to Edit item in the Box
  void editExpense(
      ExpenseModel expenseModel,
      String itemName,
      String description,
      double price,
      int quantity,
      DateTime date,
      Payment payment) {
    expenseModel.itemName = itemName;
    expenseModel.description = description;
    expenseModel.price = price;
    expenseModel.quantity = quantity;
    expenseModel.date = date;
    expenseModel.payment = payment;

    expenseModel.save();
  }

//! Function to Delete from BOX
  void deleteExpense(ExpenseModel expenseModel) {
    expenseModel.delete();
  }

  //* CONTAINER WITH BACKGROUND COLOR FOR DISMISSING WIDGET FROM LISTVIEW
  Widget redDismissibleContainer() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 60.0),
        color: Colors.redAccent,
        child: Icon(Icons.delete, color: Colors.white, size: 50),
      );
}
