import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class AboutDialogBox extends StatelessWidget {
  const AboutDialogBox({super.key});

  String getRandomQuote() {
    final List<String> quotes = [
      "\"Say my name - just not the Taboo one.\"",
      "\"Wands at the ready - this game is about to get magical.\"",
      "\"Words are all we have, except the ones you can't say.\"",
      "\"The best words are the ones that don't get you eliminated.\"",
      "\"It’s like charades had a messy breakup with vocabulary class.\"",
      "\"You had one job: say everything *except* the word. And you *still* said it.\"",
      "\"In this game, ‘banana’ could mean ‘airplane’. Welcome to chaos.\"",
      "\"Taboo: Where friendships go to be aggressively tested.\"",
      "\"Me: I’m great with words. Also me: *accidentally says the Taboo word in 3 seconds.*\"",
      "\"More panic, less clue. That’s the Taboo way.\"",
      "\"Giving clues in Taboo is 90% flailing and 10% betrayal.\"",
      "\"This is the most intense cardio I’ve done sitting down.\"",
      "\"I speak fluent nonsense, especially under pressure.\"",
      "\"If looks could kill, my team would've eliminated me three rounds ago.\"",
    ];

    return quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/lottie/dev.json", width: 200),
            Text(
              "Made with chaotic precision by",
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Mohit Khairnar",
              style: GoogleFonts.doHyeon(
                  color: const Color(0xFF73378D),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            ),
            const SizedBox(height: 20),
            Text(
              getRandomQuote(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color(0xFF452DA5),
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF47215E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "This game is open source!",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF47215E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Support the chaos. Please do smash that GitHub star.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Vibration.vibrate(duration: 50);
                const url = "https://github.com/mohitooo28/Taboo";
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF73378D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.star1, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Star on GitHub",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }
}
