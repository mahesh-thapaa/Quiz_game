import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_game/models/colors.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;
  final Widget nextScreen;
  final LinearGradient gradient;
  // final String assetPath;
  final String appName;
  final String tagline;

  const SplashScreen({
    Key? key,
    required this.duration,
    required this.nextScreen,
    required this.gradient,
    // required this.assetPath,
    required this.appName,
    required this.tagline,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => widget.nextScreen),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            children: [
              const Spacer(flex: 3),

              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.all(28),
                  // child: SvgPicture.asset(
                  //   // widget.assetPath,
                  //   colorFilter: const ColorFilter.mode(
                  //     AppColors.hText,
                  //     BlendMode.srcIn,
                  //   ),
                  //   placeholderBuilder: (_) => const Icon(
                  //     Icons.sports_soccer,
                  //     color: AppColors.hText,
                  //     size: 56,
                  //   ),
                  // ),
                ),
              ),

              const SizedBox(height: 36),

              Text(
                widget.appName,
                style: const TextStyle(
                  color: AppColors.hText,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.tagline,
                style: TextStyle(
                  color: AppColors.hText.withValues(alpha: 0.45),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3,
                ),
              ),

              const Spacer(flex: 2),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, _) {
                    final dots =
                        '.' * ((_progressAnimation.value * 6).toInt() % 4 + 1);
                    final fillWidth =
                        (screenWidth - 80) * _progressAnimation.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Stack(
                            children: [
                              Container(
                                height: 4,
                                width: double.infinity,
                                color: AppColors.hText.withValues(alpha: 0.15),
                              ),

                              Container(
                                height: 4,
                                width: fillWidth,
                                decoration: BoxDecoration(
                                  gradient: widget.gradient,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'LOADING$dots',
                          style: TextStyle(
                            color: AppColors.titleColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
