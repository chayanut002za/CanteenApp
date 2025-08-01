import 'package:flutter/material.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import '../services/api_service.dart';
import 'dart:async';

class SelectZoneScreen extends StatefulWidget {
  final String username;
  const SelectZoneScreen({super.key, required this.username});

  @override
  _SelectZoneScreenState createState() => _SelectZoneScreenState();
}

class _SelectZoneScreenState extends State<SelectZoneScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String selectedZone = 'building9';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Map<String, String> zoneNames = {
    'building9': 'โรงอาหารอาคาร 9',
    'building16': 'ศูนย์อาหารตึก 16',
  };

  Map<String, IconData> zoneIcons = {
    'building9': Icons.restaurant,
    'building16': Icons.fastfood,
  };

  late Future<List<Map<String, dynamic>>> futureRestaurants;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    futureRestaurants = fetchRestaurants(selectedZone);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchRestaurants(String zone) async {
    return await fetchAllRestaurants(zone);
  }

  void onZoneSelected(String zoneKey) {
    setState(() {
      selectedZone = zoneKey;
      futureRestaurants = fetchRestaurants(selectedZone);
    });
    _animationController.reset();
    _animationController.forward();
  }

  Widget _buildHome() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '🍽️ Cashless Canteen',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'สวัสดีคุณ ${widget.username}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Zone Selection
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'เลือกโซนอาหาร',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: zoneButton('building9')),
                      const SizedBox(width: 15),
                      Expanded(child: zoneButton('building16')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Restaurant List Header
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(zoneIcons[selectedZone], color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'ร้านอาหารใน ${zoneNames[selectedZone]}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Restaurant List
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: futureRestaurants,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF667eea),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'กำลังโหลดข้อมูล...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Color(0xFFff6b6b),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'เกิดข้อผิดพลาด: ${snapshot.error}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_outlined,
                                size: 64,
                                color: Color(0xFFcccccc),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'ไม่มีร้านในโซนนี้',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final restaurants = snapshot.data!;
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = restaurants[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    // TODO: ไปหน้าเมนูร้าน
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Restaurant Image
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: const Color(0xFFf8f9fa),
                                          ),
                                          child:
                                              restaurant['image'] != null &&
                                                  restaurant['image']
                                                      .toString()
                                                      .isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    restaurant['image'],
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => const Icon(
                                                          Icons.restaurant,
                                                          size: 40,
                                                          color: Color(
                                                            0xFFcccccc,
                                                          ),
                                                        ),
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.restaurant,
                                                  size: 40,
                                                  color: Color(0xFFcccccc),
                                                ),
                                        ),

                                        const SizedBox(width: 16),

                                        // Restaurant Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                restaurant['name'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF333333),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: Color(0xFF666666),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'เปิด: ${restaurant['open']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF666666),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Menu Button
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF667eea),
                                                Color(0xFF764ba2),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Text(
                                            'ดูเมนู',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(),
          const OrderScreen(),
          ProfileScreen(username: widget.username),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF667eea),
          unselectedItemColor: const Color(0xFFcccccc),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'ออเดอร์',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }

  Widget zoneButton(String zoneKey) {
    final isSelected = zoneKey == selectedZone;
    return GestureDetector(
      onTap: () {
        onZoneSelected(zoneKey);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                )
              : null,
          color: isSelected ? null : const Color(0xFFf8f9fa),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFe9ecef), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              zoneIcons[zoneKey],
              color: isSelected ? Colors.white : const Color(0xFF666666),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              zoneNames[zoneKey]!,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF333333),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
