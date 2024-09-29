import 'dart:typed_data';
import 'dart:convert'; // Base64 인코딩 및 디코딩을 위해 추가

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_picker/file_picker.dart';
import '../models/post_model.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late Box<Post> postBox;
  Uint8List? _selectedImageBytes; // 선택된 이미지의 바이트 데이터
  String? _fileName; // 선택된 이미지의 파일 이름
  final _descriptionController = TextEditingController(); // 본문 작성용 컨트롤러
  bool _isUploadComplete = false; // 업로드 완료 상태를 추적하는 변수

  @override
  void initState() {
    super.initState();
    postBox = Hive.box<Post>('posts'); // Hive 박스 열기
  }

  // PC에서 파일 선택
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // 이미지 파일만 선택
      withData: true, // 이미지의 바이트 데이터를 함께 가져옴
    );

    if (result != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes; // 선택한 이미지의 바이트 데이터 저장
        _fileName = result.files.single.name; // 파일 이름 저장
      });
    }

    // 디버깅: 바이트 데이터 확인
      print('Selected Image Bytes Length: ${_selectedImageBytes?.length}');
    
  }

  // Hive에 포스트 저장
  Future<void> _savePost() async {
    if (_selectedImageBytes != null && _descriptionController.text.isNotEmpty) {
      // 새로운 포스트를 Hive에 저장

      // 바이트 데이터를 Base64 문자열로 인코딩
      String base64Image = base64Encode(_selectedImageBytes!);

      final newPost = Post(
        profileImage: 'assets/images/profile_default.png', // 임시 프로필 이미지
        username: 'user1', // 임시 사용자 이름
        likes: 0,
        comments: 0,
        description: _descriptionController.text,
        date: DateTime.now().toString(), // 현재 날짜 저장
        postImage: _fileName!, // 파일 이름 저장
        postImageBase64: base64Image, // Base64 이미지 데이터 저장
      );


      // 데이터 저장 시 확인
      //print('Saving Post with Image Bytes Length: ${newPost.base64Image.length}');

      postBox.add(newPost); // Hive 박스에 포스트 저장

      setState(() {
        _isUploadComplete = true; // 업로드 완료 상태를 true로 변경
      });
    } else {
      // 필수 항목을 채우지 않았을 경우 경고 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a description')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이미지 미리보기
            _selectedImageBytes == null
                ? Text('No image selected')
                : Image.memory(_selectedImageBytes!, height: 300, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 16),
            // 이미지 선택 버튼
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 16),
            // 본문 입력 필드
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Enter a description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // 업로드 버튼
            ElevatedButton(
              onPressed: (_isUploadComplete ) ? null : _savePost,
              child: (_isUploadComplete == false) ? Text('Upload Post') : Text('upload done.'),
            ),
            SizedBox(height: 16),
            // 업로드 완료 메시지
            _isUploadComplete
                ? Text(
                    'Complete!',
                    style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : Container(), // 업로드 완료 시에만 표시
          ],
        ),
      ),
    );
  }
}
