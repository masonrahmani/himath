import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../screens.dart';

class MyDashBoard extends StatefulWidget {
  final String uid;
  const MyDashBoard({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(
        uid: widget.uid,
      ),
      BookMarkScreen(
        uid: widget.uid,
      ),
      Profile(uid: widget.uid),
    ];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.2),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black26,
        unselectedItemColor: Colors.black12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
