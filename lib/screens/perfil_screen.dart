import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? _usuario;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final token = await ApiService.getToken();
    if (token == null) {
      setState(() { _loading = false; });
      return;
    }

    try {
      final data = await ApiService.getMiPerfil();
      setState(() {
        _usuario = data['user'];
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  Future<void> _logout() async {
    await ApiService.removeToken();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('MI PERFIL', style: GoogleFonts.bebasNeue(letterSpacing: 4)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _usuario == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Inicia sesión para ver tu perfil',
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: Text('INICIAR SESIÓN', style: GoogleFonts.inter(letterSpacing: 2)),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              _usuario!['name'][0].toUpperCase(),
                              style: GoogleFonts.bebasNeue(fontSize: 40, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Nombre
                      Text('NOMBRE', style: GoogleFonts.inter(fontSize: 10, letterSpacing: 2, color: Colors.black38)),
                      const SizedBox(height: 4),
                      Text(_usuario!['name'], style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                      const Divider(height: 32),

                      // Email
                      Text('CORREO', style: GoogleFonts.inter(fontSize: 10, letterSpacing: 2, color: Colors.black38)),
                      const SizedBox(height: 4),
                      Text(_usuario!['email'], style: GoogleFonts.inter(fontSize: 16)),
                      const Divider(height: 32),

                      // Rol
                      Text('ROL', style: GoogleFonts.inter(fontSize: 10, letterSpacing: 2, color: Colors.black38)),
                      const SizedBox(height: 4),
                      Text(_usuario!['role'].toUpperCase(), style: GoogleFonts.inter(fontSize: 16)),
                      const Divider(height: 32),

                      const Spacer(),

                      // Cerrar sesión
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _logout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          child: Text('CERRAR SESIÓN', style: GoogleFonts.inter(fontSize: 12, letterSpacing: 3)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}