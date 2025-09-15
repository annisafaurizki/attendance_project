import 'package:attendance_project/navigator/flashy_tab_bar.dart';
import 'package:attendance_project/view/home/halaman_utama.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});
  static const String id = 'BottomNavigator';
  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _listWidget = const [FirstPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _listWidget.elementAt(_selectedIndex)),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(icon: Icon(Icons.home), title: Text('Dashboard')),
          FlashyTabBarItem(icon: Icon(Icons.event), title: Text('Event')),
        ],
      ),
    );
  }
}
