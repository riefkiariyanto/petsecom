import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:petsecom/Views/FirstPage.dart';
import 'package:petsecom/Views/ProfilePage.dart';
import 'package:petsecom/widgets/product/ProductSearch.dart';
import '../widgets/ListOrder/ListOrderPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List pages = [
    FirtsPage(),
    const ProductSearch(
      searchQuery: '',
    ),
    const ListOrder(),
    const ProfilePage(),
  ];
  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: pages[_selectedIndex],
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0), // Adjust the padding as needed
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.brown[300],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: GNav(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            gap: 4,
            tabBorderRadius: 15,
            activeColor: Colors.white,
            iconSize: 18,
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.brown.shade400,
            color: Colors.grey[800],
            tabs: [
              GButton(
                icon: LineIcons.home,
              ),
              GButton(
                icon: LineIcons.uber,
              ),
              GButton(
                icon: LineIcons.list,
              ),
              GButton(
                icon: LineIcons.user,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
