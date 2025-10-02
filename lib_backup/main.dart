import 'package:flutter/material.dart';
import 'services/user_storage.dart';
import 'pages/auth_choice_page.dart';
import 'pages/explore_page.dart';
import 'pages/communities_page.dart';
import 'pages/profile_page.dart';
import 'pages/create_post_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initTestUser(); // 👈 создаём тестового пользователя, если его нет
  runApp(const MeetPlaceApp());
}

class MeetPlaceApp extends StatelessWidget {
  const MeetPlaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetPlace',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const StartupPage(),
    );
  }
}

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool _loading = true;
  bool _registered = false;

  @override
  void initState() {
    super.initState();
    _checkRegistration();
  }

  Future<void> _checkRegistration() async {
    final currentUser = await loadCurrentUser(); // 👈 берём активного юзера
    _registered = currentUser != null &&
        (currentUser.email?.isNotEmpty ?? false) &&
        currentUser.isLoggedIn;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _registered ? const MainPage() : const AuthChoicePage();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ExplorePage(),
    CommunitiesPage(),
    ProfilePage(),
    SizedBox(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    bool isHighlighted = false;

    return StatefulBuilder(
      builder: (context, setStateSB) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (label == "More") {
              // Подсветка кнопки
              setStateSB(() => isHighlighted = true);
              await Future.delayed(const Duration(milliseconds: 200));
              setStateSB(() => isHighlighted = false);

              // Позиция кнопки More
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              final Size size = renderBox.size;

              await showMenu(
                context: context,
                color: const Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                position: RelativeRect.fromLTRB(
                  offset.dx,
                  offset.dy - 133,
                  offset.dx + size.width,
                  0,
                ),
                items: [
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: const Text(
                      "About",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Future.delayed(Duration.zero, () {
                        showAboutDialog(
                          context: context,
                          applicationName: "MeetPlace",
                          applicationVersion: "5.0.0",
                          applicationLegalese: "© 2025 MeetPlace",
                        );
                      });
                    },
                  ),
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: const Text(
                      "Выйти",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      final currentUser = await loadCurrentUser();
                      if (currentUser != null) {
                        currentUser.isLoggedIn = false;
                        await saveCurrentUser(currentUser); // 👈 обновляем список
                      }
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const AuthChoicePage()),
                              (route) => false,
                        );
                      });
                    },
                  ),
                ],
              );
            } else {
              _onItemTapped(index);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isHighlighted
                    ? Colors.blueAccent.withOpacity(0.6)
                    : (isSelected ? Colors.blueAccent : Colors.grey),
                size: 24,
              ),
              Text(
                label,
                style: TextStyle(
                  color: isHighlighted
                      ? Colors.blueAccent.withOpacity(0.6)
                      : (isSelected ? Colors.blueAccent : Colors.grey),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        mini: true,
        child: const Icon(Icons.add, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1E1E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.explore, "Explore", 0),
              _buildNavItem(Icons.people, "Communities", 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.person, "Profile", 2),
              _buildNavItem(Icons.more_horiz, "More", 3),
            ],
          ),
        ),
      ),
    );
  }
}
