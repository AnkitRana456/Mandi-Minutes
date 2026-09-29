import 'package:flutter/material.dart';

import 'package:mm_frontend/features/customer/presentation/screens/profile_screen.dart';
import 'products_screen.dart';
import 'shopkeeper_orders_screen.dart';

class ShopkeeperMainScreen extends StatefulWidget {
  const ShopkeeperMainScreen({super.key});

  @override
  State<ShopkeeperMainScreen> createState() => _ShopkeeperMainScreenState();
}

class _ShopkeeperMainScreenState extends State<ShopkeeperMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProductsScreen(),
    ShopkeeperOrdersScreen(),
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
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
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
