import 'package:flutter/material.dart';

//!
import '../Utils/Pallete.dart';

//! BUTTON
buildButton(BuildContext context, String buttonText, Function onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: TextButton(
          onPressed: onTap,
          child: Text(buttonText,
              style: kBodyText.copyWith(
                  color: kWhite, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
  );
}
