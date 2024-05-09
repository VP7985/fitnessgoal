import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.blue,
    ),
  ];

  int _currentIndex = 0;

  void signUserOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (int _index) {
            setState(() {
              _currentIndex = _index;
            });
          },
          items: [
            SalomonBottomBarItem(
              selectedColor: Colors.red,
              unselectedColor: Colors.grey,
              icon: const Icon(Icons.home),
              title: const Text("Home"),
            ),
            SalomonBottomBarItem(
              selectedColor: Colors.green,
              unselectedColor: Colors.grey,
              icon: const Icon(Icons.add),
              title: const Text("Add"),
            ),
            SalomonBottomBarItem(
              selectedColor: Colors.blue,
              unselectedColor: Colors.grey,
              icon: const Icon(Icons.person_2),
              title: const Text("Profile"),
            )
          ]),
    );
  }
}
