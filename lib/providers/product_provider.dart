import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _productos = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Cargar todos los productos
  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      _productos = await ProductService.getProducts();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Agregar un nuevo producto
  Future<bool> addProduct(Product product) async {
    _setLoading(true);
    _clearError();

    try {
      final newProduct = await ProductService.createProduct(product);
      _productos.add(newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar un producto existente
  Future<bool> updateProduct(Product product) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedProduct = await ProductService.updateProduct(product);
      final index = _productos.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _productos[index] = updatedProduct;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar un producto
  Future<bool> deleteProduct(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await ProductService.deleteProduct(id);
      _productos.removeWhere((product) => product.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Obtener un producto por ID
  Product? getProductById(int id) {
    try {
      return _productos.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Métodos privados para manejar estado interno
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Limpiar errores manualmente
  void clearError() {
    _clearError();
    notifyListeners();
  }
}
