import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/producto.dart';

class ProductoScreen extends StatelessWidget {
  final Producto producto;

  const ProductoScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(producto.nombre.toUpperCase(), style: GoogleFonts.bebasNeue(letterSpacing: 4)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            producto.imagen != null
                ? Image.network(
                    'http://127.0.0.1:8000/api/imagen/${producto.imagen}',
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    headers: const {'Access-Control-Allow-Origin': '*'},
                    errorBuilder: (_, __, ___) => Container(
                      height: 400,
                      color: Colors.grey.shade200,
                    ),
                  )
                : Container(height: 400, color: Colors.grey.shade200),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría
                  if (producto.categoria != null)
                    Text(
                      producto.categoria!.toUpperCase(),
                      style: GoogleFonts.inter(fontSize: 11, letterSpacing: 3, color: Colors.black38),
                    ),
                  const SizedBox(height: 8),

                  // Nombre
                  Text(
                    producto.nombre.toUpperCase(),
                    style: GoogleFonts.bebasNeue(fontSize: 36, letterSpacing: 4),
                  ),

                  // Precio
                  Text(
                    '\$${producto.precio.toStringAsFixed(0)}',
                    style: GoogleFonts.bebasNeue(fontSize: 28, letterSpacing: 2, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  if (producto.descripcion != null)
                    Text(
                      producto.descripcion!,
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.8),
                    ),
                  const SizedBox(height: 24),

                  // Stock
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: producto.stockActual > 0 ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        producto.stockActual > 0
                            ? '${producto.stockActual} unidades disponibles'
                            : 'Agotado',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Botón
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: producto.stockActual > 0 ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Para comprar ingresa desde la web'),
                            backgroundColor: Colors.black,
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        disabledBackgroundColor: Colors.black26,
                      ),
                      child: Text(
                        producto.stockActual > 0 ? 'VER EN TIENDA' : 'AGOTADO',
                        style: GoogleFonts.inter(fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}