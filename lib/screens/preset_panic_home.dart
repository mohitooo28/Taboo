import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taboo/widgets/game_settings.dart';
import 'package:taboo/widgets/team_container.dart';

class PresetPanicHome extends StatefulWidget {
  const PresetPanicHome({super.key});

  @override
  State<PresetPanicHome> createState() => _PresetPanicHomeState();
}

class _PresetPanicHomeState extends State<PresetPanicHome> {
  // Team name variables
  String redTeamName = "Red Team";
  String blueTeamName = "Blue Team";

  // Game settings variables
  int playTime = 60; // in seconds
  int round = 2;
  int numberOfPasses = 3;

  // Editing state variables
  bool isEditingRedTeam = false;
  bool isEditingBlueTeam = false;

  // Text controllers for editing team names
  late TextEditingController redTeamController;
  late TextEditingController blueTeamController;

  // Focus nodes for text fields
  late FocusNode redTeamFocusNode;
  late FocusNode blueTeamFocusNode;

  @override
  void initState() {
    super.initState();
    redTeamController = TextEditingController(text: redTeamName);
    blueTeamController = TextEditingController(text: blueTeamName);
    redTeamFocusNode = FocusNode();
    blueTeamFocusNode = FocusNode();
  }

  @override
  void dispose() {
    redTeamController.dispose();
    blueTeamController.dispose();
    redTeamFocusNode.dispose();
    blueTeamFocusNode.dispose();
    super.dispose();
  }

  // Validate team name (min 3 chars, max 12 words)
  bool isValidTeamName(String name) {
    if (name.trim().length < 2) return false;
    List<String> words = name.trim().split(RegExp(r'\s+'));
    if (words.length > 12) return false;
    return true;
  }

  // Handle team name editing
  void toggleRedTeamEditing() {
    setState(() {
      if (isEditingRedTeam) {
        String newName = redTeamController.text;
        if (isValidTeamName(newName)) {
          redTeamName = newName;
        } else {
          redTeamController.text = redTeamName;
        }
        redTeamFocusNode.unfocus();
      } else {
        redTeamController.text = redTeamName;
        redTeamFocusNode.requestFocus();
      }
      isEditingRedTeam = !isEditingRedTeam;
      isEditingBlueTeam = false;
    });
  }

  void toggleBlueTeamEditing() {
    setState(() {
      if (isEditingBlueTeam) {
        String newName = blueTeamController.text;
        if (isValidTeamName(newName)) {
          blueTeamName = newName;
        } else {
          blueTeamController.text = blueTeamName;
        }
        blueTeamFocusNode.unfocus();
      } else {
        blueTeamController.text = blueTeamName;
        blueTeamFocusNode.requestFocus();
      }
      isEditingBlueTeam = !isEditingBlueTeam;
      isEditingRedTeam = false;
    });
  }

  // Format passes display
  String getPassesDisplay(int passes) {
    return passes == 9 ? "Unlimited" : passes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            child: Stack(
              children: [
                // Scrollable content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 100, // Space for the fixed button
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "PRE-SET PANIC",
                        style: GoogleFonts.doHyeon(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Team containers
                      TeamContainer(
                        isEditing: isEditingRedTeam,
                        teamName: redTeamName,
                        teamController: redTeamController,
                        teamFocusNode: redTeamFocusNode,
                        onEditPressed: toggleRedTeamEditing,
                        gradientColors: [Color(0xFFDA6264), Color(0xFFBF393C)],
                      ),

                      const SizedBox(height: 6),
                      const Text(
                        "vs",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TeamContainer(
                        isEditing: isEditingBlueTeam,
                        teamName: blueTeamName,
                        teamController: blueTeamController,
                        teamFocusNode: blueTeamFocusNode,
                        onEditPressed: toggleBlueTeamEditing,
                        gradientColors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                      ),

                      const SizedBox(height: 50),

                      // Game Settings Container
                      GameSettingsWidget(
                        playTime: playTime,
                        round: round,
                        numberOfPasses: numberOfPasses,
                        getPassesDisplay: getPassesDisplay,
                        onPlayTimeChanged: (value) {
                          setState(() {
                            playTime = value.round();
                          });
                        },
                        onRoundChanged: (value) {
                          setState(() {
                            round = value.round();
                          });
                        },
                        onPassesChanged: (value) {
                          setState(() {
                            numberOfPasses = value.round();
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Fixed Ready Button at bottom
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      FocusScope.of(context).unfocus();

                      print(
                          "---------------------------------------------------");
                      print("Red Team Name: $redTeamName");
                      print("Blue Team Name: $blueTeamName");
                      print("Play Time: $playTime");
                      print("Round: $round");
                      print("Passes: $numberOfPasses");
                      print(
                          "---------------------------------------------------");
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "READY",
                          style: GoogleFonts.doHyeon(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
