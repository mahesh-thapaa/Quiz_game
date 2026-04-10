import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/models/home_models/home_models.dart';

class StreakLogic {
  static int _currentDay = 0;
  static int _totalDays = 7;

  static Future<StreakModel> onLogin({int totalDays = 7}) async {
    _totalDays = totalDays;
    _currentDay = 1;

    return StreakModel(
      title: 'Daily Streak',
      currentDay: _currentDay,
      totalDays: _totalDays,
    );
  }

  static Future<StreakModel> load({int totalDays = 7}) async {
    _totalDays = totalDays;

    return StreakModel(
      title: 'Daily Streak',
      currentDay: _currentDay,
      totalDays: _totalDays,
    );
  }

  static Future<void> reset() async {
    _currentDay = 0;
    _totalDays = 7;
  }
}

class StreakCard extends StatefulWidget {
  final StreakModel? initialStreak;

  /// If true, the card calls [StreakLogic.onLogin
  final bool triggerLoginOnInit;

  const StreakCard({
    super.key,
    this.initialStreak,
    this.triggerLoginOnInit = false,
  });

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard>
    with SingleTickerProviderStateMixin {
  StreakModel? _streak;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    if (widget.initialStreak != null) {
      _streak = widget.initialStreak;
      _controller.forward();
    }

    _init();
  }

  Future<void> _init() async {
    final streak = widget.triggerLoginOnInit
        ? await StreakLogic.onLogin()
        : await StreakLogic.load();

    if (!mounted) return;
    setState(() => _streak = streak);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a shimmer placeholder while loading
    if (_streak == null) {
      return _ShimmerCard();
    }

    final streak = _streak!;
    final isBroken = streak.currentDay == 0;
    final isComplete = streak.currentDay >= streak.totalDays;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
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
              child: Center(child: Icon(Icons.candlestick_chart_outlined)),
            ),
            const SizedBox(width: 14),

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

                  // Progress segments
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

                  // ── Broken streak nudge ──
                  if (isBroken) ...[
                    // const SizedBox(height: 6),
                    // const Text(
                    //   'Login today to start a new streak!',
                    //   style: TextStyle(color: AppColors.stext, fontSize: 11),
                    // ),
                  ],

                  if (isComplete) ...[
                    const SizedBox(height: 6),
                    const Text(
                      'Full week complete! Keep it going 🎉',
                      style: TextStyle(color: AppColors.stext, fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            Text(
              isBroken ? '—/7' : 'Day ${streak.currentDay}/${streak.totalDays}',
              style: const TextStyle(
                color: AppColors.stext,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

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
