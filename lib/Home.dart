import 'package:flutter/material.dart';
import 'package:flutterproject/Screens/AddBook.dart';
import 'package:flutterproject/Screens/Homee.dart';
import 'package:flutterproject/Screens/PaypalPayment.dart';
import 'AppBar/GlobalAppBar.dart';
import 'BookSearchPage.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Homee(), // For the Commands tab
    AddBook(), // For the add Command tab
    BookSearchPage(), // For the Search tab
    PaypalPayment(), // For the Paypal tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 28),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment, size: 28),
            label: 'Payment',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }
}
