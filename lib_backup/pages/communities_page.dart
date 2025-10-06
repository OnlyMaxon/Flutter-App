import 'package:flutter/material.dart';
import 'package:apps/services/user_storage.dart';
import 'chat_page.dart';
import 'package:apps/pages/registration/registration_data.dart';
import 'forum_tab.dart';


class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  List<UserRegistrationData> chatUsers = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final users = await loadUsers();
    final current = await loadCurrentUser();
    setState(() {
      chatUsers = users.where((u) => u.email != current?.email).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            title: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat_bubble_outline), text: "Чаты"),
                Tab(icon: Icon(Icons.forum_outlined), text: "Форум"),
              ],
            ),
            centerTitle: true,
          ),
        ),
        body: TabBarView(
          children: [

            ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                final user = chatUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      user.nickname?.isNotEmpty == true
                          ? user.nickname![0].toUpperCase()
                          : "?",
                    ),
                  ),
                  title: Text(user.nickname ?? "Без имени"),
                  subtitle: const Text("Привет! Это тестовое сообщение 👋"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(otherUser: user),
                      ),
                    );
                  },
                );
              },
            ),


            const ForumTab(),
          ],
        ),


        floatingActionButton: FloatingActionButton(
          heroTag: "communitiesFab",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Нажата кнопка связи")),
            );
          },
          child: const Icon(Icons.hub),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: const SizedBox(height: 50),
        ),
      ),
    );
  }
}
