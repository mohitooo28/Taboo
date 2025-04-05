import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/screens/game/gameplay_screen.dart';
import 'package:vibration/vibration.dart';

class StartGameScreen extends StatelessWidget {
  const StartGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find();

    return Scaffold(
      body: Obx(() {
        // Determine team color based on current team
        final isRedTeam = gameController.isRedTeamTurn.value;
        final teamColor =
            isRedTeam ? const Color(0xFFBF393C) : const Color(0xFF3498DB);

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                teamColor.withOpacity(0.8),
                teamColor,
                teamColor.withOpacity(0.7),
                teamColor.withOpacity(0.9),
              ],
              stops: const [0.0, 0.33, 0.66, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text(
                  "ROUND ${gameController.displayRound.value}",
                  style: GoogleFonts.nunito(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  gameController.currentTeam.value.toUpperCase(),
                  style: GoogleFonts.doHyeon(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                const SizedBox(height: 10),
                Text(
                  "YOUR TURN",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                // Ready button at bottom
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      Vibration.vibrate(duration: 100);
                      // Navigate to gameplay screen
                      Get.off(() => const GameplayScreen());
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "READY",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: teamColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }
}
