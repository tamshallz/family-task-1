import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemQuantityController = TextEditingController();

  // final itemDescriptionController = TextEditingController();
  // String itemName;
  DateTime date;

  // String description;
  // double price;
  // int quantity;
  Payment payment;

  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
    //

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () {
              // expenseItems.sort((a, b) => a.itemName.compareTo(b.itemName));

              // setState(() {
              //   expenseItems.forEach((expense) => print(expense.itemName));
              // });
            },
          )
        ],
      ),
      body: ValueListenableBuilder<Box<ExpenseModel>>(
        valueListenable: Boxes.getExpenses().listenable(),
        builder: (context, box, _) {
          //
          List<int> keys = box.keys.cast<int>().toList();
          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              //
              final int key = keys[index];

              final ExpenseModel currentExpense = box.get(key);
              String payment = paymentString[currentExpense.payment];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),

                        /// Todo: This was showing errors because the item name and description
                        /// where not saved in the box, consider checking for null values in
                        /// Text Widgets to avoid null errors
                        Text(currentExpense?.itemName ?? "No name"),

                        /// This shows an error too
                        SizedBox(height: 5),
                        Text(currentExpense.description.toString()),
                        SizedBox(height: 5),
                        // SizedBox(height: 5),
                        Text('${currentExpense.quantity}'),
                        Text("Price: ${currentExpense.price}"),
                        SizedBox(height: 5),
                        Text("Payment: $payment"),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FOR EDITING AN EXISTING ITEM
          FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {},
          ),

          // CREATING SPACE
          SizedBox(
            height: 20,
          ),

          // FOR ADDING NEW EXPENSE ON THE LIST
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
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
                              // _buildInputField('Item Name', 'value', 'itemName'),
                              // _buildInputField('Description', 'value', 'description'),

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
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     quantity = int.parse(value);
                                  //   });
                                  // },
                                ),
                              ),

                              TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(), labelText: 'Pick your date'),
                                readOnly: true,
                                controller: dateController,
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));
                                  dateController.text = date.toString().substring(0, 10);
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              //
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
              }),
        ],
      ),
    );
    //
  }

  ///Todo:This affects performance of the app, consider adding the fields directly
  Widget _buildInputField(String label, String value, String labelName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        // autofocus: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        onChanged: (value) {
          setState(() {
            labelName = value;
          });
        },
      ),
    );
  }

  //
  void onFormSubmit() {
    Box<ExpenseModel> expensesBox = Hive.box<ExpenseModel>(expensesBoxName);
    expensesBox.add(
      ExpenseModel(
          date: date,
          description: itemDescriptionController.text,
          payment: payment,
          price: double.parse(itemPriceController.text),
          itemName: itemNameController.text,
          quantity: int.parse(itemQuantityController.text)),
    );
    Navigator.of(context).pop();
    print(expensesBox);
  }
}
