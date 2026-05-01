import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quiz_game/provider/daily_challenger_provider.dart';
// import '../models/colors.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("This is Dailychallanger container");
      },
      child: Container(
        height: 320,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: const AssetImage("assets/images/ucl.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "DAILY CHALLENGE",
                      style: TextStyle(
                        color: AppColors.hText,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          const Shadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.dShade,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "500 XP REWARD",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Champipons \nLeauge 2026",
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColors.hText,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.background.withValues(alpha: 0.3),
                        ),

                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/dot.svg",
                              colorFilter: ColorFilter.mode(
                                AppColors.hText,
                                BlendMode.srcIn,
                              ),
                            ),
                            Consumer<DailyChallengerProvider>(
                              builder: (context, provider, child) {
                                final duration = provider.remaining;
                                final hours = duration.inHours;
                                final minutes = duration.inMinutes % 60;
                                final seconds = duration.inSeconds % 60;
                                return Text(
                                  "ENDS IN ${hours}H \n${minutes}M ${seconds}S",
                                  style: const TextStyle(
                                    color: AppColors.hText,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //  Container(
    //   height: 160,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(16),
    //     image: const DecorationImage(
    //       image: AssetImage("assets/images/ucl.jpg"),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    //   child: Container(
    //     padding: const EdgeInsets.all(12),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(16),
    //       gradient: LinearGradient(
    //         colors: [
    //           AppColors.background.withValues(alpha: 0.7),
    //           Colors.transparent,
    //         ],
    //         begin: Alignment.bottomCenter,
    //         end: Alignment.topCenter,
    //       ),
    //     ),
    //     child: const Align(
    //       alignment: Alignment.bottomLeft,
    //       child: Text(
    //         "Champions League 2024",
    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //   ),
    // );
  }
}
