import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';

import '../Models/expense_model.dart';
import '../boxes.dart';

const String expensesBoxName = 'expenses';

class Home extends StatefulWidget {
  Home({Key key, this.title});

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<ExpenseModel> expensesBox;
  DateTime date;
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemQuantityController = TextEditingController();
  final dateController = TextEditingController();

  Payment payment;

  @override
  void dispose() {
    Hive.box('expenseModels').close();

    /// Todo: Always consider disposing off controllers to avoid memory leaks
    itemNameController.dispose();
    itemDescriptionController.dispose();
    itemPriceController.dispose();
    itemQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC6B5ED),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.pacifico(
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => buildShowDialog(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<ExpenseModel>>(
                valueListenable: Boxes.getExpenses().listenable(),
                builder: (context, box, _) {
                  //
                  List keys = box.keys.cast<int>().toList();
                  return ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      //
                      final int key = keys[index];

                      final ExpenseModel currentExpense = box.get(key);
                      String payment = paymentString[currentExpense.payment];

                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                        ),
                        onDismissed: (direction) {
                          box.deleteAt(index);
                        },
                        key: ValueKey(keys),
                        child: InkWell(
                          onTap: () => buildShowDialogMenu(
                            context,
                            currentExpense,
                            index,
                            payment,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  /* 
                                  Todo: This was showing errors because the item name and description
                                  where not saved in the box, consider checking for null values in
                                  Text Widgets to avoid null errors 
                                  */
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentExpense?.itemName ??
                                            "No name added",
                                        style: GoogleFonts.acme(
                                          fontSize: 25,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₦${currentExpense.price}',
                                            style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentExpense.date.toString(),
                                        style: GoogleFonts.acme(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {
                                          onUpdateDialog(
                                            context,
                                            index,
                                            currentExpense,
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    //
  }

  Future buildShowDialogMenu(BuildContext context, ExpenseModel currentExpense,
      int index, String payment) {
    Color textColor = Colors.white;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
            padding: EdgeInsets.all(10),
            height: 300,
            color: Color(0xFF9D86DE),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(currentExpense.itemName[0].toUpperCase(),
                        style: GoogleFonts.acme(fontSize: 30)),
                  ),
                  Text(
                    currentExpense.itemName,
                    style: GoogleFonts.acme(fontSize: 35, color: textColor),
                  ),
                  Text(
                    currentExpense.description,
                    style: GoogleFonts.acme(fontSize: 20, color: textColor),
                  ),
                  Text(
                    'Payment Mode: $payment',
                    style: GoogleFonts.acme(fontSize: 20, color: textColor),
                  ),
                  Text(
                    'Created On: ${currentExpense.date.toString()}',
                    style: GoogleFonts.acme(fontSize: 15, color: textColor),
                  ),
                  Text(
                    'Quantity: ${currentExpense.quantity}',
                    style: GoogleFonts.acme(fontSize: 20, color: textColor),
                  ),
                  Text(
                    'Cost Price:  ₦${currentExpense.price}',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: textColor),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        context: (context),
        builder: (_) {
          return Dialog(
              child: Container(
            padding: const EdgeInsets.all(10),
            // height: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'New Item',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: itemNameController,
                      decoration: InputDecoration(
                        labelText: "Item Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: itemDescriptionController,
                      decoration: InputDecoration(
                        labelText: "Item Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  // PRICE INPUT
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: itemPriceController,
                          keyboardType: TextInputType.number,
                          // autofocus: true,
                          // initialValue: "",
                          decoration: InputDecoration(
                              border: InputBorder.none, labelText: 'Price'),
                          // onChanged: (value) {
                          //   setState(() {
                          //     price = double.parse(value);
                          //   });
                          // },
                        ),
                      ),
                    ),
                  ),

                  // QUANTITY INPUT
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      controller: itemQuantityController,
                      keyboardType: TextInputType.number,
                      // autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Quantity'),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  // THE dropdown section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Payment>(
                        items: paymentString.keys.map((Payment value) {
                          return DropdownMenuItem<Payment>(
                            value: value,
                            child: Text(paymentString[value]),
                          );
                        }).toList(),
                        value: payment,
                        hint: Text('Payment'),
                        onChanged: (value) {
                          setState(() {
                            payment = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // INPUT BUTTON
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9D86DE),
                      ),
                      onPressed: onFormSubmit,
                      child: Center(
                        child: Text('Add'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }

  //* EDITING
  Future onUpdateDialog(
      BuildContext context, int index, ExpenseModel currentExpense) {
    return showDialog(
        context: (context),
        builder: (_) {
          return Dialog(
              child: Container(
            padding: const EdgeInsets.all(10),
            // height: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'New Item',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: itemNameController,
                      decoration: InputDecoration(
                        labelText: "Item Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: itemDescriptionController,
                      decoration: InputDecoration(
                        labelText: "Item Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  // PRICE INPUT
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: itemPriceController,
                          keyboardType: TextInputType.number,
                          // autofocus: true,
                          // initialValue: "",
                          decoration: InputDecoration(
                              border: InputBorder.none, labelText: 'Price'),
                          // onChanged: (value) {
                          //   setState(() {
                          //     price = double.parse(value);
                          //   });
                          // },
                        ),
                      ),
                    ),
                  ),

                  // QUANTITY INPUT
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TextField(
                      controller: itemQuantityController,
                      keyboardType: TextInputType.number,
                      // autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Quantity'),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  // THE dropdown section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Payment>(
                        items: paymentString.keys.map((Payment value) {
                          return DropdownMenuItem<Payment>(
                            value: value,
                            child: Text(paymentString[value]),
                          );
                        }).toList(),
                        value: payment,
                        hint: Text('Payment'),
                        onChanged: (value) {
                          setState(() {
                            payment = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // INPUT BUTTON
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9D86DE),
                      ),
                      onPressed: () {
                        onUpdate(index);
                      },
                      child: Center(
                        child: Text('Save'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }

  /// * This affects performance of the app, consider adding the fields directly

  void onFormSubmit() {
    Box<ExpenseModel> expensesBox = Hive.box<ExpenseModel>(expensesBoxName);

    expensesBox.add(
      ExpenseModel(
        date: DateTime.now(),
        description: itemDescriptionController.text,
        payment: payment,
        price: double.parse(itemPriceController.text),
        itemName: itemNameController.text,
        quantity: int.parse(
          itemQuantityController.text,
        ),
      ),
    );
    Navigator.of(context).pop();
    clearTextField();
  }

  //* Updating my expense
  void onUpdate(int index) {
    Box<ExpenseModel> expensesBox = Hive.box<ExpenseModel>(expensesBoxName);

    expensesBox.putAt(
      index,
      ExpenseModel(
        date: DateTime.now(),
        description: itemDescriptionController.text,
        payment: payment,
        price: double.parse(itemPriceController.text),
        itemName: itemNameController.text,
        quantity: int.parse(
          itemQuantityController.text,
        ),
      ),
    );
    Navigator.of(context).pop();
    clearTextField();
  }

  // * Clearing the TextField
  void clearTextField() {
    itemNameController.clear();
    itemDescriptionController.clear();
    itemPriceController.clear();
    itemQuantityController.clear();
  }

  Future dismissDialog(
      ExpenseModel currentExpense, Box<ExpenseModel> box, int index) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        content: Text(
          "Do you want to delete ${currentExpense.itemName}?",
        ),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () async {
              await box.deleteAt(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  buildSwipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        child: Center(
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 30,
          ),
        ),
      );

  // void dismissExpenseCard() {
  //   setState(() async {
  //     await box.deleteAt(index);
  //         Navigator.of(context).pop();
  //   });
  // }
}
