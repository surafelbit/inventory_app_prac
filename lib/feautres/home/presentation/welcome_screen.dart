import 'package:flutter/material.dart';
import 'package:flutter_app/feautres/shop/presentation/shop_screen.dart';
import 'home_screen.dart';
// import 'warehouse_page.dart';
// import 'shop_page.dart';
// import 'credit_page.dart';
import 'package:flutter_app/feautres/profile/presentation/profile_screen.dart';
import 'package:flutter_app/feautres/profile/presentation/admin_profile_screen.dart';
import 'package:flutter_app/feautres/warehouse/presentation/warehouse_page.dart';
import 'package:flutter_app/feautres/credit/presentation/credit_screen.dart';
import '../../../state/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user1 = ref.watch(authProvider).admin;
    final List<Widget> _pages = [
      HomeScreen(),
      WarehousePage(),
      ShopScreen(),
      CreditScreen(),
      user1!.role == "SHOP_OWNER" ? AdminProfileScreen() : ProfileScreen(),
    ];
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.warehouse), label: 'Warehouse'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: 'Credit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
