import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/screens/game/game_over_screen.dart';
import 'package:taboo/screens/game/start_game_screen.dart';
import 'package:vibration/vibration.dart';

class RoundSummaryScreen extends StatelessWidget {
  const RoundSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find();
    final isRedTeam = gameController.isRedTeamTurn.value;
    final teamColor =
        isRedTeam ? const Color(0xFFDA6264) : const Color(0xFF3498DB);

    return Scaffold(
      body: Container(
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
              const SizedBox(height: 30),
              Text(
                "ROUND SUMMARY",
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
              const SizedBox(height: 5),

              Text(
                gameController.currentTeam.value,
                style: GoogleFonts.doHyeon(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),

              const SizedBox(height: 20),

              // Score display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Red team score
                    _buildTeamScore(
                      gameController.redTeamName.value,
                      gameController.redTeamScore.value,
                      const Color(0xFFDA6264),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "vs",
                        style: GoogleFonts.doHyeon(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Blue team score
                    _buildTeamScore(
                      gameController.blueTeamName.value,
                      gameController.blueTeamScore.value,
                      const Color(0xFF3498DB),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Round history
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(() {
                    if (gameController.roundHistory.isEmpty) {
                      return Center(
                        child: Text(
                          "No words played this round",
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: gameController.roundHistory.length,
                      itemBuilder: (context, index) {
                        final historyItem = gameController.roundHistory[index];
                        final word = historyItem['word'] as String;
                        final result = historyItem['result'] as String;

                        return _buildHistoryItem(word, result);
                      },
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // Continue button
// Ready button at bottom
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Vibration.vibrate(duration: 100);

                    // Switch teams
                    gameController.switchTeam();

                    // Check if game is over
                    if (gameController.isGameOver) {
                      Get.off(() => const GameOverScreen());
                    } else {
                      Get.off(() => const StartGameScreen());
                    }
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
                        "CONTINUE",
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
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamScore(String teamName, int score, Color color) {
    return Column(
      children: [
        Text(
          teamName,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            score.toString(),
            style: GoogleFonts.doHyeon(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String word, String result) {
    IconData icon;
    Color color;
    String resultText;

    switch (result) {
      case 'correct':
        icon = Icons.check_circle;
        color = Colors.green;
        resultText = "CORRECT";
        break;
      case 'taboo':
        icon = Icons.cancel;
        color = Colors.red;
        resultText = "TABOO";
        break;
      case 'pass':
        icon = Icons.skip_next;
        color = Colors.amber;
        resultText = "SKIPPED";
        break;
      default:
        icon = Icons.timer_off;
        color = Colors.grey;
        resultText = "TIME UP";
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Text(
            word,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              resultText,
              style: GoogleFonts.nunito(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
