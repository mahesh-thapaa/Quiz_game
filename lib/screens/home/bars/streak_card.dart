// lib/screens/home/bars/streak_card.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/streak_model.dart';
import 'package:quiz_game/screens/streak/streak_logic.dart';
import 'package:quiz_game/screens/home/widgets/streak_reward_page.dart';

class StreakCard extends StatefulWidget {
  final StreakModel? initialStreak;
  final bool triggerLoginOnInit;

  const StreakCard({
    super.key,
    this.initialStreak,
    this.triggerLoginOnInit = false,
  });

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  StreakModel? _streak;

  // ✅ fallback so shimmer never gets stuck
  static const _defaultStreak = StreakModel(
    title: StreakLogic.streakTitle,
    currentDay: 0,
    totalDays: StreakLogic.totalDaysPerCycle,
  );

  @override
  void initState() {
    super.initState();

    // ✅ Set default IMMEDIATELY so shimmer never shows
    _streak = widget.initialStreak ?? _defaultStreak;

    _init();
  }

  Future<void> _init() async {
    if (widget.triggerLoginOnInit) {
      try {
        final result = await StreakLogic.onLogin();
        if (!mounted) return;
        setState(() => _streak = result.streak);

        if (result.justCompletedCycle) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const StreakRewardPage(streakDays: 7, coinsEarned: 500),
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('⚠️ StreakCard: $e');
        // ✅ show default card instead of stuck shimmer
        if (mounted) setState(() => _streak = _defaultStreak);
      }
    } else {
      try {
        final streak = await StreakLogic.load();
        if (!mounted) return;
        setState(() => _streak = streak);
      } catch (e) {
        debugPrint('⚠️ StreakCard: $e');
        // ✅ show default card instead of stuck shimmer
        if (mounted) setState(() => _streak = _defaultStreak);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_streak == null) return const _ShimmerCard();

    final streak = _streak!;
    final isBroken = streak.isBroken;
    final isComplete = streak.isComplete;

    debugPrint('════════════════════════════════════════════════');
    debugPrint('🎨 [STREAK CARD BUILD]');
    debugPrint(
      '   → currentDay: ${streak.currentDay} (should be 1-7 for green bars)',
    );
    debugPrint('   → totalDays: ${streak.totalDays}');
    debugPrint('   → isBroken: $isBroken (currentDay == 0)');
    debugPrint('   → isComplete: $isComplete (currentDay >= 7)');
    debugPrint('════════════════════════════════════════════════');

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
                Text(
                  streak.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                // Day segments
                Row(
                  children: List.generate(streak.totalDays, (i) {
                    final done = i < streak.currentDay;
                    debugPrint(
                      '🔍 [BAR DEBUG] i=$i | currentDay=${streak.currentDay} | done=$done',
                    );
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

                if (isComplete) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'Full week complete! Keep it going 🎉',
                    style: TextStyle(color: AppColors.stext, fontSize: 11),
                  ),
                ] else if (isBroken) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'Login today to start a new streak!',
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
}

// ── Shimmer placeholder ───────────────────────────────────────────────────────

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _block(42, 42, isCircle: true),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(120, 14),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      7,
                      (i) => Expanded(
                        child: Container(
                          height: 5,
                          margin: EdgeInsets.only(right: i < 6 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: _anim.value * 0.25,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _block(double w, double h, {bool isCircle = false}) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: _anim.value * 0.15),
      borderRadius: isCircle
          ? BorderRadius.circular(w)
          : BorderRadius.circular(6),
    ),
  );
}
