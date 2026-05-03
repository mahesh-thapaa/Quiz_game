// lib/screens/splash_screen/splash_screesn.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/login.dart';
import 'package:quiz_game/screens/main_screen/main_screen.dart';
import 'package:quiz_game/controllers/fcm_notification_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _progressCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    final notificationService = NotificationService();

    notificationService.requestNotificationPermission();
    notificationService.getFcmToken();

    // _logoCtrl = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 800),
    // );

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.elasticOut,
    ).drive(Tween(begin: 0.5, end: 1.0));

    _logoFade = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textFade = CurvedAnimation(
      parent: _textCtrl,
      curve: Curves.easeIn,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _textSlide = CurvedAnimation(
      parent: _textCtrl,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.3), end: Offset.zero));

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), // Fast loading
    );

    _progressAnim = CurvedAnimation(
      parent: _progressCtrl,
      curve: Curves.easeInOut,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _logoCtrl.forward().then((_) {
      _textCtrl.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _progressCtrl.forward().then((_) async {
          if (!mounted) return;

          // ✅ AUTO-LOGIN: Skip login screen if user is already authenticated
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final p = context.read<UserProgressProvider>();
            await Future.wait([
              p.loadFromFirestore(),
              p.initStreak(isLogin: true),
            ]);

            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Login()),
            );
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1DB954).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(flex: 2),
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF1DB954,
                          ).withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.sports_soccer_rounded,
                        color: Colors.white,
                        size: 54,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      const Text(
                        'GOALIQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ELITE FOOTBALL TRIVIA',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: FadeTransition(
                  opacity: _textFade,
                  child: AnimatedBuilder(
                    animation: _progressAnim,
                    builder: (context, _) {
                      return Column(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final trackWidth = constraints.maxWidth;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 4,
                                      width: trackWidth,
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                    Container(
                                      height: 4,
                                      width: trackWidth * _progressAnim.value,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1DB954),
                                            Color(0xFF25E86A),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF1DB954,
                                            ).withValues(alpha: 0.6),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'LOADING....',
                            style: TextStyle(
                              color: const Color(
                                0xFF1DB954,
                              ).withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }
}
