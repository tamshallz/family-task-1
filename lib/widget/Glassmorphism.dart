import 'dart:ui';

import 'package:flutter/material.dart';

glassmorphism(BuildContext context, Widget child, double height) => Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 24,
            spreadRadius: 16,
            color: Colors.black.withOpacity(0.2))
      ]),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
              height: height,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      width: 1.5, color: Colors.white.withOpacity(0.2))),
              child: child),
        ),
      ),
    );
