import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  // mock user
  final String _mockEmail = 'user@example.com';
  final String _mockPassword = '123456';

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email == _mockEmail && password == _mockPassword) {
      setState(() {
        _errorText = null;
      });
      Navigator.pushReplacementNamed(context, '/select-zone');
    } else {
      setState(() {
        _errorText = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
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
            ElevatedButton(
              onPressed: _login,
              child: const Text('เข้าสู่ระบบ'),
            ),
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
