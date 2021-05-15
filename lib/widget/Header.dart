import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//! HEADER
buildHeader(String header, String subheader) {
  return RichText(
    text: TextSpan(children: [
      TextSpan(
        text: header,
        style: TextStyle(
            fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      TextSpan(
        text: subheader,
        style: GoogleFonts.josefinSlab(fontSize: 20, color: Colors.white60),
      )
    ]),
  );
}
