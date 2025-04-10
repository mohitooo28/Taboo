import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:taboo/models/taboo_card.dart';

class CustomTabooService {
  static List<TabooCard> _customCards = [];

  // Initialize with the custom JSON data
  static void initializeCustomCards(String jsonData) {
    try {
      final List<dynamic> decodedData = json.decode(jsonData);
      _customCards =
          decodedData.map((item) => TabooCard.fromJson(item)).toList();
      debugPrint('Successfully loaded ${_customCards.length} custom cards');
    } catch (e) {
      debugPrint("Error initializing custom cards: $e");
      _customCards = [];
      throw Exception("Failed to initialize custom cards: $e");
    }
  }

  // Get a random card from the custom set
  static Future<TabooCard> getRandomCard(List<int> usedIndices) async {
    if (_customCards.isEmpty) {
      throw Exception(
          "No custom cards available. Did you forget to initialize?");
    }

    // Create a list of available indices (not yet used)
    List<int> availableIndices = [];
    for (int i = 0; i < _customCards.length; i++) {
      if (!usedIndices.contains(i)) {
        availableIndices.add(i);
      }
    }

    // If all cards have been used, reset and use all again
    if (availableIndices.isEmpty) {
      availableIndices = List.generate(_customCards.length, (index) => index);
      debugPrint("All custom cards have been used - resetting available cards");
    }

    // Pick a random index from available ones
    final randomIndex =
        availableIndices[Random().nextInt(availableIndices.length)];

    // Add to used indices
    if (!usedIndices.contains(randomIndex)) {
      usedIndices.add(randomIndex);
    }

    debugPrint(
        "Selected custom card index: $randomIndex (${_customCards[randomIndex].word})");
    return _customCards[randomIndex];
  }

  // Check if custom cards are available
  static bool get hasCustomCards => _customCards.isNotEmpty;

  // Get the total number of custom cards
  static int get customCardCount => _customCards.length;

  // Clear custom cards
  static void clearCustomCards() {
    _customCards = [];
    debugPrint("Custom cards cleared");
  }
}
