import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class InDevelopment extends StatelessWidget {
  const InDevelopment({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF47215E),
              Color(0xFF73378D),
              Color(0xFF452DA5),
              Color(0xFF311D58),
            ],
            stops: [0.0, 0.33, 0.66, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 70),
          child: Column(children: [
            Lottie.asset("assets/lottie/progress.json"),
            Center(
              child: Text(
                "This Mode is Currently Under Development",
                style: GoogleFonts.doHyeon(
                  color: Colors.white,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
