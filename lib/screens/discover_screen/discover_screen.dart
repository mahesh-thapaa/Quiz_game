import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_game/controllers/notification_controller.dart';
import 'package:quiz_game/models/discover/discover_models.dart';
import 'package:quiz_game/models/colors.dart';
import 'package:quiz_game/screens/discover_screen/widgets/discover_widgets_card.dart';

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
      backgroundColor: ThemeColors.of(context).background,
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
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: ThemeColors.of(context).hText,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Discover More Challenges',
                      style: TextStyle(
                        color: ThemeColors.of(context).hText,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Something went wrong while loading challenges. Please try again shortly.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ThemeColors.of(context).stext,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No upcoming challenges yet.',
                        style: TextStyle(color: ThemeColors.of(context).stext),
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

                  int sortPriority(DiscoverModels model) {
                    final title = model.title.toLowerCase();
                    if (title.contains("ballon d'or")) return 0;
                    if (title.contains('world cup')) return 1;
                    return 2;
                  }

                  challenges.sort((a, b) {
                    final priorityA = sortPriority(a);
                    final priorityB = sortPriority(b);

                    if (priorityA != priorityB) {
                      return priorityA.compareTo(priorityB);
                    }

                    return a.createdAt.compareTo(b.createdAt);
                  });

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore more football quizzes. Test your expertise across these upcoming categories.',
                                style: TextStyle(
                                  color: ThemeColors.of(context).stext,
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
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final cols = constraints.crossAxisExtent >= 600
                                ? 3
                                : 2;
                            return SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: cols,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.0,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => DiscoverWidgetsCard(
                                  model: challenges[index],
                                ),
                                childCount: challenges.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await NotificationController().scheduleTestNotification();
                await NotificationController().printPendingNotifications();
              },
              child: const Text('Test 2-Min Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
