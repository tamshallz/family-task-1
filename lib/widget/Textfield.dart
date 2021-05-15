import 'package:flutter/material.dart';

//*
import '../Utils/Pallete.dart';

//! TEXTFIELD
buildTextField(
    {@required String hintText,
    @required IconData icon,
    bool obscure = false,
    TextInputType textInputType = TextInputType.name,
    TextInputAction textInputAction = TextInputAction.next}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Container(
      height: 55,
      decoration: BoxDecoration(
          color: Colors.grey[500].withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: TextField(
          textAlign: TextAlign.justify,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: Colors.grey, size: 23),
              hintText: hintText,
              hintStyle: kBodyText.copyWith(fontSize: 18)),
          keyboardType: textInputType,
          textInputAction: textInputAction,
        ),
      ),
    ),
  );
}
