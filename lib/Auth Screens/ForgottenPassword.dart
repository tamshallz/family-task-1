import 'package:family_task/Utils/Pallete.dart';
import 'package:family_task/widget/Button.dart';
import 'package:family_task/widget/Glassmorphism.dart';
import 'package:family_task/widget/Textfield.dart';
import 'package:family_task/widget/backgroundImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//!

class ForgottenPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage('Images/Background/jak.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: glassmorphism(
                context,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                            fontSize: 30,
                            color: kWhite,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Enter your email, we will send instruction to reset your password',
                        style: TextStyle(fontSize: 16, color: kWhite),
                      ),
                      buildTextField(
                          hintText: 'Email', icon: FontAwesomeIcons.envelope),
                      buildButton(context, 'Send', () {})
                    ],
                  ),
                ),
                MediaQuery.of(context).size.height * 0.4),
          ),
        ),
      ],
    );
  }
}
