import 'package:attendance_project/navigator/bottom_nav.dart';
import 'package:attendance_project/share_preferences/share_preferences.dart';
import 'package:attendance_project/view/auth/login.dart';
import 'package:flutter/material.dart';

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  State<AuthCheckPage> createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await PreferenceHandler.getToken();
    if (mounted) {
      if (token != null && token.isNotEmpty) {
        // Jika token ada, langsung navigasi ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigator()),
        );
      } else {
        // Jika token tidak ada, navigasi ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading screen saat pengecekan
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
