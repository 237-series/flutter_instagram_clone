import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? profileData; // nullable로 유지

  ProfileScreen({this.profileData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0: 포스트 모아보기, 1: 내가 태그된 사진
  late Map<String, dynamic> profileData; // 프로필 데이터

  final Map<String, dynamic> defaultProfileData = {
    'profileImage': 'assets/images/profile1.jpg',
    'username': 'user1',
    'posts': 4,
    'followers': 120,
    'following': 50,
    'postImages': [
      'assets/images/post_ex_01.jpg',
      'assets/images/post_ex_02.jpg',
      'assets/images/post_ex_03.jpg',
    ],
    'taggedImages': [
      'assets/images/tagged_ex_01.jpg',
    ],
  };

  @override
  void initState() {
    super.initState();
    profileData = widget.profileData ?? defaultProfileData; // 프로필 데이터 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profileData['username']),
        actions: [_buildMenuButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(),
            _buildTabBar(), // 탭바
            Divider(),
            _buildPostGrid(), // 탭에 따른 그리드 표시
          ],
        ),
      ),
    );
  }

  // 프로필 정보 위젯
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(profileData['profileImage']),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _buildStatsRow(),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton('프로필 편집'),
                    _buildActionButton('프로필 공유'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 게시물, 팔로워, 팔로잉 정보
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(profileData['posts'].toString(), '게시물'),
        _buildStatColumn(profileData['followers'].toString(), '팔로워'),
        _buildStatColumn(profileData['following'].toString(), '팔로잉'),
      ],
    );
  }

  // 각 카운트와 텍스트를 표시하는 위젯
  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label),
      ],
    );
  }

  // 간이 탭바 (포스트 모아보기, 내가 태그된 사진)
  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabIcon(Icons.grid_on, 0), // 포스트 모아보기
        _buildTabIcon(Icons.person_pin, 1), // 내가 태그된 사진
      ],
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon),
      color: _selectedTab == index ? Colors.blue : Colors.grey,
      onPressed: () {
        setState(() {
          _selectedTab = index; // 선택한 탭 변경
        });
      },
    );
  }

  // 포스트 미리보기 그리드 또는 내가 태그된 사진 그리드
  Widget _buildPostGrid() {
    final images = _selectedTab == 0 ? profileData['postImages'] : profileData['taggedImages'];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.asset(images[index], fit: BoxFit.cover);
      },
    );
  }

  // 햄버거 메뉴 버튼
  Widget _buildMenuButton() {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {},
    );
  }

  // 버튼을 생성하는 위젯
  Widget _buildActionButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label),
      style: ElevatedButton.styleFrom(minimumSize: Size(160, 36)),
    );
  }
}
