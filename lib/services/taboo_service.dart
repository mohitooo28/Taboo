import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taboo/models/taboo_card.dart';

class TabooService {
  static List<TabooCard>? _cards;
  static bool _hasLoggedAssetInfo = false;

  // Load cards from JSON file
  static Future<List<TabooCard>> loadTabooCards() async {
    if (_cards != null) {
      return _cards!;
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
      _cards = jsonList.map((json) => TabooCard.fromJson(json)).toList();
      print(
          'Successfully loaded ${_cards!.length} cards from JSON using rootBundle');
      return _cards!;
    } catch (e) {
      print('Error loading from rootBundle: $e');

      // Try without the lib/ prefix
      try {
        print('Attempting to load JSON without lib/ prefix...');
        final jsonString =
            await rootBundle.loadString('data/default_words.json');
        final List<dynamic> jsonList = json.decode(jsonString);
        _cards = jsonList.map((json) => TabooCard.fromJson(json)).toList();
        print(
            'Successfully loaded ${_cards!.length} cards without lib/ prefix');
        return _cards!;
      } catch (e2) {
        print('Error loading without lib/ prefix: $e2');

        // Try using DefaultAssetBundle
        try {
          print('Attempting to load using DefaultAssetBundle...');
          final jsonString = await DefaultAssetBundle.of(Get.context!)
              .loadString('lib/data/default_words.json');
          final List<dynamic> jsonList = json.decode(jsonString);
          _cards = jsonList.map((json) => TabooCard.fromJson(json)).toList();
          print(
              'Successfully loaded ${_cards!.length} cards using DefaultAssetBundle');
          return _cards!;
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
            _cards = jsonList.map((json) => TabooCard.fromJson(json)).toList();
            print(
                'Successfully loaded ${_cards!.length} cards from file system');
            return _cards!;
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
              _cards =
                  jsonList.map((json) => TabooCard.fromJson(json)).toList();
              print(
                  'Using hardcoded JSON as fallback - loaded ${_cards!.length} cards');
              return _cards!;
            } catch (e5) {
              print('Error with hardcoded JSON: $e5');

              // Last resort - fully manual cards
              _cards = [
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
                  'Using manual cards as last resort - loaded ${_cards!.length} cards');
              return _cards!;
            }
          }
        }
      }
    }
  }

  static Future<TabooCard> getRandomCard(List<int> usedIndices) async {
    final cards = await loadTabooCards();
    final random = Random();
    int index;

    // Make sure we don't repeat cards unless we've used them all
    if (usedIndices.length >= cards.length) {
      // If all cards have been used, reset used indices
      usedIndices.clear();
    }

    do {
      index = random.nextInt(cards.length);
    } while (usedIndices.contains(index));

    usedIndices.add(index);
    return cards[index];
  }
}
