import 'package:flutter/material.dart';

/// *
import '../Models/expense_model.dart';

class ExpenseDialog extends StatefulWidget {
  final ExpenseModel expenseModel;
  final Function(
    String itemName,
    String description,
    double price,
    int quantity,
    DateTime date,
    Payment payment,
  ) onClickedDone;

  const ExpenseDialog({
    this.expenseModel,
    @required this.onClickedDone,
  });

  @override
  _ExpenseDialogState createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemQuantityController = TextEditingController();
  DateTime date = DateTime.now();
  Payment payment;

  @override
  void initState() {
    super.initState();

    if (widget.expenseModel != null) {
      final expense = widget.expenseModel;

      itemNameController.text = expense.itemName;
      itemDescriptionController.text = expense.description;
      itemPriceController.text = expense.price.toString();
      itemQuantityController.text = expense.quantity.toString();
      date = expense.date;
      payment = expense.payment;
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    itemDescriptionController.dispose();
    itemPriceController.dispose();
    itemQuantityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxLines;
    final isEditing = widget.expenseModel != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(
                  itemNameController, 'Item Name', 'Enter Item Name', maxLines),
              SizedBox(height: 8),
              buildName(itemDescriptionController, 'Description',
                  'Enter Description', maxLines = 2),
              SizedBox(height: 8),
              buildQuantity(),
              SizedBox(height: 8),
              buildPrice(),
              SizedBox(height: 8),
              buildDropDown()
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName(TextEditingController controller, String hintText,
          String title, int maxLines) =>
      TextFormField(
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: (name) => name != null && name.isEmpty ? title : null,
      );

  Widget buildPrice() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Price',
        ),
        keyboardType: TextInputType.number,
        validator: (price) => price != null && double.tryParse(price) == null
            ? 'Enter a valid number'
            : null,
        controller: itemPriceController,
      );

  Widget buildQuantity() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Quantity',
        ),
        keyboardType: TextInputType.number,
        validator: (quantity) =>
            quantity != null && int.tryParse(quantity) == null
                ? 'Enter a valid number'
                : null,
        controller: itemQuantityController,
      );

  // THE DROPDOWN SECTION
  Widget buildDropDown() => Container(
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
            onChanged: (paymentValue) {
              setState(() {
                payment = paymentValue;
              });
            },
          ),
        ),
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {@required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          // final name = nameController.text;
          // final amount = double.tryParse(amountController.text) ?? 0;

          final itemName = itemNameController.text;
          final description = itemDescriptionController.text;
          final price = double.tryParse(itemPriceController.text) ?? 0;
          final quantity = int.tryParse(itemQuantityController.text) ?? 0;

          widget.onClickedDone(
              itemName, description, price, quantity, date, payment);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
