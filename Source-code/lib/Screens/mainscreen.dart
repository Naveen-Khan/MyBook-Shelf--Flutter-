import 'package:flutter/material.dart';
import 'package:flutter_application_3/Screens/seach.dart';
import 'homescreen.dart';
import 'library.dart';
import 'Statistic.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(), // Index 0
    CompletedBooksScreen(), // Index 1
    Search(), // Index 2
    StatisticsScreen(), // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 148, 253),
      body: _screens[currentIndex],

      //navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: const Color.fromARGB(255, 139, 137, 137),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_sharp),
            label: 'library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: 'Statistic',
          ),
        ],
      ),
    );
  }
}
