import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/screens/game/get_ready_screen.dart';
import 'package:taboo/services/custom_taboo_service.dart';
import 'package:taboo/services/taboo_service.dart';
import 'package:taboo/widgets/compact_game_settings.dart';
import 'package:taboo/widgets/custom_instructions_dialog.dart';
import 'package:taboo/widgets/game_settings.dart';
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
  int rounds = 2;
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
        // First check if it's valid JSON
        final jsonData = json.decode(value);

        // Now validate the structure
        if (jsonData is! List) {
          customDataErrorText = "JSON must be an array of word objects";
          return;
        }

        if (jsonData.isEmpty) {
          customDataErrorText = "Word list cannot be empty";
          return;
        }

        // Check each word object
        for (int i = 0; i < jsonData.length; i++) {
          final wordObj = jsonData[i];

          // Check if it's a valid object
          if (wordObj is! Map<String, dynamic>) {
            customDataErrorText = "Item #${i + 1} is not a valid word object";
            return;
          }

          // Check if it has the required fields
          if (!wordObj.containsKey('word') ||
              wordObj['word'] is! String ||
              (wordObj['word'] as String).isEmpty) {
            customDataErrorText =
                "Item #${i + 1} is missing a valid 'word' field";
            return;
          }

          if (!wordObj.containsKey('forbidden') ||
              wordObj['forbidden'] is! List) {
            customDataErrorText = "Item #${i + 1} is missing 'forbidden' list";
            return;
          }

          // Check forbidden words
          final forbiddenWords = wordObj['forbidden'] as List;
          if (forbiddenWords.isEmpty) {
            customDataErrorText =
                "Item #${i + 1} must have at least one forbidden word";
            return;
          }

          for (int j = 0; j < forbiddenWords.length; j++) {
            if (forbiddenWords[j] is! String ||
                (forbiddenWords[j] as String).isEmpty) {
              customDataErrorText =
                  "Item #${i + 1} contains an invalid forbidden word";
              return;
            }
          }
        }

        // If we made it here, the JSON is valid
        customDataErrorText = null;
        print("JSON validation passed: ${jsonData.length} word objects found");

        // Optional: Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully loaded ${jsonData.length} custom words',
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 15),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        customDataErrorText =
            "Invalid JSON format: ${e.toString().split('\n')[0]}";
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

  void _showInstructionsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Instructions Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const CustomInstructionsDialog(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            child: child,
          ),
        );
      },
    );
  }

  // Format passes display
  String getPassesDisplay(int passes) {
    return passes == 9 ? "Unlimited" : passes.toString();
  }

  void _showGameSettingsDialog() {
    int tempPlayTime = playTime;
    int tempRounds = rounds;
    int tempPasses = numberOfPasses;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Curves.easeIn,
                ),
              ),
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: SingleChildScrollView(
                  child: GameSettingsWidget(
                    playTime: tempPlayTime,
                    round: tempRounds,
                    numberOfPasses: tempPasses,
                    getPassesDisplay: getPassesDisplay,
                    onPlayTimeChanged: (value) {
                      Vibration.vibrate(duration: 10);
                      setDialogState(() {
                        tempPlayTime = value.round();
                      });

                      setState(() {
                        playTime = value.round();
                      });
                    },
                    onRoundChanged: (value) {
                      Vibration.vibrate(duration: 10);
                      setDialogState(() {
                        tempRounds = value.round();
                      });

                      setState(() {
                        rounds = value.round();
                      });
                    },
                    onPassesChanged: (value) {
                      Vibration.vibrate(duration: 10);
                      setDialogState(() {
                        tempPasses = value.round();
                      });

                      setState(() {
                        numberOfPasses = value.round();
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
                        style: GoogleFonts.aclonica(
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
                              GestureDetector(
                                onTap: () {
                                  Vibration.vibrate(duration: 50);
                                  _showInstructionsDialog();
                                },
                                child: Text(
                                  "How to create & enter custom data",
                                  style: GoogleFonts.nunito(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 120,
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
                                            onPressed: () {
                                              Vibration.vibrate(duration: 20);
                                              pasteFromClipboard();
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(Icons.clear,
                                                color: Colors.white70),
                                            onPressed: () {
                                              setState(() {
                                                Vibration.vibrate(duration: 20);
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

                      // Compact Game Settings
                      CompactGameSettings(
                        playTime: playTime,
                        rounds: rounds,
                        passes: numberOfPasses,
                        onEditPressed: () {
                          Vibration.vibrate(duration: 20);
                          _showGameSettingsDialog();
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                // Update the READY button:

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(

                    onTap: () {
                      Vibration.vibrate(duration: 100);
                      FocusScope.of(context).unfocus();

                      validateCustomJson();
                      if (customDataErrorText == null &&
                          customDataController.text.isNotEmpty) {
                        try {
                          debugPrint(
                              "Custom Craze: Attempting to initialize custom taboo service...");

                          CustomTabooService.clearCustomCards();
                          TabooService.reset();

                          CustomTabooService.initializeCustomCards(
                              customDataController.text);

                          if (CustomTabooService.hasCustomCards) {
                            debugPrint(
                                "Custom Craze: Successfully initialized with ${CustomTabooService.customCardCount} cards");

                            final gameController = Get.put(GameController());
                            gameController.initializeGame(redTeamName,
                                blueTeamName, playTime, rounds, numberOfPasses);

                            gameController.setUseCustomData(true);

                            debugPrint(
                                "Custom Craze: Game controller initialized with useCustomData=true");
                                
                            Get.to(() => const GetReadyScreen());
                          } else {
                            debugPrint(
                                "Custom Craze: No custom cards loaded even though initialization didn't throw an error");
                            setState(() {
                              customDataErrorText =
                                  "Failed to load any valid cards from the data";
                            });
                          }
                        } catch (e) {
                          debugPrint(
                              "Custom Craze: Error in initialization: $e");
                          setState(() {
                            customDataErrorText =
                                "Error processing custom data: ${e.toString().split('\n')[0]}";
                          });
                        }
                      } else {
                        debugPrint(
                            "Custom Craze: Validation failed or empty data: $customDataErrorText");
                      }
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
                            offset: const Offset(0, 4),
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
