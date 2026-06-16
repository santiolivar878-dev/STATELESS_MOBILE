import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Obtener token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Guardar token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Eliminar token (logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Headers con autenticación
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Registro
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password, 'password_confirmation': password}),
    );
    return jsonDecode(response.body);
  }

  // Obtener productos
  static Future<List<dynamic>> getProductos() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/productos'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }

  // Obtener perfil del usuario
static Future<Map<String, dynamic>> getMiPerfil() async {
  final headers = await getHeaders();
  final response = await http.get(Uri.parse('$baseUrl/usuario'), headers: headers);
  return jsonDecode(response.body);
}

  // Obtener mis pedidos
  static Future<List<dynamic>> getMisPedidos() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/mis-pedidos'), headers: headers);
    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
}