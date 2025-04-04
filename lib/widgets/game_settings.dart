import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class GameSettingsWidget extends StatelessWidget {
  final int playTime;
  final int round;
  final int numberOfPasses;
  final String Function(int) getPassesDisplay;
  final ValueChanged<double> onPlayTimeChanged;
  final ValueChanged<double> onRoundChanged;
  final ValueChanged<double> onPassesChanged;

  const GameSettingsWidget({
    Key? key,
    required this.playTime,
    required this.round,
    required this.numberOfPasses,
    required this.getPassesDisplay,
    required this.onPlayTimeChanged,
    required this.onRoundChanged,
    required this.onPassesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2D1A4A),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(
              "GAME SETTINGS",
              style: GoogleFonts.doHyeon(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Play Time
          SettingSlider(
            icon: Iconsax.reserve,
            title: "Play Time",
            value: playTime,
            displayValue: playTime.toString(),
            min: 30,
            max: 120,
            divisions: 9,
            onChanged: onPlayTimeChanged,
          ),
          const SizedBox(height: 20),

          // Round
          SettingSlider(
            icon: Iconsax.arrow_2,
            title: "Round",
            value: round,
            displayValue: round.toString(),
            min: 1,
            max: 12,
            divisions: 11,
            onChanged: onRoundChanged,
          ),
          const SizedBox(height: 20),

          // Number of Passes
          SettingSlider(
            icon: Iconsax.next,
            title: "Number of Passes",
            value: numberOfPasses,
            displayValue: getPassesDisplay(numberOfPasses),
            min: 0,
            max: 9,
            divisions: 9,
            onChanged: onPassesChanged,
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

class SettingSlider extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final String displayValue;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const SettingSlider({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.displayValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF4B4093),
                  border: Border.all(color: Color(0xFF5E53A6)),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    displayValue,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.7),
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            overlayColor: Colors.white.withOpacity(0.1),
          ),
          child: Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
