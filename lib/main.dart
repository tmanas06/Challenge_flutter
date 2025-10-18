import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const ChallengeApp());

class ChallengeApp extends StatelessWidget {
  const ChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Community Challenges',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFBF0F4),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF91736B)),
        textTheme: GoogleFonts.interTextTheme(textTheme),
        useMaterial3: true,
      ),
      home: const CommunityPage(),
    );
  }
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _bottomNavIndex = 3;
  int _selectedTabIndex = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Community", style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChallengeTabs(
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            const SizedBox(height: 20),
            const CreateChallengeButton(),
            const SizedBox(height: 24),
            Text("My Challenges", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
            const SizedBox(height: 12),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MyChallengeCard(
                    title: "No Takeout Week",
                    description: "Ditch delivery for a week and save",
                    progress: 0.6,
                    saveText: "Save: £40",
                    trophyPoints: 20,
                    icon: Icons.restaurant_outlined,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: MyChallengeCard(
                    title: "Skip coffee",
                    description: "Brew at home and save",
                    progress: 0.8,
                    saveText: "Save: £20",
                    trophyPoints: 20,
                    icon: Icons.coffee_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text("Challenge Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
            const SizedBox(height: 16),
            CategorySection(
              title: "💸 Spending Swap Challenges",
              challenges: const [
                SmallChallengeCard(
                    title: "Skip the Uber",
                    description: "Walk or cycle 3 short trips this week — save £20 + stay active!"),
                SmallChallengeCard(
                    title: "3 Day No Spend Streak",
                    description: "Buy nothing but essentials for 3 days — track your willpower!"),
              ],
            ),
            const SizedBox(height: 24),
            CategorySection(
              title: "💰 Health + Money Challenges",
              challenges: const [
                SmallChallengeCard(
                    title: "Skip Sugary Snacks",
                    description: "No vending snacks for 5 days — save £6 and break the habit!"),
                SmallChallengeCard(
                    title: "Ditch the Delivery",
                    description: "Bring lunch from home 3 days — save £18+ and stay healthy!"),
              ],
            ),
            const SizedBox(height: 24),
            CategorySection(
              title: "🎯 Goal-Driven Challenges",
              challenges: const [
                SmallChallengeCard(
                    title: "Fast £25 Challenge",
                    description: "Save £25 in one week by skipping small daily spends."),
                SmallChallengeCard(
                    title: "Payday Split",
                    description: "Move 10% of your next income to your goal fund."),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: accent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.flag_outlined), label: "Goal"),
          BottomNavigationBarItem(icon: Icon(Icons.savings_outlined), label: "Save"),
          BottomNavigationBarItem(icon: Icon(Icons.groups_3_outlined), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: "Offer"),
        ],
      ),
    );
  }
}

// --- Helper Widgets for a Cleaner Build Method ---

class ChallengeTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const ChallengeTabs({super.key, required this.selectedIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTabButton("Leaderboard", 0, accent),
          _buildTabButton("Club Goals", 1, accent),
          _buildTabButton("Challenges", 2, accent),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index, Color accent) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? accent : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class CreateChallengeButton extends StatelessWidget {
  const CreateChallengeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.6)),
      ),
      child: Center(
        child: Text("Create a Challenge",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: theme.colorScheme.onSurface)),
      ),
    );
  }
}

class MyChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final String saveText;
  final int trophyPoints;
  final IconData icon;

  const MyChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.saveText,
    required this.trophyPoints,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface))),
            ],
          ),
          const SizedBox(height: 6),
          Text(description, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade300, color: accent),
          const SizedBox(height: 6),
          Text(saveText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.emoji_events_outlined, size: 16, color: accent),
              const SizedBox(width: 4),
              Text('$trophyPoints', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<SmallChallengeCard> challenges;

  const CategorySection({super.key, required this.title, required this.challenges});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: accent)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: challenges[0]),
            const SizedBox(width: 12),
            Expanded(child: challenges[1]),
          ],
        ),
      ],
    );
  }
}

class SmallChallengeCard extends StatelessWidget {
  final String title;
  final String description;

  const SmallChallengeCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 6),
          Text(description, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.groups_outlined, size: 16),
                const SizedBox(width: 4),
                Text("12", style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7)))
              ]),
              Row(children: [
                Icon(Icons.emoji_events_outlined, size: 16, color: accent),
                const SizedBox(width: 4),
                Text("20", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: accent))
              ]),
            ],
          )
        ],
      ),
    );
  }
}
