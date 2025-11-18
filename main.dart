import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MonsterApp());
}

class MonsterApp extends StatelessWidget {
  const MonsterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monster Collection',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xff0d0d0f)),
      home: const MainMenu(),
    );
  }
}

/* ===========================
   GLOBAL FAVORITE MANAGER
   =========================== */
class FavoriteManager {
  static final List<Monster> favorites = [];
}

/* ===========================
   DATA MODEL
   =========================== */
class Monster {
  final String name;
  final String image;
  final String description;
  final String type;

  Monster(this.name, this.image, this.description, this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Monster &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image;

  @override
  int get hashCode => name.hashCode ^ image.hashCode;
}

/* ===========================
   MAIN MENU 
   =========================== */
class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int selectedIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return MonsterHomePage(onFavoritesChanged: () => setState(() {}));
      case 1:
        return FavoritePage(onFavoritesChanged: () => setState(() {}));
      case 2:
        return const NotificationPage();
      case 3:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _buildScreen(selectedIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
              boxShadow: [
                BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 20, spreadRadius: 3),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.redAccent,
              unselectedItemColor: Colors.white54,
              currentIndex: selectedIndex,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 11,
              unselectedFontSize: 10,
              onTap: (i) => setState(() => selectedIndex = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notif"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===========================
   HOME PAGE 
   =========================== */
class MonsterHomePage extends StatefulWidget {
  final VoidCallback onFavoritesChanged;
  const MonsterHomePage({super.key, required this.onFavoritesChanged});

  @override
  State<MonsterHomePage> createState() => _MonsterHomePageState();
}

class _MonsterHomePageState extends State<MonsterHomePage> {
  final TextEditingController search = TextEditingController();

  final List<Monster> monsters = [
    Monster("Medusa", "assets/images/medusa.png",
        "Makhluk dengan rambut ular yang bisa mengubah manusia menjadi batu.", "Mythology"),
    Monster("Fenrir", "assets/images/fenrir.webp",
        "Serigala raksasa dalam mitologi Nordik yang diramalkan membunuh Odin.", "Beast"),
    Monster("Jorogumo", "assets/images/Jorogumo.png",
        "Wanita laba-laba yang menggoda pria lalu memakannya.", "Spirit"),
    Monster("Anubis", "assets/images/anubis.jpg",
        "Dewa berkepala serigala penjaga dunia kematian Mesir.", "Demon"),
    Monster("Minotaur", "assets/images/minotaur.webp",
        "Monster berkepala banteng yang tinggal di Labirin Kreta.", "Beast"),
  ];

  String selectedCategory = "All";
  final List<String> categories = ["All", "Mythology", "Demon", "Spirit", "Beast"];

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Monster> displayed = monsters.where((m) {
      final q = search.text.trim().toLowerCase();
      final matchSearch = q.isEmpty ? true : m.name.toLowerCase().contains(q);
      final matchCategory = selectedCategory == "All" || m.type == selectedCategory;
      return matchSearch && matchCategory;
    }).toList();

    return Stack(
      children: [
        Container(color: const Color(0xff0d0d0f)),

        // === BANNER
        Positioned(
          top: MediaQuery.of(context).padding.top + 16, 
          left: 16,
          right: 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/banner.jpg",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(child: Icon(Icons.image, color: Colors.white54, size: 50)),
                    );
                  },
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.25),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                // WELCOME TEXT
                const Positioned(
                  bottom: 16,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome,", style: TextStyle(color: Colors.white60, fontSize: 15)),
                      Text(
                        "Ari",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          shadows: [Shadow(color: Colors.redAccent, blurRadius: 6)],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // MAIN CONTENT
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16 + 180 + 16,
          ),
          child: Column(
            children: [
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)],
                      ),
                      child: TextField(
                        controller: search,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Cari monster...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // CATEGORY CHIPS
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final selected = categories[i] == selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = categories[i]),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: selected ? Colors.redAccent.withOpacity(0.9) : Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: selected
                              ? [BoxShadow(color: Colors.red.withOpacity(0.6), blurRadius: 18, spreadRadius: 4)]
                              : [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
                        ),
                        child: Text(
                          categories[i],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // GRID
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayed.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.88,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, i) => glassGlowCard(displayed[i]),
                ),
              ),
            ],
          ),
        ),

        // FAB
        Positioned(
          bottom: 90,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.7), blurRadius: 30, spreadRadius: 6)],
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Tambah Monster (coming soon)')));
              },
              child: const Icon(Icons.add, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  // === CARD & POPUP ===
  Widget glassGlowCard(Monster m) {
    final bool isFav = FavoriteManager.favorites.contains(m);

    return GestureDetector(
      onTap: () => showGlassPopup(m),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          m.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.white.withOpacity(0.1),
                              child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 36),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.white70,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Text(
                    m.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showGlassPopup(Monster m) {
    bool isFav = FavoriteManager.favorites.contains(m);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 25, spreadRadius: 5)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(m.image, height: 200, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                setStateDialog(() {
                                  if (isFav) {
                                    FavoriteManager.favorites.remove(m);
                                    isFav = false;
                                  } else {
                                    FavoriteManager.favorites.add(m);
                                    isFav = true;
                                  }
                                });
                                widget.onFavoritesChanged();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                                child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.redAccent : Colors.white, size: 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(m.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(m.description, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5), textAlign: TextAlign.justify),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}


/* ===========================
   FAVORITE PAGE
   =========================== */
class FavoritePage extends StatefulWidget {
  final VoidCallback onFavoritesChanged;
  const FavoritePage({super.key, required this.onFavoritesChanged});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favs = FavoriteManager.favorites;

    return Container(
      color: const Color(0xff0d0d0f),
      padding: const EdgeInsets.only(top: 60),
      child: favs.isEmpty
          ? const Center(child: Text("Belum ada favorite", style: TextStyle(color: Colors.white54, fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favs.length,
              itemBuilder: (context, i) {
                final m = favs[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15, spreadRadius: 3)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(m.image, width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                                Text(m.type, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 26),
                            onPressed: () {
                              setState(() => FavoriteManager.favorites.remove(m));
                              widget.onFavoritesChanged();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* ===========================
   NOTIFICATION PAGE
   =========================== */
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff0d0d0f),
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_off, color: Colors.white30, size: 80),
            const SizedBox(height: 16),
            const Text("Belum ada notifikasi", style: TextStyle(color: Colors.white54, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

/* ===========================
   PROFILE PAGE
   =========================== */
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff0d0d0f),
      padding: const EdgeInsets.only(top: 60),
      child: const Center(
        child: Text("Profile Page\n(Coming Soon)", style: TextStyle(color: Colors.white70, fontSize: 22), textAlign: TextAlign.center),
      ),
    );
  }
}
