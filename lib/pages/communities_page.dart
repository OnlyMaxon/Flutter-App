import 'package:flutter/material.dart';
import 'package:apps/services/user_storage.dart';
import 'chat_page.dart';
import 'package:apps/pages/registration/registration_data.dart';
import '../services/message_storage.dart';
import '../services/message.dart';
import 'search_users_page.dart';
import '../data/models/forum.dart';
import '../data/repositories/forum_repository.dart';
import 'forum_chat_page.dart';
import 'create_choice_page.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  // --- Чаты ---
  List<UserRegistrationData> chatUsers = [];
  Map<String, Message> lastMessages = {}; // email -> последнее сообщение
  UserRegistrationData? _currentUser;
  final MessageStorage _storage = MessageStorage();

  // --- Форумы ---
  final _forumsRepo = ForumRepository();
  List<Forum> _forums = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
    _loadForums();
  }

  Future<void> _loadChats() async {
    final users = await loadUsers();
    final current = await loadCurrentUser();
    final allMessages = await _storage.loadMessages();

    final Map<String, Message> latest = {};

    if (current != null) {
      for (final u in users) {
        if (u.email == current.email) continue;

        final msgs = allMessages.where((m) =>
        (m.sender == current.email && m.recipient == u.email) ||
            (m.sender == u.email && m.recipient == current.email));

        if (msgs.isNotEmpty) {
          final last = msgs.reduce((a, b) =>
          a.timestamp.isAfter(b.timestamp) ? a : b);
          latest[u.email] = last;
        }
      }
    }

    setState(() {
      _currentUser = current;
      chatUsers = users.where((u) => latest.containsKey(u.email)).toList();
      lastMessages = latest;
    });
  }

  Future<void> _loadForums() async {
    final list = await _forumsRepo.list();
    setState(() => _forums = list);
  }

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      title: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.chat_bubble_outline), text: "Связь"),
          Tab(icon: Icon(Icons.forum_outlined), text: "Форум"),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: "Поиск людей",
          icon: const Icon(Icons.person),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchUsersPage()),
            );
            _loadChats();
          },
        ),
      ],
    );
  }

  Widget _buildChatsTab() {
    if (chatUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("У вас пока нет диалогов"),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("Найти людей"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchUsersPage()),
                );
                _loadChats();
              },
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: chatUsers.length,
      itemBuilder: (context, index) {
        final user = chatUsers[index];
        final lastMsg = lastMessages[user.email];

        return ListTile(
          leading: CircleAvatar(
            child: Text(
              user.nickname?.isNotEmpty == true
                  ? user.nickname![0].toUpperCase()
                  : "?",
            ),
          ),
          title: Text(user.nickname ?? "Без имени"),
          subtitle: Text(
            lastMsg?.text ?? "Нет сообщений",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatPage(otherUser: user)),
            );
            _loadChats();
          },
        );
      },
    );
  }

  Widget _buildForumsTab() {
    if (_forums.isEmpty) {
      return const Center(child: Text("Форумов пока нет"));
    }

    return RefreshIndicator(
      onRefresh: _loadForums,
      child: ListView.separated(
        itemCount: _forums.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final f = _forums[i];
          return ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: Text(f.title),
            subtitle: Text(f.description ?? ''),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ForumChatPage(
                    forumId: f.id,
                    forumTitle: f.title,
                  ),
                ),
              );
              _loadForums();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildTopBar(),
        body: TabBarView(
          children: [
            _buildChatsTab(),
            _buildForumsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateChoicePage()),
            );
            _loadForums();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
