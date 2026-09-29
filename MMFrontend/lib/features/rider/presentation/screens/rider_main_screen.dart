import 'package:flutter/material.dart';

import 'package:mm_frontend/features/customer/presentation/screens/profile_screen.dart';
import 'rider_orders_screen.dart';

class RiderMainScreen extends StatefulWidget {
  const RiderMainScreen({super.key});

  @override
  State<RiderMainScreen> createState() => _RiderMainScreenState();
}

class _RiderMainScreenState extends State<RiderMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RiderOrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining_outlined),
            activeIcon: Icon(Icons.delivery_dining),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
