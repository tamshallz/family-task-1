import 'dart:ui';


import 'package:family_task/Utils/Pallete.dart';
import 'package:family_task/widget/backgroundImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//! IN-APP import
import '../widget/Glassmorphism.dart';
import '../widget/Button.dart';
import '../widget/Textfield.dart';
import '../widget/Header.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage('Images/Background/dan.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: glassmorphism(
                context,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          buildHeader('Welcome!\n',
                              'Track your daily expenses and income'),
                          SizedBox(height: 40),
                          buildTextField(
                            hintText: 'Email',
                            icon: FontAwesomeIcons.envelope,
                            textInputType: TextInputType.emailAddress,
                          ),
                          buildTextField(
                            hintText: 'Password',
                            icon: FontAwesomeIcons.lock,
                            textInputAction: TextInputAction.done,
                          ),

                          // ! Forgotten Password Section
                          InkWell(
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, 'ForgottenPassword'),
                              child: Text(
                                'Forgotten Password?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18),
                              ),
                            ),
                          ),

                          // *
                          buildButton(context, 'Sign In', () {}),
                        ],
                      ),
                      //* Creating Account
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, 'CreateAccount'),
                        child: Container(
                          child: Text(
                            'Create New Account',
                            style: kBodyText.copyWith(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1, color: kWhite),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MediaQuery.of(context).size.height * 0.65),
          ),
        ),
      ],
    );
  }
}
