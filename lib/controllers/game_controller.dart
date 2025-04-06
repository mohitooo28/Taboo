import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  // Game settings
  final redTeamName = "Red Team".obs;
  final blueTeamName = "Blue Team".obs;
  final playTime = 60.obs; // in seconds
  final rounds = 2.obs;
  final numberOfPasses = 3.obs;

  // Game state
  final currentTeam = "".obs;
  final displayRound = 1.obs;
  final redTeamScore = 0.obs;
  final blueTeamScore = 0.obs;
  final isRedTeamTurn = true.obs;
  final remainingPasses = 3.obs;

  // Track rounds and turns
  final redPlayedInRound =
      <int>[].obs; // Tracks which rounds Red team has played
  final bluePlayedInRound =
      <int>[].obs; // Tracks which rounds Blue team has played

  // Card history tracking
  final gameHistory = <Map<String, dynamic>>[].obs;
  final roundHistory = <Map<String, dynamic>>[].obs;

  // Game cards
  final usedCardIndices = <int>[].obs;

  void initializeGame(
      String red, String blue, int time, int roundCount, int passes) {
    // Set game settings
    redTeamName.value = red;
    blueTeamName.value = blue;
    playTime.value = time;
    rounds.value = roundCount;
    numberOfPasses.value = passes;
    remainingPasses.value = passes;

    // Reset tracking
    redPlayedInRound.clear();
    bluePlayedInRound.clear();

    // Randomly determine starting team
    if (Random().nextBool()) {
      currentTeam.value = redTeamName.value;
      isRedTeamTurn.value = true;
    } else {
      currentTeam.value = blueTeamName.value;
      isRedTeamTurn.value = false;
    }

    // Reset game state
    displayRound.value = 1;
    redTeamScore.value = 0;
    blueTeamScore.value = 0;

    gameHistory.clear();
    roundHistory.clear();
    usedCardIndices.clear();
  }

  void switchTeam() {
    // Add round history to game history before clearing
    if (roundHistory.isNotEmpty) {
      gameHistory.addAll(roundHistory);
      roundHistory.clear();
    }

    // Record which round this team played
    if (isRedTeamTurn.value) {
      // Red team just played - record it
      if (!redPlayedInRound.contains(displayRound.value)) {
        redPlayedInRound.add(displayRound.value);
      }

      // Switch to Blue team
      currentTeam.value = blueTeamName.value;
      isRedTeamTurn.value = false;
    } else {
      // Blue team just played - record it
      if (!bluePlayedInRound.contains(displayRound.value)) {
        bluePlayedInRound.add(displayRound.value);
      }

      // Switch to Red team
      currentTeam.value = redTeamName.value;
      isRedTeamTurn.value = true;
    }

    // Check if both teams have played in this round
    if (redPlayedInRound.contains(displayRound.value) &&
        bluePlayedInRound.contains(displayRound.value)) {
      // Both teams have played this round, move to next round
      if (displayRound.value < rounds.value) {
        displayRound.value++;
      }
    }

    // Reset passes for the new team
    remainingPasses.value = numberOfPasses.value;
  }

  void scoreWord(String word, String result) {
    // Add to round history
    roundHistory.add({
      'word': word,
      'result': result,
      'team': currentTeam.value,
      'round': displayRound.value,
    });

    // Update score
    if (result == 'correct') {
      if (isRedTeamTurn.value) {
        redTeamScore.value++;
      } else {
        blueTeamScore.value++;
      }
    } else if (result == 'taboo') {
      // Taboo reduces score - allow negative scores
      if (isRedTeamTurn.value) {
        redTeamScore.value--;
      } else {
        blueTeamScore.value--;
      }
    } else if (result == 'pass') {
      // Only decrement passes if not unlimited
      if (numberOfPasses.value != 9 && remainingPasses.value > 0) {
        remainingPasses.value--;
      }
    }
  }

  bool get isGameOver {
    // Game is over when both teams have played in the final round
    return redPlayedInRound.contains(rounds.value) &&
        bluePlayedInRound.contains(rounds.value);
  }

  bool get canPass => numberOfPasses.value == 9 || remainingPasses.value > 0;

  String get winningTeam {
    if (redTeamScore.value > blueTeamScore.value) {
      return redTeamName.value;
    } else if (blueTeamScore.value > redTeamScore.value) {
      return blueTeamName.value;
    } else {
      return "It's a tie!";
    }
  }

  Color get currentTeamColor {
    return isRedTeamTurn.value
        ? const Color(0xFFDA6264)
        : const Color(0xFF3498DB);
  }

  void resetGame() {
    // Clear all game state
    gameHistory.clear();
    roundHistory.clear();
    usedCardIndices.clear();
    displayRound.value = 1;
    redTeamScore.value = 0;
    blueTeamScore.value = 0;
    redPlayedInRound.clear();
    bluePlayedInRound.clear();
  }
}
