import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // 포스트 데이터 목록
  final List<Map<String, dynamic>> posts = [
    {
      'profileImage': 'assets/images/profile_default.png',
      'username': 'user1',
      'postImage': 'assets/images/post_ex_01.jpg',
      'likes': 120,
      'comments': 35,
      'description': 'Beautiful sunset at the beach',
      'date': '1 day ago',
    },
    {
      'profileImage': 'assets/images/profile_default.png',
      'username': 'user2',
      'postImage': 'assets/images/post_ex_02.jpg',
      'likes': 89,
      'comments': 21,
      'description': 'Mountain hiking adventure',
      'date': '2 days ago',
    },
    {
      'profileImage': 'assets/images/profile_default.png',
      'username': 'user3',
      'postImage': 'assets/images/post_ex_03.jpg',
      'likes': 204,
      'comments': 47,
      'description': 'Delicious homemade pasta',
      'date': '3 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPostHeader(posts[index]),
                  buildPostImage(posts[index]['postImage']),
                  buildPostFooter(posts[index]),
                  buildPostDescription(posts[index]),
                  buildPostDate(posts[index]['date']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 프로필 이미지, 닉네임, 팔로우 버튼
  Widget buildPostHeader(Map<String, dynamic> post) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(post['profileImage']),
      ),
      title: Text(post['username']),
      trailing: TextButton(
        onPressed: () {},
        child: Text(
          'Follow',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  // 게시물 이미지
  Widget buildPostImage(String postImage) {
    return Image.asset(
      postImage,
      fit: BoxFit.cover,
      height: 300,
      width: double.infinity,
    );
  }

  // 하트 수, 댓글 수, 저장 버튼
  Widget buildPostFooter(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 8),
              Text('${post['likes']} likes'),
              SizedBox(width: 16),
              Icon(Icons.comment),
              SizedBox(width: 8),
              Text('${post['comments']} comments'),
            ],
          ),
          Icon(Icons.bookmark_border),
        ],
      ),
    );
  }

  // 닉네임과 본문 텍스트
  Widget buildPostDescription(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${post['username']} ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: post['description'],
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // 작성 날짜
  Widget buildPostDate(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        date,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
