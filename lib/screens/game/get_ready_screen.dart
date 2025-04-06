import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/screens/game/start_game_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibration/vibration.dart';

class GetReadyScreen extends StatefulWidget {
  const GetReadyScreen({super.key});

  @override
  State<GetReadyScreen> createState() => _GetReadyScreenState();
}

class _GetReadyScreenState extends State<GetReadyScreen>
    with SingleTickerProviderStateMixin {
  final GameController gameController = Get.find();
  int countdown = 3;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for the countdown
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
          _animationController.reset();
          _animationController.forward();
          Vibration.vibrate(duration: 50);
        } else {
          _timer.cancel();
          // Navigate to the next screen
          Vibration.vibrate(duration: 100);
          Get.off(() => const StartGameScreen());
        }
      });
    });

    // Start the animation for the initial countdown
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTeamSection(bool isRed, String teamName) {
    final isThisTeamTurn = isRed
        ? gameController.isRedTeamTurn.value
        : !gameController.isRedTeamTurn.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Conditionally show "GUESSING TEAM" only above the active team
        if (isThisTeamTurn)
          Column(
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/vectors/megaphone.svg',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "GUESSING TEAM",
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),

        // Team name above SVG

        // Team SVG
        SvgPicture.asset(
          'assets/vectors/team.svg',
          width: 110,
          height: 110,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        const SizedBox(height: 5),

        Text(
          teamName,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Red Team (Top Half)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDA6264), Color(0xFFBF393C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FadeInRight(
                from: 100, 
                duration: const Duration(milliseconds: 800),
                child: Obx(() => _buildTeamSection(true, "Red Team")),
              ),
            ),
          ),

          // Blue Team (Bottom Half)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ), 
              child: FadeInLeft(
                from: 100, // Start from further left (outside the screen)
                duration: const Duration(milliseconds: 800),
                child: Obx(() => _buildTeamSection(false, "Blue Team")),
              ),
            ),
          ),

          Center(
            child: Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // Center countdown
          Center(
            child: ZoomIn(
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      countdown.toString(),
                      style: GoogleFonts.doHyeon(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
