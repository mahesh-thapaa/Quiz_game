// lib/screens/login.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/buttons/buttons.dart';
// import 'package:quiz_game/screens/home/home_screen.dart';
import 'package:quiz_game/screens/main_screen/main_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
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

                const SizedBox(height: 20),

                Buttons(onButtonTap: _goToHome),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
