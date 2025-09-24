import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        "user": "Maxon",
        "country": "Azerbaijan",
        "text": "Где купить магнитные наклейки ?",
        "tags": "#taxi@Vistula",
        "button": "View"
      },
      {
        "user": "Paybros",
        "country": "",
        "title": "Title",
        "date": "30 June",
        "text":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
        "tags": "#taxi#Poland@Vistula",
        "button": "Subscribe"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text("#figma@Rufat01", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text(post["user"]![0]),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post["user"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          if (post["country"]!.isNotEmpty)
                            Text(post["country"]!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (post.containsKey("title"))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          color: Colors.blueAccent.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(post["title"]!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(post["date"]!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(post["text"]!),
                      ],
                    )
                  else
                    Text(post["text"]!),
                  const SizedBox(height: 8),
                  Text(post["tags"]!,
                      style: const TextStyle(color: Colors.blueAccent)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                    ),
                    child: Text(post["button"]!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
