import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
//import 'screens/explore_screen.dart';
//import 'screens/upload_screen.dart';
import 'screens/profile_screen.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/post_model.dart';

void main() async { // async 추가
  await Hive.initFlutter(); // await 추가
  Hive.registerAdapter(PostAdapter()); // PostAdapter 등록  
  await Hive.openBox<Post>('posts'); // await 추가

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 각 탭에 연결될 화면 리스트
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HomeScreen(), //ExploreScreen(),
    HomeScreen(), //UploadScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,   // 선택된 아이템의 색상
        unselectedItemColor: Colors.grey,  // 선택되지 않은 아이템의 색상
        onTap: _onItemTapped,              // 탭 클릭 시 호출
      ),
    );
  }
}
