import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'select_zone_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'กรุณากรอกอีเมลและรหัสผ่าน';
      });
      return;
    }
    try {
      // ส่ง POST ไป backend โดยใช้ key username
      final response = await http.post(
        Uri.parse('http://localhost:3001/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "$email", "password": "$password"}',
      );
      if (response.statusCode == 200) {
        setState(() {
          _errorText = null;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectZoneScreen(username: email),
          ),
        );
      } else {
        setState(() {
          _errorText = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'อีเมล'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(_errorText!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _login, child: const Text('เข้าสู่ระบบ')),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('สมัครสมาชิก'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
