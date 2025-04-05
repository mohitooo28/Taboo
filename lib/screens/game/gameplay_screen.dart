import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taboo/controllers/game_controller.dart';
import 'package:taboo/models/taboo_card.dart';
import 'package:taboo/screens/game/round_summary_screen.dart';
import 'package:taboo/services/taboo_service.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({Key? key}) : super(key: key);

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen>
    with TickerProviderStateMixin {
  final GameController gameController = Get.find();
  late Timer _timer;
  int _timeLeft = 0;
  TabooCard? _currentCard;
  bool _isLoading = true;

  // Animation controllers
  late AnimationController _textPulseController;
  late AnimationController _cardExitController;
  late AnimationController _cardEntranceController;
  late AnimationController _timerController;

  // Card state tracking
  bool _isExiting = false;
  String _exitDirection = 'none';
  String _stampType = 'none';

  @override
  void initState() {
    super.initState();
    _timeLeft = gameController.playTime.value;

    // Setup animation controllers
    _textPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _cardExitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _cardEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: gameController.playTime.value),
    )..forward();

    // Load first card
    _loadNextCard();

    // Start timer
    _startTimer();
  }

  Future<void> _loadNextCard() async {
    setState(() {
      _isLoading = true;
      _stampType = 'none';
      _exitDirection = 'none';
      _isExiting = false;
    });

    try {
      final card =
          await TabooService.getRandomCard(gameController.usedCardIndices);

      setState(() {
        _currentCard = card;
        _isLoading = false;
      });

      // Reset entrance animation
      _cardEntranceController.reset();
      _cardEntranceController.forward();
    } catch (e) {
      print('Error loading next card: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;

          // Update timer animation controller value
          _timerController.value =
              1 - (_timeLeft / gameController.playTime.value);

          // Vibrate when time is low
          if (_timeLeft <= 5) {
            Vibration.vibrate(duration: 10);
          }
        } else {
          _timer.cancel();
          // Time's up - record it and move to summary
          if (_currentCard != null) {
            gameController.scoreWord(_currentCard!.word, 'timeout');
          }

          // Vibrate and transition to summary
          Vibration.vibrate(duration: 50);
          _goToSummary();
        }
      });
    });
  }

  void _handleCorrect() {
    if (_isExiting) return;

    Vibration.vibrate(duration: 50);

    setState(() {
      _stampType = 'correct';
      _exitDirection = 'left';
      _isExiting = true;
    });

    // Show stamp for a moment before exiting
    Timer(const Duration(milliseconds: 800), () {
      _cardExitController.forward().then((_) {
        if (_currentCard != null) {
          gameController.scoreWord(_currentCard!.word, 'correct');
        }
        _cardExitController.reset();
        _loadNextCard();
      });
    });
  }

  void _handleTaboo() {
    if (_isExiting) return;

    Vibration.vibrate(duration: 50);

    setState(() {
      _stampType = 'taboo';
      _exitDirection = 'right';
      _isExiting = true;
    });

    // Show stamp for a moment before exiting
    Timer(const Duration(milliseconds: 800), () {
      _cardExitController.forward().then((_) {
        if (_currentCard != null) {
          gameController.scoreWord(_currentCard!.word, 'taboo');
        }
        _cardExitController.reset();
        _loadNextCard();
      });
    });
  }

  void _handleSkip() {
    if (_isExiting || !gameController.canPass) return;

    Vibration.vibrate(duration: 20);

    setState(() {
      _stampType = 'skip';
      _exitDirection = 'right';
      _isExiting = true;
    });

    // Show stamp for a moment before exiting
    Timer(const Duration(milliseconds: 800), () {
      _cardExitController.forward().then((_) {
        if (_currentCard != null) {
          gameController.scoreWord(_currentCard!.word, 'pass');
        }
        _cardExitController.reset();
        _loadNextCard();
      });
    });
  }

  void _goToSummary() {
    _timer.cancel();
    Vibration.vibrate(duration: 100);
    Get.off(
      () => const RoundSummaryScreen(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _textPulseController.dispose();
    _cardExitController.dispose();
    _cardEntranceController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRedTeam = gameController.isRedTeamTurn.value;
    final teamColor =
        isRedTeam ? const Color(0xFFBF393C) : const Color(0xFF3498DB);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              teamColor.withOpacity(0.8),
              teamColor,
              teamColor.withOpacity(0.7),
              teamColor.withOpacity(0.9),
            ],
            stops: const [0.0, 0.33, 0.66, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() => Text(
                    "Round ${gameController.displayRound.value}",
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )),

              // Spacer for alignment
              const SizedBox(height: 15),

              // Timer
              _buildImprovedTimer(),

              // Spacer
              const SizedBox(height: 25),

              // Taboo Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : _buildAnimatedTabooCard(_currentCard),
                ),
              ),

              // Spacer
              const SizedBox(height: 20),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Skip button
                    Obx(() => _buildImprovedActionButton(
                          onTap: _handleSkip,
                          color: Colors.amber,
                          icon: "assets/images/skip.svg",
                          label: gameController.numberOfPasses.value == 9
                              ? "∞"
                              : "${gameController.remainingPasses.value}",
                          enabled: gameController.canPass,
                          buttonType: "skip",
                        )),

                    // Taboo button
                    _buildImprovedActionButton(
                      onTap: _handleTaboo,
                      color: Colors.red,
                      icon: "assets/images/taboo.svg",
                      label: "",
                      enabled: true,
                      buttonType: "taboo",
                    ),

                    // Correct button
                    _buildImprovedActionButton(
                      onTap: _handleCorrect,
                      color: Colors.green,
                      icon: "assets/images/tick.svg",
                      label: "",
                      enabled: true,
                      buttonType: "correct",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImprovedTimer() {
    final bool isLowTime = _timeLeft <= 5;

    return AnimatedBuilder(
      animation: Listenable.merge([_timerController, _textPulseController]),
      builder: (context, child) {
        final double textScale =
            isLowTime ? 1.0 + (_textPulseController.value * 0.1) : 1.0;

        return SizedBox(
          width: 90,
          height: 90,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background static circle
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),

              // Animated progress indicator
              CustomPaint(
                size: const Size(90, 90),
                painter: TimerPainter(
                  animation: _timerController,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: isLowTime ? Colors.red : Colors.white,
                ),
              ),

              // Timer text with pulse animation only for text
              Transform.scale(
                scale: textScale,
                child: Text(
                  "$_timeLeft",
                  style: GoogleFonts.doHyeon(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTabooCard(TabooCard? card) {
    if (card == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: Text("No card available")),
      );
    }

    // Determine animation based on state
    Widget cardWidget = _buildTabooCard(card);

    // Entrance animation (right to center)
    cardWidget = SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardEntranceController,
        curve: Curves.easeOut,
      )),
      child: cardWidget,
    );

    // Exit animation
    if (_isExiting) {
      final Offset endOffset = _exitDirection == 'left'
          ? const Offset(-1.0, 0.0)
          : const Offset(1.0, 0.0);

      cardWidget = SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: endOffset,
        ).animate(CurvedAnimation(
          parent: _cardExitController,
          curve: Curves.easeIn,
        )),
        child: cardWidget,
      );
    }

    return cardWidget;
  }

  Widget _buildTabooCard(TabooCard card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            Positioned(
              bottom: -50,
              right: -90,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
                child: Opacity(
                  opacity: 0.04,
                  child: Image.asset(
                    'assets/images/psyduck.png',
                    width: 400,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Card content
            Column(
              children: [
                // Main word background
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF441A5B), // Deep purple
                        Color(
                            0xFF73378D), // A lighter purple for smooth gradient
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      card.word.toUpperCase(),
                      style: GoogleFonts.doHyeon(
                        fontSize: 33,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

                // Forbidden words
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final forbiddenWord in card.forbiddenWords)
                          Text(
                            forbiddenWord,
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.black.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Stamp overlay with stamp animation
            if (_stampType != 'none')
              Positioned(
                bottom: _stampType == 'taboo' ? 130 : 20,
                right: _stampType == 'taboo' ? 23 : 10,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<double>(begin: 1.5, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Opacity(
                      opacity: 2.0 - scale > 1.0 ? 1.0 : 2.0 - scale,
                      child: Transform.scale(
                        scale: scale,
                        child: Transform.rotate(
                          angle: _stampType == 'taboo' ? -0.5 : -0.2,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    _stampType == 'correct'
                        ? 'assets/images/tick.svg'
                        : _stampType == 'taboo'
                            ? 'assets/images/stamp.svg'
                            : 'assets/images/skip.svg',
                    width: _stampType == 'taboo' ? 270 : 80,
                    color: _stampType == 'correct'
                        ? Colors.green
                        : _stampType == 'taboo'
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImprovedActionButton({
    required Function() onTap,
    required Color color,
    required String icon,
    required String label,
    required bool enabled,
    required String buttonType,
  }) {
    final double buttonSize = buttonType == "taboo" ? 120 : 85;
    final double iconPadding = buttonType == "taboo" ? 30 : 20;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main button
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: buttonType == "taboo" ? color : Colors.white,
                shape: BoxShape.circle,
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
                border: buttonType != "taboo"
                    ? null
                    : Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(iconPadding),
                  child: SvgPicture.asset(
                    icon,
                  ),
                ),
              ),
            ),

            // Skip counter badge (positioned outside the button)
            if (buttonType == "skip" && label.isNotEmpty)
              Positioned(
                top: -4,
                left: -4,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for timer circle animation
class TimerPainter extends CustomPainter {
  TimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);

    paint.color = color;
    final double progress = animation.value;
    final double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2.0),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
