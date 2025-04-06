import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taboo/widgets/compact_game_settings.dart';
import 'package:taboo/widgets/team_container.dart';
import 'package:vibration/vibration.dart';

class CustomCrazeHome extends StatefulWidget {
  const CustomCrazeHome({super.key});

  @override
  State<CustomCrazeHome> createState() => _CustomCrazeHomeState();
}

class _CustomCrazeHomeState extends State<CustomCrazeHome> {
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

  final TextEditingController customDataController = TextEditingController();
  String? customDataErrorText;

  // Function to validate JSON
  void validateCustomJson() {
    final value = customDataController.text;
    setState(() {
      if (value.isEmpty) {
        customDataErrorText = "Input cannot be empty";
        return;
      }

      try {
        json.decode(value);
        customDataErrorText = null;
        print("JSON validation passed: $value");
      } catch (e) {
        customDataErrorText = "Invalid JSON format";
      }
    });
  }

  // Function for clipboard paste
  Future<void> pasteFromClipboard() async {
    final ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        customDataController.text = clipboardData.text!;
      });
    }
  }

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
    customDataController.dispose();
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
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 100, 
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "CUSTOM CRAZE",
                        style: GoogleFonts.doHyeon(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),

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

                      const SizedBox(height: 40),

                      // Game Settings Container
                      CompactGameSettings(
                        playTime: playTime,
                        rounds: round,
                        passes: numberOfPasses,
                        onEditPressed: () {},
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D1A4A),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CUSTOM DATA",
                                style: GoogleFonts.doHyeon(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "How to create & enter custom data",
                                style: GoogleFonts.nunito(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4B4093),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: customDataController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      maxLines: null,
                                      expands: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                12, 12, 40, 12),
                                        border: InputBorder.none,
                                        hintText: 'Enter JSON data here',
                                        hintStyle: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: customDataController.text.isEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.paste,
                                                color: Colors.white70),
                                            onPressed: pasteFromClipboard,
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.clear,
                                                color: Colors.white70),
                                            onPressed: () {
                                              setState(() {
                                                customDataController.clear();
                                                customDataErrorText = null;
                                              });
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              if (customDataErrorText != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 2),
                                  child: Text(
                                    customDataErrorText!,
                                    style: GoogleFonts.nunito(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () {
                      Vibration.vibrate(duration: 100);
                      FocusScope.of(context).unfocus();

                      validateCustomJson();
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
