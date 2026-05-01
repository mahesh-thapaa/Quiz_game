import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/models/discover/discover_models.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/discover_screen/widgets/discover_widgets_card.dart';
import 'package:quiz_game/controllers/notification_controller.dart';
import 'package:quiz_game/provider/notification_provider.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Stream<QuerySnapshot> _quizzesStream;

  @override
  void initState() {
    super.initState();
    _quizzesStream = FirebaseFirestore.instance
        .collection('quizzes')
        .where('isDiscover', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App bar ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.hText,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Discover More Challenges',
                      style: TextStyle(
                        color: AppColors.hText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ───────────────────────────────────────
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _quizzesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No upcoming challenges yet.',
                        style: TextStyle(color: AppColors.stext),
                      ),
                    );
                  }

                  // ✅ PERFORMANCE FIX: Process data only once per stream update
                  final List<DiscoverModels> challenges = docs
                      .map(
                        (doc) => DiscoverModels.fromFirestore(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        ),
                      )
                      .toList();

                  challenges.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Explore more football quizzes. Test your expertise across these upcoming categories.',
                                style: TextStyle(
                                  color: AppColors.stext,
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                DiscoverWidgetsCard(model: challenges[index]),
                            childCount: challenges.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ElevatedButton(
            //   onPressed: () async {
            //     await NotificationController().showInstantNotification();
            //   },
            //   child: const Text("Instant Test"),
            // ),

            // ElevatedButton(
            //   onPressed: () async {
            //     await NotificationController().scheduleTestAfter2Minutes();
            //   },
            //   child: const Text("Schedule 2 Min Test"),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await NotificationController().printPendingNotifications();
            //   },
            //   child: const Text("Show Pending"),
            // ),
          ],
        ),
      ),
    );
  }
}
