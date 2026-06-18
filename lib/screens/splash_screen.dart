import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart'; // ← corregido
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    bool tokenValido = false;
    final token = await ApiService.getToken();

    if (token != null) {
      try {
        final perfil = await ApiService.getMiPerfil();
        tokenValido = perfil['id'] != null;
      } catch (_) {
        tokenValido = false;
      }
    }

    if (!tokenValido) {
      await ApiService.removeToken();
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => tokenValido ? const HomeScreen() : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'STATELESS',
          style: GoogleFonts.bebasNeue(
            fontSize: 48,
            color: Colors.white,
            letterSpacing: 12,
          ),
        ),
      ),
    );
  }
}