import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../utils/storage.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });

    try {
      final data = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (data['token'] != null) {
        await ApiService.saveToken(data['token']);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        setState(() { _error = data['message'] ?? 'Error al iniciar sesión'; });
      }
    } catch (e) {
      setState(() { _error = 'Error de conexión'; });
    }

    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'STATELESS',
                style: GoogleFonts.bebasNeue(
                  fontSize: 40,
                  letterSpacing: 8,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Iniciar Sesión',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black54,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 48),

              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.red.shade50,
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),