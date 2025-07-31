import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('โปรไฟล์ผู้ใช้')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            const Text('ชื่อผู้ใช้: user@example.com', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const Text('สถานะ: สมาชิกทั่วไป', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('ออกจากระบบ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                // กลับไปหน้า login และล้าง navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
