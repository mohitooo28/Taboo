import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/models/taboo_card.dart';
import 'package:taboo/services/custom_taboo_service.dart';

class TabooService {
  static List<TabooCard>? _defaultCards;
  static bool _hasLoggedAssetInfo = false;

  static void reset() {
    _defaultCards = null;
    _hasLoggedAssetInfo = false;
    debugPrint("TabooService reset - will reload default cards");
  }

  // Load default cards from JSON file
  static Future<void> loadDefaultCards() async {
    if (_defaultCards != null) {
      return;
    }

    // Log asset bundle info once to help debug
    if (!_hasLoggedAssetInfo) {
      _hasLoggedAssetInfo = true;
      DefaultAssetBundle.of(Get.context!)
          .loadString('AssetManifest.json')
          .then((manifestContent) {
        final Map<String, dynamic> manifest = json.decode(manifestContent);
        print('Asset manifest entries: ${manifest.length}');
        manifest.keys.forEach((String key) {
          if (key.contains('json') || key.contains('word')) {
            print('Found potential asset: $key');
          }
        });
      }).catchError((e) => print('Could not load asset manifest: $e'));
    }

    try {
      // Try loading with rootBundle first
      print('Attempting to load JSON using rootBundle...');
      final jsonString =
          await rootBundle.loadString('lib/data/default_words.json');
      print('JSON content length: ${jsonString.length}');
      print(
          'First 100 chars: ${jsonString.substring(0, min(100, jsonString.length))}');

      final List<dynamic> jsonList = json.decode(jsonString);
      _defaultCards = jsonList.map((json) => TabooCard.fromJson(json)).toList();
      print(
          'Successfully loaded ${_defaultCards!.length} cards from JSON using rootBundle');
    } catch (e) {
      print('Error loading from rootBundle: $e');

      // Try without the lib/ prefix
      try {
        print('Attempting to load JSON without lib/ prefix...');
        final jsonString =
            await rootBundle.loadString('data/default_words.json');
        final List<dynamic> jsonList = json.decode(jsonString);
        _defaultCards =
            jsonList.map((json) => TabooCard.fromJson(json)).toList();
        print(
            'Successfully loaded ${_defaultCards!.length} cards without lib/ prefix');
      } catch (e2) {
        print('Error loading without lib/ prefix: $e2');

        // Try using DefaultAssetBundle
        try {
          print('Attempting to load using DefaultAssetBundle...');
          final jsonString = await DefaultAssetBundle.of(Get.context!)
              .loadString('lib/data/default_words.json');
          final List<dynamic> jsonList = json.decode(jsonString);
          _defaultCards =
              jsonList.map((json) => TabooCard.fromJson(json)).toList();
          print(
              'Successfully loaded ${_defaultCards!.length} cards using DefaultAssetBundle');
        } catch (e3) {
          print('Error using DefaultAssetBundle: $e3');

          // Try reading directly from file system (works only in debug mode)
          try {
            final String path =
                'd:/Code/Flutter/taboo/lib/data/default_words.json';
            print('Attempting to read directly from file: $path');
            final File file = File(path);
            final String jsonString = await file.readAsString();
            final List<dynamic> jsonList = json.decode(jsonString);
            _defaultCards =
                jsonList.map((json) => TabooCard.fromJson(json)).toList();
            print(
                'Successfully loaded ${_defaultCards!.length} cards from file system');
          } catch (e4) {
            print('Error reading directly from file: $e4');

            // Fall back to hardcoded JSON
            print('Falling back to hardcoded JSON');
            const rawJson = '''
            [
              {
                "word": "Apple",
                "forbidden": ["Fruit", "Red", "Juice", "Tree", "Eatable"]
              },
              {
                "word": "Car",
                "forbidden": ["Drive", "Road", "Engine", "Vehicle", "Transport"]
              },
              {
                "word": "Pizza",
                "forbidden": ["Cheese", "Italian", "Round", "Slice", "Topping"]
              },
              {
                "word": "Basketball",
                "forbidden": ["Sport", "Ball", "Hoop", "Court", "Dribble"]
              },
              {
                "word": "Coffee",
                "forbidden": ["Drink", "Caffeine", "Cup", "Morning", "Beans"]
              },
              {
                "word": "Beach",
                "forbidden": ["Sand", "Ocean", "Sun", "Swim", "Vacation"]
              }
            ]
            ''';

            try {
              final List<dynamic> jsonList = json.decode(rawJson);
              _defaultCards =
                  jsonList.map((json) => TabooCard.fromJson(json)).toList();
              print(
                  'Using hardcoded JSON as fallback - loaded ${_defaultCards!.length} cards');
            } catch (e5) {
              print('Error with hardcoded JSON: $e5');

              // Last resort - fully manual cards
              _defaultCards = [
                TabooCard(
                  word: "Oops!",
                  forbiddenWords: [
                    "Something",
                    "Went",
                    "Wrong",
                    "Error",
                    "Unexpected"
                  ],
                ),
                TabooCard(
                  word: "Try Again",
                  forbiddenWords: [
                    "Retry",
                    "Report",
                    "Issue",
                    "Fix",
                    "Problem"
                  ],
                ),
              ];
              print(
                  'Using manual cards as last resort - loaded ${_defaultCards!.length} cards');
            }
          }
        }
      }
    }
  }

  static Future<TabooCard> getRandomCard(List<int> usedIndices) async {
    // Check if we should use custom data
    try {
      final GameController gameController = Get.find();
      if (gameController.useCustomData.value) {
        // Use custom taboo service
        return CustomTabooService.getRandomCard(usedIndices);
      }
    } catch (e) {
      print("GameController not found, falling back to default cards: $e");
    }

    // If we're not using custom data or if there was an error finding the controller,
    // use default cards
    if (_defaultCards == null || _defaultCards!.isEmpty) {
      await loadDefaultCards();
    }

    // Check if default cards are available
    if (_defaultCards == null || _defaultCards!.isEmpty) {
      throw Exception("No default cards available");
    }

    // Create a list of available indices (not yet used)
    List<int> availableIndices = [];
    for (int i = 0; i < _defaultCards!.length; i++) {
      if (!usedIndices.contains(i)) {
        availableIndices.add(i);
      }
    }

    // If all cards have been used, reset and use all again
    if (availableIndices.isEmpty) {
      availableIndices = List.generate(_defaultCards!.length, (index) => index);
    }

    // Pick a random index from available ones
    final random = Random();
    final randomIndex =
        availableIndices[random.nextInt(availableIndices.length)];

    // Add to used indices
    if (!usedIndices.contains(randomIndex)) {
      usedIndices.add(randomIndex);
    }

    return _defaultCards![randomIndex];
  }
}
