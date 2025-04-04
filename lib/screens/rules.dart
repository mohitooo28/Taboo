import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:taboo/screens/home_screen.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF47215E), // Top Left
              Color(0xFF73378D), // Top Right
              Color(0xFF452DA5), // Bottom Left
              Color(0xFF311D58), // Bottom Right
            ],
            stops: [
              0.0,
              0.33,
              0.66,
              1.0
            ], // Adjusting stops for smooth blending
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Text(
                'Taboo Rules',
                style: GoogleFonts.doHyeon(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.3,
                  fontSize: 36,
                ),
              ),
            ),
            SizedBox(height: 25),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_rules.length, (index) {
                    return FadeInDown(
                      duration: Duration(milliseconds: 500 + (index * 200)),
                      child: _buildRule(_rules[index]),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Get.off(HomeScreen(), transition: Transition.upToDown);
              },
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Center(
                    child: Text(
                      "Go to Home",
                      style: GoogleFonts.nunito(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Widget _buildRule(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Iconsax.tick_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> _rules = [
  "Each team takes turns to play.",
  "One player gives clues to teammates without using taboo words.",
  "If a taboo word is used, the opposing team buzzes and you lose a point.",
  "Guess as many words as possible within the time limit.",
  "Each correct guess earns a point.",
  "Skipping words may have a penalty, based on game rules.",
  "The team with the most points at the end wins!",
];
