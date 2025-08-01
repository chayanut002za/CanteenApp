import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// อธิบาย: เปลี่ยนเป็น StatefulWidget เพื่อใช้ TextEditingController
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  // อธิบาย: ฟังก์ชันสำหรับสมัครสมาชิก
  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text('กรุณากรอกข้อมูลให้ครบ')),
      );
      return;
    }
    if (password != confirm) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }
    try {
      // อธิบาย: ส่ง POST ไป backend
      final response = await http.post(
        Uri.parse('http://localhost:3001/register'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "$email", "password": "$password"}',
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: Text('สมัครสมาชิกสำเร็จ')),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(content: Text('เกิดข้อผิดพลาด: ${response.body}')),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(content: Text('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สมัครสมาชิก')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // อธิบาย: TextField สำหรับอีเมล
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            SizedBox(height: 16),
            // อธิบาย: TextField สำหรับรหัสผ่าน
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            // อธิบาย: TextField สำหรับยืนยันรหัสผ่าน
            TextField(
              controller: confirmController,
              decoration: InputDecoration(labelText: 'ยืนยันรหัสผ่าน'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            // อธิบาย: ปุ่มสมัครสมาชิก
            ElevatedButton(onPressed: register, child: Text('สมัครสมาชิก')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('กลับไปหน้าเข้าสู่ระบบ'),
            ),
          ],
        ),
      ),
    );
  }
}
