import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class GameTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetName;
  final bool animateFromLeft;
  final Widget destination;

  const GameTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.animateFromLeft = true,
    required this.assetName,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: GestureDetector(
          onTap: () {
            Vibration.vibrate(duration: 100);
            Get.to(destination,
                transition: animateFromLeft
                    ? Transition.leftToRightWithFade
                    : Transition.rightToLeftWithFade);
          },
          child: Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              border: Border.all(color: Colors.white, width: 1),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFFC9361), // Top Right Color
                  Color(0xFFFF7674), // Bottom Left Color
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated SVG with animate_do
                Positioned(
                  left: animateFromLeft ? -25 : null,
                  right: animateFromLeft ? null : -25,
                  bottom: -20,
                  child: animateFromLeft
                      ? SlideInLeft(
                          duration: Duration(milliseconds: 800),
                          from: 100, // Distance to animate (pixels)
                          child: _buildSvgImage(),
                        )
                      : SlideInRight(
                          duration: Duration(milliseconds: 800),
                          from: 100, // Distance to animate (pixels)
                          child: _buildSvgImage(),
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.aclonica(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          letterSpacing: 1,
                        ),
                      ),
                      Spacer(),
                      Text(
                        subtitle,
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSvgImage() {
    return ClipRect(
      child: Opacity(
        opacity: 0.3,
        child: SvgPicture.asset(
          assetName,
          width: 180,
          height: 180,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color(0xFFFDA577).withOpacity(0.5),
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }
}
