import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/pedido.dart';
import 'login_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  List<Pedido> _pedidos = [];
  bool _loading = true;
  bool _autenticado = false;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final token = await ApiService.getToken();
    if (token == null) {
      setState(() { _loading = false; _autenticado = false; });
      return;
    }

    try {
      final data = await ApiService.getMisPedidos();
      setState(() {
        _pedidos = data.map((p) => Pedido.fromJson(p)).toList();
        _loading = false;
        _autenticado = true;
      });
    } catch (e) {
      setState(() { _loading = false; _autenticado = false; });
    }
  }

  Color _colorEstado(String? estado) {
    switch (estado) {
      case 'entregado': return Colors.green;
      case 'en_curso': return Colors.blue;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('MIS PEDIDOS', style: GoogleFonts.bebasNeue(letterSpacing: 4)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : !_autenticado
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Inicia sesión para ver tus pedidos',
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
              : _pedidos.isEmpty
                  ? Center(
                      child: Text('No tienes pedidos aún',
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _pedidos.length,
                      itemBuilder: (context, index) {
                        final pedido = _pedidos[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PEDIDO #${pedido.id.toString().padLeft(6, '0')}',
                                    style: GoogleFonts.bebasNeue(fontSize: 18, letterSpacing: 2),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    color: _colorEstado(pedido.estadoEnvio),
                                    child: Text(
                                      (pedido.estadoEnvio ?? 'pendiente').toUpperCase(),
                                      style: GoogleFonts.inter(fontSize: 10, color: Colors.white, letterSpacing: 1),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${pedido.total.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${pedido.metodoPago.toUpperCase()} • ${pedido.fecha}',
                                style: GoogleFonts.inter(fontSize: 11, color: Colors.black38, letterSpacing: 1),
                              ),
                              if (pedido.estadoEnvio != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Estado: ${pedido.estadoEnvio!.replaceAll('_', ' ').toUpperCase()}',
                                  style: GoogleFonts.inter(fontSize: 11, color: Colors.black54),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}