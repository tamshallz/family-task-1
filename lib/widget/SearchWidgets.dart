import 'package:family_task/Models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../boxes.dart';

class ExpensesSearch extends SearchDelegate<ExpenseModel> {
  final List<ExpenseModel> searchExpenses;

  ExpenseModel selectedItem;

  ExpensesSearch(this.searchExpenses);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showSuggestions(context);
            }
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () => close(context, null));
  }

  Widget buildResults(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0XFFC6B5ED),
            Color(0xFF9D86DE),
          ],
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(selectedItem.itemName,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            CircleAvatar(radius: 100, backgroundColor: Colors.grey[300]),
            Text(selectedItem.description, style: TextStyle(fontSize: 18)),
            Text('₦${selectedItem.price}',
                style: GoogleFonts.roboto(
                    fontSize: 40, fontWeight: FontWeight.bold)),
            Text(DateFormat.yMMMd().format(selectedItem.date),
                style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }

  Widget buildSuggestions(BuildContext context) {
    return ValueListenableBuilder<Box<ExpenseModel>>(
        valueListenable: Boxes.getExpenses().listenable(),
        builder: (context, box, _) {
          final expenses = box.values.toList().cast<ExpenseModel>();

          if (expenses.isEmpty) {
            return Center(child: Text('No Suggestions Available'));
          }
          final suggestion = expenses.where((element) =>
              element.itemName.toLowerCase().contains(query.toLowerCase()));

          return ListView(
              children: suggestion
                  .map<ListTile>((e) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                      ),
                      title: RichText(
                        text: TextSpan(
                            text: e.itemName.substring(0, query.length),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: e.itemName.substring(query.length),
                                  style: TextStyle(color: Colors.grey))
                            ]),
                      ),
                      subtitle: Text(DateFormat.yMMMd().format(e.date)),
                      onTap: () {
                        selectedItem = e;
                        showResults(context);
                      }))
                  .toList());
        });
  }
}
