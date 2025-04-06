import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RulesCard extends StatelessWidget {
  const RulesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
            border: Border.all(color: Colors.white, width: 1),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF64A7E4),
                Color(0xFF876DD6),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -5,
                bottom: -35,
                child: SlideInRight(
                  duration: Duration(milliseconds: 800),
                  from: 100,
                  child: ClipRect(
                    child: Opacity(
                      opacity: 0.3,
                      child: SvgPicture.asset(
                        'assets/vectors/gaming.svg',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Color(0xFF76A1E5).withOpacity(0.5),
                          BlendMode.srcATop,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("RULES",
                      style: GoogleFonts.aclonica(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
