import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import '../models/colors.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.progess,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Progress to Next \nUnlock",
                style: TextStyle(
                  color: AppColors.hText,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                'LVL 4',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SvgPicture.asset(
                "asstes/svg/arrow.svg",
                colorFilter: ColorFilter.mode(Colors.blueGrey, BlendMode.srcIn),
              ),
              Text(
                "LVL 5",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey,
            color: AppColors.dShade,
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Text(
                "Next unlock:   ",
                style: TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              Text(
                "Legends Quiz",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
