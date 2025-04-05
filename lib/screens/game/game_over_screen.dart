import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/screens/home_screen.dart';
import 'package:vibration/vibration.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find();
    final redTeamScore = gameController.redTeamScore.value;
    final blueTeamScore = gameController.blueTeamScore.value;
    final winningTeam = gameController.winningTeam;
    final isRedTeamWinner = winningTeam == gameController.redTeamName.value;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF47215C),
                  Color(0xFF73378D),
                  Color(0xFF462EA6),
                  Color(0xFF2F1C54),
                ],
                stops: [0.0, 0.33, 0.66, 1.0],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Red Team
                Expanded(
                  flex: 2,
                  child: FadeInRight(
                    from: 100,
                    duration: const Duration(milliseconds: 800),
                    child: _buildTeamSection(
                      gameController.redTeamName.value,
                      [Color(0xFFDA6264), Color(0xFFBF393C)],
                      isWinner: isRedTeamWinner,
                    ),
                  ),
                ),

                // Winner announcement section
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isRedTeamWinner
                            ? [Color(0xFFDA6264), Color(0xFFBF393C)]
                            : [Color(0xFF3498DB), Color(0xFF2980B9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Winner decoration
                        Positioned(
                          right: -50,
                          top: 30,
                          child: Opacity(
                            opacity: 0.1,
                            child: Transform.rotate(
                              angle: -0.35,
                              child: SvgPicture.asset(
                                'assets/images/trophy.svg',
                                width: MediaQuery.of(context).size.width * 0.6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Winner content - properly centered
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "And the winner is...",
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2,
                                          2), // slight offset for smooth depth
                                      blurRadius: 4.0, // smooth blur
                                      color: Colors.black
                                          .withOpacity(0.3), // soft dark shadow
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  winningTeam,
                                  style: GoogleFonts.doHyeon(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2,
                                            2), // slight offset for smooth depth
                                        blurRadius: 4.0, // smooth blur
                                        color: Colors.black.withOpacity(
                                            0.3), // soft dark shadow
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      redTeamScore.toString(),
                                      style: GoogleFonts.doHyeon(
                                        color: isRedTeamWinner
                                            ? Color(0xFFECC317)
                                            : Color(0xFFEC4C4F),
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2,
                                                2), // slight offset for smooth depth
                                            blurRadius: 4.0, // smooth blur
                                            color: Colors.black.withOpacity(
                                                0.3), // soft dark shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      " : ",
                                      style: GoogleFonts.doHyeon(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      blueTeamScore.toString(),
                                      style: GoogleFonts.doHyeon(
                                        // color: Colors.white,
                                        color: isRedTeamWinner
                                            ? Color(0xFF3498DB)
                                            : Color(0xFFECC317),
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2,
                                                2), // slight offset for smooth depth
                                            blurRadius: 4.0, // smooth blur
                                            color: Colors.black.withOpacity(
                                                0.3), // soft dark shadow
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Blue Team
                Expanded(
                  flex: 2,
                  child: FadeInLeft(
                    from: 100,
                    duration: const Duration(milliseconds: 800),
                    child: _buildTeamSection(
                      gameController.blueTeamName.value,
                      [Color(0xFF3498DB), Color(0xFF2980B9)],
                      isWinner: !isRedTeamWinner,
                    ),
                  ),
                ),

                // End Game Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      Vibration.vibrate(duration: 100);
                      // Reset game controller
                      gameController.resetGame();
                      // Navigate back to home
                      Get.off(() => HomeScreen());
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
                          "END GAME",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            color: isRedTeamWinner
                                ? Color(0xFFBF393C)
                                : Color(0xFF2980B9),
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
        ],
      ),
    );
  }

  Widget _buildTeamSection(String teamName, List<Color> gradientColors,
      {required bool isWinner}) {
    return Stack(
      children: [
        // Team content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Team icon with glass effect
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none, // Allow trophy to overflow
                children: [
                  // Team icon with glass effect - fixed circular shadow
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: SvgPicture.asset(
                        'assets/images/team.svg',
                        width: 70,
                        height: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Trophy for winning team - properly positioned
                  if (isWinner)
                    Positioned(
                        top: -45,
                        left: -65,
                        child: Lottie.asset("assets/lottie/winner.json",
                            width: 100)),

                  // Team name positioned at the bottom and centered relative to the icon
                  Positioned(
                    bottom: -20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        teamName,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
