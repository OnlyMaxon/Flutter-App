import 'package:flutter/material.dart';

class CommunitiesPage extends StatelessWidget {
  const CommunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Communities"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat_bubble_outline), text: "Чаты"),
              Tab(icon: Icon(Icons.forum_outlined), text: "Форум"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ChatsTab(),
            ForumTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Действие при нажатии (например, создать чат/сообщество или открыть поиск)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Нажата кнопка связи")),
            );
          },
          child: const Icon(Icons.hub), // 👈 иконка "связь"
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: SizedBox(height: 50), // фон под FAB
        ),
      ),
    );
  }
}

// 👇 Вкладка "Чаты"
class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text("Maxon, Azerbaijani"),
          subtitle: Text("Где купить магнитные наклейки?"),
          trailing: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue,
            child: Text("6", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
        Divider(),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text("Другой чат"),
          subtitle: Text("Последнее сообщение..."),
        ),
      ],
    );
  }
}

// 👇 Вкладка "Форум"
class ForumTab extends StatelessWidget {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Здесь будут посты и обсуждения сообществ",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
