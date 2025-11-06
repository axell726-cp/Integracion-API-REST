import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static String get baseUrl {
    const String host = '10.0.2.2'; // Para emulador Android

    return 'http://$host:8080/api/productos';
  }

  // Obtener todos los productos
  static Future<List<Product>> getProducts() async {
    try {
      print('🌐 Intentando conectar a: $baseUrl');

      final response = await http
          .get(
            Uri.parse(baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error del servidor: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      throw Exception(
        'Error de conexión con el servidor:\n$e\n\n🔧 Verifica que:\n- Tu backend esté ejecutándose en puerto 8080\n- Uses la IP correcta para tu plataforma',
      );
    }
  }

  // Crear un nuevo producto
  static Future<Product> createProduct(Product product) async {
    try {
      print('🆕 Creando producto: ${product.toJson()}');

      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Error al crear producto: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error al crear: $e');
      throw Exception('Error al crear producto: $e');
    }
  }

  // Actualizar un producto existente
  static Future<Product> updateProduct(Product product) async {
    try {
      print('✏️ Actualizando producto ID ${product.id}: ${product.toJson()}');

      final response = await http
          .put(
            Uri.parse('$baseUrl/${product.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(product.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Error al actualizar producto: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error al actualizar: $e');
      throw Exception('Error al actualizar producto: $e');
    }
  }

  // Eliminar un producto
  static Future<void> deleteProduct(int id) async {
    try {
      print('🗑️ Eliminando producto ID: $id');

      final response = await http
          .delete(
            Uri.parse('$baseUrl/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
          'Error al eliminar producto: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error al eliminar: $e');
      throw Exception('Error al eliminar producto: $e');
    }
  }
}
