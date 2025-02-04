import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TipsAndTricksPage(),
    );
  }
}

class TipsAndTricksPage extends StatefulWidget {
  @override
  _TipsAndTricksPageState createState() => _TipsAndTricksPageState();
}

class _TipsAndTricksPageState extends State<TipsAndTricksPage> {
  String? selectedCategory = "All";
  TextEditingController _searchController = TextEditingController();
  List<TipCard> filteredTipsList = [];

  final List<String> categories = ["All", "Tire Maintenance", "Engine Issues", "Car Wash", "General"];

  // Dummy data for cards
  final tipsList = [
    TipCard(
        title: "How to change a tire",
        category: "Tire Maintenance",
        content: "assets/how_to_change_tire.png",
        description: "Follow these steps to safely change a flat tire."),
    TipCard(
        title: "How to fix a flat tire",
        category: "Tire Maintenance",
        content: "https://www.youtube.com/watch?v=example",
        description: "Watch the video to learn how to fix a flat tire."),
    TipCard(
        title: "How to check engine oil",
        category: "Engine Issues",
        content: "assets/engine_oil_check.png",
        description: "Learn how to check the engine oil level in your car."),
    TipCard(
        title: "Car wash essentials",
        category: "Car Wash",
        content: "assets/car_wash_tips.png",
        description: "The essentials of keeping your car clean and shiny."),
  ];

  @override
  void initState() {
    super.initState();
    filteredTipsList = tipsList; // Initialize with all tips
  }

  void _filterTips() {
    setState(() {
      filteredTipsList = tipsList
          .where((tip) => tip.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          tip.description.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _filterTips(),
                decoration: InputDecoration(
                  hintText: 'Search for an issue (e.g., flat tire, oil check)',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Category Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                icon: Icon(Icons.arrow_drop_down),
                isExpanded: true,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    filteredTipsList = tipsList
                        .where((tip) => selectedCategory == "All" || tip.category == selectedCategory)
                        .toList();
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Horizontal scrollable list for tips
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 250,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: filteredTipsList
                                    .where((tip) => selectedCategory == "All" || tip.category == category)
                                    .map((tip) {
                                  return GestureDetector(
                                    onTap: () => _navigateToTipDetailPage(tip),
                                    child: Card(
                                      color: Colors.white,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Icon(Icons.info, color: Colors.blueAccent, size: 30),
                                            SizedBox(height: 10),
                                            Image.asset(
                                              tip.content,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              tip.title,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              tip.description,
                                              style: TextStyle(fontSize: 12),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTipDetailPage(TipCard tip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TipDetailPage(tip: tip),
      ),
    );
  }
}

class TipDetailPage extends StatelessWidget {
  final TipCard tip;

  TipDetailPage({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _getTipContent(),
      ),
    );
  }

  Widget _getTipContent() {
    // Check if content is a YouTube URL or Image asset and display accordingly
    if (tip.content.contains("https://www.youtube.com")) {
      return YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(tip.content)!,
          flags: YoutubePlayerFlags(autoPlay: true, mute: false),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(tip.content),
          SizedBox(height: 10),
          Text(tip.description, style: TextStyle(fontSize: 16)),
        ],
      );
    }
  }
}

class TipCard {
  final String title;
  final String category;
  final String content;
  final String description;

  TipCard({
    required this.title,
    required this.category,
    required this.content,
    required this.description,
  });
}
