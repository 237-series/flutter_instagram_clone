import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'post_model.g.dart'; // Hive generator가 생성한 파일

@HiveType(typeId: 0) // HiveType 어노테이션 추가
class Post {
  @HiveField(0) // HiveField 어노테이션 추가
  final String profileImage;
  @HiveField(1) // HiveField 어노테이션 추가
  final String username;
  @HiveField(2) // HiveField 어노테이션 추가
  final String postImage;
  @HiveField(3) // HiveField 어노테이션 추가
  final int likes;
  @HiveField(4) // HiveField 어노테이션 추가
  final int comments;
  @HiveField(5) // HiveField 어노테이션 추가
  final String description;
  @HiveField(6) // HiveField 어노테이션 추가
  final String date;
  @HiveField(7) // HiveField 어노테이션 추가
  final String? postImageBase64;


  Post({
    required this.profileImage,
    required this.username,
    required this.postImage,
    required this.likes,
    required this.comments,
    required this.description,
    required this.date,
    this.postImageBase64,
  });
}