import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vibration/vibration.dart';

class TeamContainer extends StatelessWidget {
  final bool isEditing;
  final String teamName;
  final TextEditingController teamController;
  final FocusNode teamFocusNode;
  final VoidCallback onEditPressed;
  final List<Color> gradientColors;

  const TeamContainer({
    super.key,
    required this.isEditing,
    required this.teamName,
    required this.teamController,
    required this.teamFocusNode,
    required this.onEditPressed,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: isEditing
                ? TextField(
                    controller: teamController,
                    focusNode: teamFocusNode,
                    maxLength: 12,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  )
                : Text(
                    teamName,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Iconsax.edit_2, color: Colors.white),
              onPressed: () {
                Vibration.vibrate(duration: 50);
                onEditPressed();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          if (isEditing)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  Vibration.vibrate(duration: 50);
                  onEditPressed();
                },
              ),
            ),
        ],
      ),
    );
  }
}
