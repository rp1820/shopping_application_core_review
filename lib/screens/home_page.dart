import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_application_qstp/screens/cart_page.dart';
import 'package:shopping_application_qstp/screens/search_page.dart';
import 'package:shopping_application_qstp/tabs/favourites_tab.dart';
import 'package:shopping_application_qstp/tabs/home_tab.dart';
import 'package:shopping_application_qstp/tabs/profile_tab.dart';
import 'package:shopping_application_qstp/tabs/search_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeTab(),
    // Center(
    //   child: Text('Cart'),
    // ),
    SearchTab(),
    SavedTab(),
    ProfileTab()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.star_rounded),
              icon: Icon(Icons.star_border_rounded),
              label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
