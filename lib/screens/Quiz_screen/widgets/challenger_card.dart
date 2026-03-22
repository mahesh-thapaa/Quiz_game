import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import '../models/colors.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage("asstes/images/ucl.jpg"),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DAILY CHALLENGE",
                  style: TextStyle(
                    color: AppColors.hText,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Spacer(),
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
                      "Champipons \nLeauge 2024",
                      style: TextStyle(
                        fontSize: 36,
                        color: AppColors.hText,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
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
                            "asstes/svg/dot.svg",
                            colorFilter: ColorFilter.mode(
                              AppColors.hText,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "ENDS IN 18H \n22M",
                            style: TextStyle(
                              color: AppColors.hText,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
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
