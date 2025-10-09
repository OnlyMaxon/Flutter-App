import 'package:flutter/material.dart';
import 'create_forum_page.dart';
import 'create_post_page.dart';

class CreateChoicePage extends StatelessWidget {
  const CreateChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: const Text("Что вы хотите создать?"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _buildPoster(
                context,
                title: "Create a Forum",
                description: "Сообщество, где люди делятся интересами",
                assetPath: "assets/illustrations/forum_choice.png",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateForumPage()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildPoster(
                context,
                title: "Create a Post",
                description: "Поделитесь информацией с людьми по всему миру",
                assetPath: "assets/illustrations/post_choice.png",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostPage()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoster(
      BuildContext context, {
        required String title,
        required String description,
        required String assetPath,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
