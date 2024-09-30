import 'dart:convert'; // Base64 디코딩을 위해 추가
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/post_model.dart'; // Post 모델 추가


class PostCardDetail extends StatefulWidget {
  final Post post; // 전달받은 Post 객체

  PostCardDetail({required this.post}); // 생성자에서 post 객체를 받아옴

  @override
  _PostCardDetailState createState() => _PostCardDetailState();
}

class _PostCardDetailState extends State<PostCardDetail> {
  late Uint8List? postImageBytes; // 바이트로 변환한 이미지 데이터

  @override
  void initState() {
    super.initState();

    // Base64로 저장된 이미지를 바이트 데이터로 변환
    if (widget.post.postImageBase64 != null) {
      postImageBytes = base64Decode(widget.post.postImageBase64!);
    } else {
      postImageBytes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 변경된 코드: 포스트 데이터를 Hive에서 가져온 데이터로 대체
              buildPostHeader({
                'profileImage': widget.post.profileImage,
                'username': widget.post.username,
              }),
              buildPostImage(widget.post),
              buildPostFooter({
                'likes': widget.post.likes,
                'comments': widget.post.comments,
              }),
              buildPostDescription({
                'username': widget.post.username,
                'description': widget.post.description,
              }),
              buildPostDate(widget.post.date),
            ],
          ),
        ),
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
