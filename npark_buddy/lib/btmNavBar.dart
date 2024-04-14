
import 'package:flutter/material.dart';
import 'package:npark_buddy/facilities.dart';
import 'profile.dart';
import 'home.dart';
import 'bookings.dart';

/// Flutter code sample for [BottomNavigationBar].

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatefulWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  State<BottomNavigationBarExampleApp> createState() =>
      _BottomNavigationBarExampleApp();
}

class _BottomNavigationBarExampleApp extends State<BottomNavigationBarExampleApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.black);
  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Bookings(),
    selectFacility(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBEA),
      appBar: AppBar(
        leading: null,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Image.asset(
                'assets/logo.png',
                height: 70,
                width: 70,
              ),
            ),
            const Text(
              'ParkBuddy',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2B512F),
        foregroundColor: Colors.white,
        toolbarHeight: 110,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  spreadRadius: -5,
                  blurRadius: 10,
                  offset: Offset(0,-1))
            ]
        ),
        child: BottomNavigationBar(
          items:  const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/home.png')),
              activeIcon: ImageIcon(AssetImage('assets/home_click.png')),
              label: 'Home',
              backgroundColor: Color(0xFCF9F9E8),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/booking.png')),
              activeIcon: ImageIcon(AssetImage('assets/book_click.png')),
              label: 'Bookings',
              backgroundColor: Color(0xFCF9F9E8),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/bbq.png')),
              activeIcon: ImageIcon(AssetImage('assets/bbq_click.png')),
              label: 'Facilities',
              backgroundColor: Color(0xFCF9F9E8),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/profile.png')),
              activeIcon: ImageIcon(AssetImage('assets/profile_click.png')),
              label: 'Profile',
              backgroundColor: Color(0xFCF9F9E8),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedIconTheme: IconThemeData(
              color: Colors.green[900],
          ),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500,color: Colors.black),
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}





