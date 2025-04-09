import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class CustomInstructionsDialog extends StatelessWidget {
  const CustomInstructionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Instructions",
                  style: GoogleFonts.doHyeon(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF47215E),
                      letterSpacing: 1.2),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF47215E)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // Scrollable content with purple scrollbar
          Flexible(
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor:
                      MaterialStateProperty.all(const Color(0xFF73378D)),
                  thickness: MaterialStateProperty.all(6.0),
                  radius: const Radius.circular(3.0),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      24, 0, 24, 24), // Less right padding for scrollbar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "Want to play Taboo with your own words? Use any AI (like ChatGPT) to generate custom cards!",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Vibration.vibrate(duration: 50);
                          const promptToCopy =
                              '''Give me a JSON array for a Taboo game. For each word, give 5 related forbidden words. Format: [ { "word": "Sun", "forbidden": ["Bright", "Hot", "Sky", "Day", "Light"] }, { "word": "Moon", "forbidden": ["Night", "Sky", "Full", "Crescent", "Lunar"] } ] Words: Sun, Moon, Pizza, River, Elephant''';
                          Clipboard.setData(
                              const ClipboardData(text: promptToCopy));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Prompt copied to clipboard!',
                                style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF47215E),
                            ),
                          );
                        },
                        child: Text(
                          "🧠 Tap to Copy Prompt:",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF47215E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tap to copy container
                      GestureDetector(
                        onTap: () {
                          const promptToCopy =
                              '''Give me a JSON array for a Taboo game. For each word, give 5 related forbidden words. Format: [ { "word": "Sun", "forbidden": ["Bright", "Hot", "Sky", "Day", "Light"] }, { "word": "Moon", "forbidden": ["Night", "Sky", "Full", "Crescent", "Lunar"] } ] Words: Sun, Moon, Pizza, River, Elephant''';
                          Clipboard.setData(
                              const ClipboardData(text: promptToCopy));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Prompt copied to clipboard!',
                                style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF47215E),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            '''Give me a JSON array for a Taboo game. For each word, give 5 related forbidden words.\n\nFormat: [ { "word": "Sun", "forbidden": ["Bright", "Hot", "Sky", "Day", "Light"] } ] \n\nWords: Sun, ...''',
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          children: const [
                            TextSpan(text: "👉 "),
                            TextSpan(
                              text:
                                  "Copy this prompt, replace the words at the end with your own, and paste it into any LLM (Like ChatGPT) ! ",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "🕹️ Then:",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF47215E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. Copy the AI's JSON output",
                              style: GoogleFonts.nunito(fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "2. Paste it in Custom Craze's Custom Data section",
                              style: GoogleFonts.nunito(fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "3. Select the settings and click on Ready to play",
                              style: GoogleFonts.nunito(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Vibration.vibrate(duration: 50);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF47215E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            "Got it!",
                            style: GoogleFonts.doHyeon(
                                fontSize: 16, letterSpacing: 1.2),
                          ),
                        ),
                      ),
                    ],
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
