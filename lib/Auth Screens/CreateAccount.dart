import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

//!
import '../widget/Button.dart';
import '../widget/Glassmorphism.dart';
import '../widget/Textfield.dart';
import '../widget/backgroundImage.dart';

class CreateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        backgroundImage('Images/Background/vin.jpg'),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Create New Account',
              style: GoogleFonts.alef(fontSize: 30),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: glassmorphism(
                context,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      //* Profile Picture
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: size.width * 0.11,
                          backgroundColor: Colors.grey[400].withOpacity(0.2),
                          child: Icon(FontAwesomeIcons.user,
                              color: Colors.white38, size: 28),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 20),
                          buildTextField(
                              hintText: 'Full Name',
                              icon: FontAwesomeIcons.user),
                          buildTextField(
                              hintText: 'Email',
                              icon: FontAwesomeIcons.envelope,
                              textInputType: TextInputType.emailAddress),
                          buildTextField(
                              hintText: 'Password',
                              obscure: true,
                              icon: FontAwesomeIcons.lock),
                          buildTextField(
                              hintText: 'Confirm Password',
                              obscure: true,
                              icon: FontAwesomeIcons.lock,
                              textInputAction: TextInputAction.done),
                          // *
                          buildButton(context, 'Create Account', () {}),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account?  ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                TextSpan(
                                    text: 'Login',
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                size.height * 0.8),
          ),
        ),
      ],
    );
  }
}
