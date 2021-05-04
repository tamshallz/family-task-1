import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Screens/HomePage.dart';
import 'Models/expense_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(PaymentAdapter());
  await Hive.openBox<ExpenseModel>('expenses');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task One',
      theme: ThemeData(
        textTheme: GoogleFonts.alefTextTheme(),
        primaryColor: Color(0xFF9D86DE),
      ),
      home: HomePage(title: 'Welcome!'),
    );
  }
}
