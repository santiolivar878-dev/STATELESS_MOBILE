import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/producto.dart';
import 'producto_screen.dart';
import 'pedidos_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Producto> _productos = [];
  bool _loading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final data = await ApiService.getProductos();
      print('✅ Productos recibidos: ${data.length}');
      print('📦 Data: $data');
      setState(() {
        _productos = data.map((p) => Producto.fromJson(p)).toList();
        _loading = false;
      });
    } catch (e) {
      print('❌ ERROR cargando productos: $e');
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('STATELESS', style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 6)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _buildCatalogo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PedidosScreen()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilScreen()));
          } else {
            setState(() { _selectedIndex = index; });
          }
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildCatalogo() {
    return RefreshIndicator(
      onRefresh: _cargarProductos,
      color: Colors.black,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _productos.length,
        itemBuilder: (context, index) {
          final producto = _productos[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductoScreen(producto: producto)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: producto.imagen != null
                      ? Image.network(
                          'http://127.0.0.1:8000/api/imagen/${producto.imagen}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          headers: const {'Access-Control-Allow-Origin': '*'},
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200),
                        )
                      : Container(color: Colors.grey.shade200),
                ),
                const SizedBox(height: 8),
                Text(
                  producto.nombre.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${producto.precio.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}