import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/common/level_grid_screen.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key});

  /// Firestore document ID for the Champions League quiz.
  static const String _quizDocId = 'ITjxRubOgUp1MSXFRYjj';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('quizzes')
          .doc(_quizDocId)
          .snapshots(),
      builder: (context, snapshot) {
        String? imagePath;
        String title = "Champions \nLeague";

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null) {
            imagePath = data['imagePath'] as String?;
            final fetchedTitle = data['title'] as String?;
            if (fetchedTitle != null && fetchedTitle.isNotEmpty) {
              // Format title with line break if it is 'Champions League'
              if (fetchedTitle == "Champions League") {
                title = "Champions \nLeague";
              } else {
                title = fetchedTitle;
              }
            }
          }
        }

        // Determine correct ImageProvider based on imagePath
        ImageProvider imageProvider;
        if (imagePath != null && imagePath.isNotEmpty) {
          if (imagePath.startsWith('http')) {
            imageProvider = NetworkImage(imagePath);
          } else {
            imageProvider = AssetImage(imagePath);
          }
        } else {
          imageProvider = const AssetImage("assets/images/ucl.jpg");
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LevelGridScreen(
                  title: "CHAMPIONS LEAGUE",
                  categoryId: _quizDocId,
                  firestoreName: "Champions League",
                ),
              ),
            );
          },
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.4),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 32,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
