import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/controllers/auth_controller.dart';
import 'package:quiz_game/screens/buttons/buttons.dart';
import 'package:quiz_game/screens/main_screen/main_screen.dart';
import 'package:quiz_game/auth/email_signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  // Guest / Google login (your existing flow)
  Future<void> _goToHome() async {
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthController>();
      final success = await auth.signInAnonymously();

      if (success) {
        final p = context.read<UserProgressProvider>();
        await Future.wait([p.loadFromFirestore(), p.initStreak(isLogin: true)]);
      }
    } catch (e) {
      debugPrint('❌ Login _goToHome error: $e');
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _goToEmailSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmailSignup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "GoalIQ",
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 62,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Play Football Quiz",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.hText,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Test your knowledge against thousands of fans worldwide.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.stext,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Original login button (Google / Guest) ───────────────────
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Buttons(
                      onGuestTap: _goToHome,
                      onEmailTap: _goToEmailSignup,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
