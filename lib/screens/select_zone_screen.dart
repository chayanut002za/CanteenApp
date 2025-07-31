import 'package:flutter/material.dart';
import 'order_screen.dart';
import 'profile_screen.dart';

class SelectZoneScreen extends StatefulWidget {
  @override
  _SelectZoneScreenState createState() => _SelectZoneScreenState();
}

class _SelectZoneScreenState extends State<SelectZoneScreen> {
  int _selectedIndex = 0;
  String selectedZone = 'building9';

  final Map<String, String> zoneNames = {
    'building9': 'โรงอาหารอาคาร 9',
    'building16': 'ศูนย์อาหารตึก 16',
  };

  final Map<String, List<Map<String, String>>> zoneRestaurants = {
    'building9': [
      {'name': 'ข้าวมันไก่พี่โบ๊ต', 'open': '09:00 - 15:00'},
      {'name': 'ร้านก๋วยเตี๋ยวเรือ', 'open': '10:00 - 16:00'},
    ],
    'building16': [
      {'name': 'ชานมไข่มุก GG', 'open': '11:00 - 17:00'},
      {'name': 'โรตีแอนด์ชา', 'open': '12:00 - 18:00'},
    ],
  };

  Widget _buildHome() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              zoneButton('building9'),
              const SizedBox(width: 10),
              zoneButton('building16'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'ร้านอาหารใน ${zoneNames[selectedZone]}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: zoneRestaurants[selectedZone]!.length,
            itemBuilder: (context, index) {
              final restaurant = zoneRestaurants[selectedZone]![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(restaurant['name']!),
                  subtitle: Text('เปิด: ${restaurant['open']}'),
                  trailing: TextButton(
                    child: const Text('ดูเมนู'),
                    onPressed: () {
                      // TODO: ไปหน้าเมนูร้าน
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cashless Canteen'), centerTitle: true),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_buildHome(), const OrderScreen(), const ProfileScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget zoneButton(String zoneKey) {
    final isSelected = zoneKey == selectedZone;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedZone = zoneKey;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(zoneNames[zoneKey]!),
    );
  }
}
