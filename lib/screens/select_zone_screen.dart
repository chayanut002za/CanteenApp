import 'package:flutter/material.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import '../services/api_service.dart'; // ต้องมีไฟล์นี้พร้อมฟังก์ชัน fetchAllRestaurants()
import 'dart:async';

class SelectZoneScreen extends StatefulWidget {
  final String username;
  const SelectZoneScreen({super.key, required this.username});

  @override
  _SelectZoneScreenState createState() => _SelectZoneScreenState();
}

class _SelectZoneScreenState extends State<SelectZoneScreen> {
  int _selectedIndex = 0;
  String selectedZone = 'building9';

  Map<String, String> zoneNames = {
    'building9': 'โรงอาหารอาคาร 9',
    'building16': 'ศูนย์อาหารตึก 16',
  };

  late Future<List<Map<String, dynamic>>> futureRestaurants;

  @override
  void initState() {
    super.initState();
    futureRestaurants = fetchRestaurants(selectedZone);
  }

  Future<List<Map<String, dynamic>>> fetchRestaurants(String zone) async {
    // ดึงข้อมูลจาก backend เฉพาะ zone ที่เลือก
    return await fetchAllRestaurants(zone);
  }

  void onZoneSelected(String zoneKey) {
    setState(() {
      selectedZone = zoneKey;
      futureRestaurants = fetchRestaurants(selectedZone);
    });
  }

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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureRestaurants,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('ไม่มีร้านในโซนนี้'));
              }

              final restaurants = snapshot.data!;
              return ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading:
                            restaurant['image'] != null &&
                                restaurant['image'].toString().isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  restaurant['image'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 40),
                                ),
                              )
                            : const Icon(Icons.restaurant, size: 50),
                        title: Text(
                          restaurant['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'เปิด: ${restaurant['open']} ',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: TextButton(
                          child: const Text('ดูเมนู'),
                          onPressed: () {
                            // TODO: ไปหน้าเมนูร้าน
                          },
                        ),
                      ),
                    ),
                  );
                },
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
        children: [
          _buildHome(),
          const OrderScreen(),
          ProfileScreen(username: widget.username),
        ],
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
        onZoneSelected(zoneKey);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(zoneNames[zoneKey]!),
    );
  }
}
