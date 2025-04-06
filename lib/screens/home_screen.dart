import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:taboo/screens/custom_craze_home.dart';
import 'package:taboo/screens/preset_panic_home.dart';
import 'package:taboo/screens/rules.dart';
import 'package:taboo/widgets/game_type_cards.dart';
import 'package:taboo/widgets/rules_card.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Vibration.vibrate(duration: 50);
                    _controller.forward(from: 0);
                  },
                  child: BounceIn(
                    manualTrigger: true,
                    controller: (controller) => _controller = controller,
                    duration: Duration(milliseconds: 1000),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shadow layer for the SVG
                        Transform.translate(
                          offset: Offset(4, 5),
                          child: SvgPicture.asset(
                            "assets/vectors/title.svg",
                            width: 300,
                            color: Colors.black
                                .withOpacity(0.2), // Shadow color with opacity
                          ),
                        ),
                        // Original SVG on top
                        SvgPicture.asset(
                          "assets/vectors/title.svg",
                          width: 300,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    GameTypeCard(
                      title: "PRE-SET\nPANIC",
                      assetName: 'assets/vectors/puzzle.svg',
                      subtitle: "Classic words, no hassle just pure fun!",
                      animateFromLeft: true,
                      destination: PresetPanicHome(),
                    ),
                    SizedBox(width: 16), // Space between containers
                    GameTypeCard(
                      title: "CUSTOM\nCRAZE",
                      assetName: 'assets/vectors/fire.svg',
                      subtitle: "Your words, your rules :D",
                      animateFromLeft: false,
                      destination: CustomCrazeHome(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                  onTap: () {
                    Vibration.vibrate(duration: 100);
                    Get.to(RulesPage(), transition: Transition.downToUp);
                  },
                  child: RulesCard()),
              const Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 5, 16, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "The Chaos\nAwaits",
                      style: GoogleFonts.doHyeon(
                        color: Colors.white.withOpacity(0.2),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.3,
                        fontSize: 45,
                      ),
                    ),
                    Spacer(),
                    SvgPicture.asset(
                      "assets/vectors/about.svg",
                      width: 35,
                      height: 35,
                      color: Colors.white.withOpacity(0.1),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
