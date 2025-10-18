import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ChallengeApp(),
    ),
  );
}

class ChallengeApp extends StatefulWidget {
  const ChallengeApp({super.key});

  @override
  State<ChallengeApp> createState() => _ChallengeAppState();
}

class _ChallengeAppState extends State<ChallengeApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = _themeMode == ThemeMode.dark;
    await prefs.setBool('isDarkMode', !isDark);
    setState(() {
      _themeMode = !isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'All Challenges',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: AllChallengesPage(toggleTheme: _toggleTheme, isDark: _themeMode == ThemeMode.dark),
    );
  }
}

class AllChallengesPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const AllChallengesPage({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<AllChallengesPage> createState() => _AllChallengesPageState();
}

class _AllChallengesPageState extends State<AllChallengesPage> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Spending Swap',
    'Health + Money',
    'Goal-Driven',
    'Social & Community',
    'Seasonal'
  ];

  final List<Map<String, dynamic>> challenges = [
    {
      "id": "brew_at_home_week",
      "title": "Brew-at-Home Week",
      "description":
      "No takeaway coffee for 7 days — save £15 and build a mindful morning routine.",
      "duration_days": 7,
      "suggested_savings": 15,
      "category": "Health + Money",
      "type": "solo/community",
      "active": true,
      "badge": "Coffee Cutter",
      "streak_points": 10,
      "image": "https://images.unsplash.com/photo-1545665225-b23b99e4d45e?q=80&w=2070&auto=format&fit=crop"
    },
    {
      "id": "no_takeout_tuesdays",
      "title": "No Takeout Tuesdays",
      "description": "Cook at home once a week — save £10+ per meal.",
      "duration_days": 7,
      "suggested_savings": 12,
      "category": "Spending Swap",
      "type": "solo",
      "active": true,
      "badge": "Home Chef",
      "streak_points": 8,
      "image": "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=1981&auto=format&fit=crop"
    },
    {
      "id": "goal_streak_7days",
      "title": "Goal Streak: 7 Days of Saving",
      "description": "Add £1 daily to your savings for 7 days — build consistency.",
      "duration_days": 7,
      "suggested_savings": 7,
      "category": "Goal-Driven",
      "type": "solo",
      "active": true,
      "badge": "Saver Starter",
      "streak_points": 7,
      "image": "https://images.unsplash.com/photo-1563013544-824ae1b704d3?q=80&w=2070&auto=format&fit=crop"
    },
    {
      "id": "save_together_mode",
      "title": "Save Together Mode",
      "description": "Join friends to save £100 together for a trip or shared goal.",
      "duration_days": 14,
      "suggested_savings": 100,
      "category": "Social & Community",
      "type": "community",
      "active": true,
      "badge": "Team Saver",
      "streak_points": 15,
      "image": "https://images.unsplash.com/photo-1531545514256-b1400bc00f31?q=80&w=1974&auto=format&fit=crop"
    },
    {
      "id": "cancel_and_save",
      "title": "Cancel & Save",
      "description": "Pause one unused subscription this month — save £7–£15 instantly.",
      "duration_days": 30,
      "suggested_savings": 15,
      "category": "Spending Swap",
      "type": "solo",
      "active": true,
      "badge": "Subscription Slayer",
      "streak_points": 12,
      "image": "https://images.unsplash.com/photo-1579621970795-87f91d908377?q=80&w=1974&auto=format&fit=crop"
    },
    {
      "id": "no_spend_streak",
      "title": "3-Day No Spend Streak",
      "description": "Buy nothing but essentials for 3 days — test your willpower!",
      "duration_days": 3,
      "suggested_savings": 20,
      "category": "Spending Swap",
      "type": "solo",
      "active": true,
      "badge": "Willpower Warrior",
      "streak_points": 5,
      "image": "https://images.unsplash.com/photo-1599056030514-92a15a55d212?q=80&w=1974&auto=format&fit=crop"
    },
    {
      "id": "ditch_the_delivery",
      "title": "Ditch the Delivery",
      "description": "Bring lunch from home 3 days a week — save £18+ and skip 1,200+ calories.",
      "duration_days": 7,
      "suggested_savings": 18,
      "category": "Health + Money",
      "type": "solo",
      "active": true,
      "badge": "Lunchpack Leader",
      "streak_points": 9,
      "image": "https://images.unsplash.com/photo-1587594248383-a7a7a5f87b8d?q=80&w=1974&auto=format&fit=crop"
    },
    {
      "id": "fast_25_challenge",
      "title": "Fast £25 Challenge",
      "description": "Save £25 in one week by skipping small daily spends.",
      "duration_days": 7,
      "suggested_savings": 25,
      "category": "Goal-Driven",
      "type": "solo",
      "active": true,
      "badge": "Quick Saver",
      "streak_points": 10,
      "image": "https://images.unsplash.com/photo-1496065187959-7f07b8353c55?q=80&w=2070&auto=format&fit=crop"
    },
    {
      "id": "group_no_spend_weekend",
      "title": "Group No-Spend Weekend",
      "description": "Everyone buys only essentials from Fri–Sun — see who lasts longest!",
      "duration_days": 3,
      "suggested_savings": 15,
      "category": "Social & Community",
      "type": "community",
      "active": true,
      "badge": "Weekend Winner",
      "streak_points": 8,
      "image": "https://images.unsplash.com/photo-1559825481-7d453c9a0937?q=80&w=2070&auto=format&fit=crop"
    },
    {
      "id": "dry_january_wallet",
      "title": "Dry January Wallet",
      "description": "Skip alcohol for 2 weeks, save £30.",
      "duration_days": 14,
      "suggested_savings": 30,
      "category": "Seasonal",
      "type": "solo",
      "active": true,
      "badge": "Sober Saver",
      "streak_points": 15,
      "image": "https://images.unsplash.com/photo-1548839140-29a74da3aa8d?q=80&w=1974&auto=format&fit=crop"
    },
  ];

  List<Map<String, dynamic>> joinedChallenges = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredChallenges = selectedCategory == 'All'
        ? challenges
        : challenges.where((c) => c['category'] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Challenges'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredChallenges.length,
              itemBuilder: (context, index) {
                final challenge = filteredChallenges[index];
                bool isJoined = joinedChallenges.contains(challenge);
                final imageUrl = challenge['image'] as String?;

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 150,
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 48),
                            );
                          },
                        )
                      else
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, color: Colors.grey, size: 48),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge['title'] ?? 'No title',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(challenge['description'] ?? 'No description', style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Duration: ${challenge['duration_days'] ?? 0} days"),
                                Text("Save: £${challenge['suggested_savings'] ?? 0}"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            isJoined
                                ? ProgressSection(
                              challenge: challenge,
                              onReset: () {
                                setState(() {
                                  joinedChallenges.remove(challenge);
                                });
                              },
                            )
                                : ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  joinedChallenges.add(challenge);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              child: const Text("Join Challenge"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressSection extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onReset;

  const ProgressSection({super.key, required this.challenge, required this.onReset});

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection> {
  int daysCompleted = 0;
  double totalSaved = 0.0;

  void markDayComplete() {
    if (daysCompleted < (widget.challenge['duration_days'] ?? 0)) {
      setState(() {
        daysCompleted++;
        totalSaved += (widget.challenge['suggested_savings'] ?? 0) / (widget.challenge['duration_days'] ?? 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = widget.challenge['duration_days'] ?? 0;
    bool challengeDone = duration > 0 && daysCompleted >= duration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: duration > 0 ? daysCompleted / duration : 0.0,
          color: Colors.green,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text("Progress: $daysCompleted of $duration days",
            style: const TextStyle(fontSize: 14)),
        Text("Saved so far: £${totalSaved.toStringAsFixed(2)}"),
        const SizedBox(height: 8),
        if (!challengeDone)
          ElevatedButton.icon(
            onPressed: markDayComplete,
            icon: const Icon(Icons.check),
            label: const Text("Did you complete today?"),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("🎉 Challenge Completed!", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("🏅 ${widget.challenge['badge'] ?? ''}"),
            ],
          ),
        const SizedBox(height: 6),
        TextButton(onPressed: widget.onReset, child: const Text("Leave Challenge")),
      ],
    );
  }
}
