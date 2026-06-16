class Pedido {
  final int id;
  final String tipoVenta;
  final String metodoPago;
  final double total;
  final String? estadoEnvio;
  final String fecha;

  Pedido({
    required this.id,
    required this.tipoVenta,
    required this.metodoPago,
    required this.total,
    this.estadoEnvio,
    required this.fecha,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      tipoVenta: json['tipo_venta'],
      metodoPago: json['metodo_pago'],
      total: double.parse(json['total'].toString()),
      estadoEnvio: json['envio']?['estado'],
      fecha: json['created_at'],
    );
  }
}