import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert'; // Base64 디코딩을 위해 추가

import 'package:hive/hive.dart';  
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';

//class HomeScreen extends StatelessWidget {


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Post> postBox;

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
  void initState() {
    super.initState();
    // 변경된 코드: Hive의 "post" 박스 열기
    postBox = Hive.box<Post>('posts');

    // 만약 박스에 데이터가 없다면 샘플 데이터를 저장
    if (postBox.isEmpty) {
      _addSamplePosts();
    }
  }


  // 변경된 코드: 샘플 데이터를 Hive에 저장하는 함수
  void _addSamplePosts() {
    for (var post in posts) {
      final newPost = Post(
        profileImage: post['profileImage'],
        username: post['username'],
        postImage: post['postImage'],
        likes: post['likes'],
        comments: post['comments'],
        description: post['description'],
        date: post['date'],
      );
      postBox.add(newPost);  // 각 포스트를 Hive에 저장
    }
    setState(() {});  // 상태 갱신하여 화면에 반영
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      // 변경된 코드: Hive 데이터를 사용하기 위해 ValueListenableBuilder 추가
      body: ValueListenableBuilder(
        valueListenable: postBox.listenable(),
        builder: (context, Box<Post> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Post post = box.getAt(index)!;  // Hive 박스에서 포스트 불러오기
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 변경된 코드: 포스트 데이터를 Hive에서 가져온 데이터로 대체
                      buildPostHeader({
                        'profileImage': post.profileImage,
                        'username': post.username,
                      }),
                      buildPostImage(post),
                      buildPostFooter({
                        'likes': post.likes,
                        'comments': post.comments,
                      }),
                      buildPostDescription({
                        'username': post.username,
                        'description': post.description,
                      }),
                      buildPostDate(post.date),
                    ],
                  ),
                ),
              );
            },
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
  Widget buildPostImage(Post post) {
    String postImage = post.postImage;
    
    if (post.postImageBase64 != null) {
      var postImageBase64 = post.postImageBase64!;
      // Base64 문자열을 바이트 데이터로 변환
      Uint8List postImageBytes = base64Decode(postImageBase64);
      //postImage = 'data:image/jpeg;base64,${postImageBytes}';
      return Image.memory(
        postImageBytes,
        fit: BoxFit.cover,
        height: 300,
        width: double.infinity,
      );
    }

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
