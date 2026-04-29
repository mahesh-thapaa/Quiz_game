// lib/screens/home/bars/streak_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';
import 'package:quiz_game/provider/user_progress_provider.dart';
import 'package:quiz_game/controllers/streak_controller.dart';
import 'package:quiz_game/screens/home/widgets/streak_reward_popup.dart';
import 'package:quiz_game/auth/email_signup.dart';

class StreakCard extends StatefulWidget {
  const StreakCard({super.key});

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  bool _popupShown = false;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProgressProvider>();
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null; // Only true if not signed in at all
    final isAnonymous = user?.isAnonymous ?? false;

    final streak = p.streak ??
        const StreakModel(
          title: StreakController.streakTitle,
          currentDay: 0,
          totalDays: StreakController.totalDaysPerCycle,
        );

    // ✅ AUTOMATIC POPUP: Only for registered users
    if (!isGuest &&
        streak.currentDay >= streak.totalDays &&
        !streak.rewardClaimed &&
        !_popupShown) {
      _popupShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showStreakRewardPopup(
          context,
          streakDays: streak.totalDays,
          coinsEarned: 500,
        );
      });
    }

    return isGuest
        ? _buildGuestStreak(context, streak)
        : _buildUserStreak(streak);
  }

  Widget _buildUserStreak(StreakModel streak) {
    final isBroken = streak.isBroken;
    final isComplete = streak.isComplete;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Fire icon
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.deepCard,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF6B35),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Progress section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      streak.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Day segments
                Row(
                  children: List.generate(streak.totalDays, (i) {
                    final done = i < streak.currentDay;
                    return Expanded(
                      child: Container(
                        height: 5,
                        margin: EdgeInsets.only(
                          right: i < streak.totalDays - 1 ? 4 : 0,
                        ),
                        decoration: BoxDecoration(
                          gradient: done ? AppColors.primaryGradient : null,
                          color: done
                              ? null
                              : Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    );
                  }),
                ),

                if (isBroken) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'Come back tomorrow to continue your streak!',
                    style: TextStyle(color: AppColors.stext, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Day counter
          Text(
            isBroken
                ? '—/${streak.totalDays}'
                : 'Day ${streak.currentDay}/${streak.totalDays}',
            style: const TextStyle(
              color: AppColors.stext,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestStreak(BuildContext context, StreakModel streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Fire icon (dimmed)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.deepCard.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                color: Colors.blueGrey,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Progress section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guest Streak',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Login to start your 7-day challenge',
                  style: TextStyle(color: AppColors.stext, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Sign In CTA
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmailSignup(showBackButton: true),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'SIGN IN',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      height: 70,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.deepCard,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 10, width: 100, color: Colors.white10),
                const SizedBox(height: 10),
                Container(
                  height: 5,
                  width: double.infinity,
                  color: Colors.white10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
