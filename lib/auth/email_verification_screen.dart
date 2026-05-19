import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/controllers/auth_controller.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/screens/main_screen/main_screen.dart';
import 'package:quiz_game/auth/email_login.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  Timer? _pollTimer;
  Timer? _countdownTimer;

  bool _isCheckingManually = false;
  bool _isSendingEmail = false;

  /// Resend cooldown in seconds
  int _resendCooldown = 0;

  late AnimationController _iconAnimController;
  late Animation<double> _iconScale;

  String get _userEmail =>
      FirebaseAuth.instance.currentUser?.email ?? 'your email';

  @override
  void initState() {
    super.initState();

    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _iconScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _iconAnimController, curve: Curves.easeInOut),
    );

    // Poll Firebase every 4 seconds automatically
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _checkVerification(silent: true);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    _iconAnimController.dispose();
    super.dispose();
  }

  Future<void> _checkVerification({bool silent = false}) async {
    if (!mounted) return;

    if (!silent) setState(() => _isCheckingManually = true);

    final auth = context.read<AuthController>();
    final verified = await auth.checkEmailVerified();

    if (!mounted) return;

    if (verified) {
      _pollTimer?.cancel();

      // Load user progress then go to main screen
      final p = context.read<UserProgressProvider>();
      await p.clearAndReload();

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (_) => false,
      );
    } else {
      if (!silent && mounted) {
        setState(() => _isCheckingManually = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Email not verified yet — please check your inbox.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      if (!silent && mounted) setState(() => _isCheckingManually = false);
    }
  }

  Future<void> _resendEmail() async {
    if (_resendCooldown > 0 || _isSendingEmail) return;

    setState(() => _isSendingEmail = true);

    final auth = context.read<AuthController>();
    await auth.sendVerificationEmail();

    if (!mounted) return;
    setState(() {
      _isSendingEmail = false;
      _resendCooldown = 60; // 60-second cooldown
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '📧 Verification email resent! Check your inbox.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Start countdown
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendCooldown > 0) {
          _resendCooldown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const EmailLogin()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ThemeColors.of(context);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _signOut,
            child: Text(
              'Sign Out',
              style: TextStyle(color: themeColors.stext, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated email icon
                ScaleTransition(
                  scale: _iconScale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 52,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Verify Your Email',
                  style: TextStyle(
                    color: themeColors.hText,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'A verification link has been sent to:',
                  style: TextStyle(color: themeColors.stext, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                Text(
                  _userEmail,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  'Click the link in your inbox to confirm your email address. '
                  'This screen will automatically detect when you\'ve verified.',
                  style: TextStyle(color: themeColors.stext, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // "Check spam" hint
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "Can't find it? Check your Spam / Junk folder.",
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // "I've verified" button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        _isCheckingManually ? null : () => _checkVerification(),
                    child: _isCheckingManually
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "I've Verified — Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 14),

                // Resend button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _resendCooldown > 0
                            ? themeColors.divider
                            : AppColors.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        (_resendCooldown > 0 || _isSendingEmail)
                            ? null
                            : _resendEmail,
                    child: _isSendingEmail
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: themeColors.hText,
                            ),
                          )
                        : Text(
                            _resendCooldown > 0
                                ? 'Resend in ${_resendCooldown}s'
                                : 'Resend Verification Email',
                            style: TextStyle(
                              color: _resendCooldown > 0
                                  ? themeColors.stext
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
