import 'package:flutter/material.dart';
import 'package:flutter_app/feautres/profile/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    // HomePage(),
    // WarehousePage(),
    // ShopPage(),
    // CreditPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yene Stock',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sign in as: abebe (Admin)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.circle, color: Colors.green, size: 10),
                SizedBox(width: 5),
                Text(
                  'ONLINE',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Top Blue Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today Nov 22',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(Icons.check_circle, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTopItem('0.00', 'View Report'),
                      _buildTopItem('0', 'PT Credit'),
                      _buildTopItem('0', 'To be expired'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Search Bar ---
            TextField(
              decoration: InputDecoration(
                hintText: 'Search product',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.fullscreen),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // --- Low Stock Reminder ---
            _buildSectionCard(
              title: 'Low Stock Reminder',
              children: [
                _buildRowItem('Low in stock', '0 items'),
                const Divider(height: 1),
                _buildRowItem('Low in shop', '0 items'),
              ],
            ),
            const SizedBox(height: 16),

            // --- History ---
            _buildSectionCard(
              title: 'History',
              children: [
                _buildRowItem('Sales history', ''),
                const Divider(height: 1),
                _buildRowItem('General history', ''),
              ],
            ),
            const SizedBox(height: 16),

            // --- Bulk Actions ---
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(Icons.add, 'New\nBulk action'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(Icons.save, 'Saved\nBulk action'),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // --- Bottom Navigation + Sale Button ---
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       _buildBottomIcon(Icons.home, 'Home', true),
      //       _buildBottomIcon(Icons.warehouse, 'Warehouse', false),
      //       _buildBottomIcon(Icons.store, 'Shop', false),
      //       _buildBottomIcon(Icons.credit_card, 'Credit', false),
      //       _buildBottomIcon(Icons.person, 'Profile', false),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Sale'),
        icon: const Icon(Icons.point_of_sale),
        backgroundColor: Colors.blue[600],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // --- Helper Widgets ---
  Widget _buildTopItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRowItem(String left, String right) {
    return ListTile(
      title: Text(left),
      trailing: Text(
        right,
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {},
    );
  }

  Widget _buildActionCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[600]),
          const SizedBox(height: 8),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.blue[600] : Colors.grey),
        Text(
          label,
          style: TextStyle(
              color: active ? Colors.blue[600] : Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
