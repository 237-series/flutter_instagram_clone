import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // 임시로 9개의 포스트 이미지 데이터를 사용 (3x3 그리드)
  final List<String> postImages = [
    'assets/images/post_ex_01.jpg',
    'assets/images/post_ex_02.jpg',
    'assets/images/post_ex_03.jpg',
    'assets/images/post_ex_01.jpg',
    'assets/images/post_ex_02.jpg',
    'assets/images/post_ex_03.jpg',
    'assets/images/post_ex_01.jpg',
    'assets/images/post_ex_02.jpg',
    'assets/images/post_ex_03.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('user1'),
        actions: [_buildMenuButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(),
            _buildTabBar(),
            Divider(),
            _buildPostGrid(),
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
          CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/images/profile1.jpg')),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                _buildStatsRow(),
                SizedBox(height: 12),
                _buildActionButtons(),
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
        _buildStatColumn('4', '게시물'),
        _buildStatColumn('0', '팔로워'),
        _buildStatColumn('1', '팔로잉'),
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

  // 프로필 편집, 프로필 공유 버튼
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('프로필 편집'),
        _buildActionButton('프로필 공유'),
      ],
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

  // 간이 탭바 (포스트 모아보기, 내가 태그된 사진)
  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: Icon(Icons.grid_on), onPressed: () {}),
        IconButton(icon: Icon(Icons.person_pin), onPressed: () {}),
      ],
    );
  }

  // 포스트 미리보기 그리드
  Widget _buildPostGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: postImages.length,
      itemBuilder: (context, index) {
        return Image.asset(postImages[index], fit: BoxFit.cover);
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
}
