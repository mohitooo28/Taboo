import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CompactGameSettings extends StatelessWidget {
  final int playTime;
  final int rounds;
  final int passes;
  final Function() onEditPressed;

  const CompactGameSettings({
    super.key,
    required this.playTime,
    required this.rounds,
    required this.passes,
    required this.onEditPressed,
  });

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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CURRENT SETTINGS",
                style: GoogleFonts.doHyeon(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: onEditPressed,
                child: Text(
                  "EDIT",
                  style: GoogleFonts.nunito(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            // mainAxisAlignment: MainAxisAlignment.,
            children: [
              SettingTile(
                icon: Iconsax.reserve,
                title: "Play Time",
                value: "${playTime}s",
              ),
              const SizedBox(width: 15),
              SettingTile(
                icon: Iconsax.arrow_2,
                title: "Rounds",
                value: "$rounds",
              ),
              const SizedBox(width: 15),
              SettingTile(
                icon: Iconsax.next,
                title: "Passes",
                value: "$passes",
                isPass: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isPass;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4B4093),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Icon(
              icon,
              color: Colors.white.withOpacity(0.7),
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.nunito(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            (isPass && value == '9')
                ? Icon(
                    Icons.all_inclusive,
                    color: Colors.white,
                    size: 24,
                  )
                : Text(
                    value,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
