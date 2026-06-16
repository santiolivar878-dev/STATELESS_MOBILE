class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String? imagen;
  final int stockActual;
  final String estado;
  final String? categoria;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.imagen,
    required this.stockActual,
    required this.estado,
    this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: double.parse(json['precio'].toString()),
      imagen: json['imagen'],
      stockActual: json['stock_actual'] ?? 0,
      estado: json['estado'] ?? 'activo',
      categoria: json['categoria']?['nombre'],
    );
  }
}