import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const ChallengeApp(),
  ),
);

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
    if (!mounted) return;
    final isDark = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Community Challenges',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFBF0F4),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF91736B)),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1c1c1e),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF91736B),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme.apply(bodyColor: Colors.white70, displayColor: Colors.white70)),
        useMaterial3: true,
      ),
      home: CommunityPage(toggleTheme: _toggleTheme),
    );
  }
}

class CommunityPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const CommunityPage({super.key, required this.toggleTheme});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int selectedIndex = 3; // Community tab active

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2c2c2e) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Community", style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e'), // sample profile photo
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildTabButton("Leaderboard", false, accent, isDark),
                  _buildTabButton("Club Goals", false, accent, isDark),
                  _buildTabButton("Challenges", true, accent, isDark),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(0.6)),
                color: cardColor,
              ),
              child: Center(
                child: Text(
                  "Create a Challenge",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: theme.colorScheme.onSurface),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("My Challenges",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMyChallengeCard(
                    theme,
                    title: "No Takeout Week",
                    description: "Ditch delivery for a week and save",
                    progress: 0.6,
                    saveText: "Save: £40",
                    trophyPoints: 20,
                    icon: Icons.restaurant_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMyChallengeCard(
                    theme,
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
            Text("Challenge Categories",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
            const SizedBox(height: 16),
            _buildCategoryTitle("💸 Spending Swap Challenges", accent),
            const SizedBox(height: 8),
            _buildChallengeRow(
              theme,
              leftTitle: "Skip the Uber",
              leftDesc: "Walk or cycle 3 short trips this week — save £20 + stay active!",
              rightTitle: "3 Day No Spend Streak",
              rightDesc: "Buy nothing but essentials for 3 days — track your willpower!",
            ),

            const SizedBox(height: 24),
            _buildCategoryTitle("💰 Health + Money Challenges", accent),
            const SizedBox(height: 8),
            _buildChallengeRow(
              theme,
              leftTitle: "Skip Sugary Snacks",
              leftDesc: "No vending snacks for 5 days — save £6 and break the habit!",
              rightTitle: "Ditch the Delivery",
              rightDesc: "Bring lunch from home 3 days — save £18+ and stay healthy!",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: accent,
        unselectedItemColor: Colors.grey,
        backgroundColor: isDark ? const Color(0xFF2c2c2e) : Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => selectedIndex = index),
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

  Widget _buildTabButton(String text, bool selected, Color accent, bool isDark) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: selected ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMyChallengeCard(ThemeData theme,
      {required String title,
      required String description,
      required double progress,
      required String saveText,
      required int trophyPoints,
      required IconData icon}) {
    final cardColor = theme.brightness == Brightness.dark ? const Color(0xFF2c2c2e) : Colors.white;
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
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
              child: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface)
              ),
            ),
          ]),
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

  Widget _buildCategoryTitle(String title, Color accent) {
    return Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: accent));
  }

  Widget _buildChallengeRow(ThemeData theme,
      {required String leftTitle,
      required String leftDesc,
      required String rightTitle,
      required String rightDesc}) {
    return Row(
      children: [
        Expanded(child: _buildSmallChallengeCard(theme, leftTitle, leftDesc)),
        const SizedBox(width: 12),
        Expanded(child: _buildSmallChallengeCard(theme, rightTitle, rightDesc)),
      ],
    );
  }

  Widget _buildSmallChallengeCard(ThemeData theme, String title, String desc) {
    final cardColor = theme.brightness == Brightness.dark ? const Color(0xFF2c2c2e) : Colors.white;
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 6),
          Text(desc, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(Icons.groups_outlined, size: 16), const SizedBox(width: 4), Text("12", style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7)))]),
              Row(children: [Icon(Icons.emoji_events_outlined, size: 16, color: accent), const SizedBox(width: 4), Text("20", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: accent))]),
            ],
          )
        ],
      ),
    );
  }
}
