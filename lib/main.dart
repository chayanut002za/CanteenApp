import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const CashlessCanteenApp());
}

class CashlessCanteenApp extends StatelessWidget {
  const CashlessCanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashless Canteen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Kanit',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // สีของแถบ title bar
          foregroundColor: Colors.white, // สีของตัวหนังสือและ icon
          elevation: 4,
          centerTitle: true,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // '/select-zone' และ '/profile' ถูกลบออก ให้ใช้ push แบบส่ง parameter แทน
      },
    );
  }
}
