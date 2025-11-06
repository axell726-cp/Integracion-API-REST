import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    if (_isEditing) {
      _nombreController.text = widget.product!.nombre;
      _precioController.text = widget.product!.precio.toString();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header personalizado
              _buildCustomHeader(),

              // Formulario principal
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),

                              // Icono central
                              _buildProductIcon(),

                              const SizedBox(height: 32),

                              // Campo de nombre con diseño moderno
                              _buildNameField(productProvider),

                              const SizedBox(height: 20),

                              // Campo de precio con diseño moderno
                              _buildPriceField(productProvider),

                              const SizedBox(height: 32),

                              // Mostrar mensaje de error si existe
                              if (productProvider.errorMessage != null)
                                _buildErrorMessage(
                                  productProvider.errorMessage!,
                                ),

                              const SizedBox(height: 24),

                              // Botón de guardar con gradiente
                              _buildSaveButton(productProvider),

                              const SizedBox(height: 16),

                              // Botón de cancelar
                              _buildCancelButton(productProvider),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header personalizado para el formulario
  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _isEditing ? '✏️ Editar Producto' : '➕ Nuevo Producto',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Icono central del producto
  Widget _buildProductIcon() {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.inventory_rounded,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  // Campo de nombre con diseño moderno
  Widget _buildNameField(ProductProvider productProvider) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _nombreController,
        decoration: InputDecoration(
          labelText: 'Nombre del producto',
          hintText: 'Ej: Laptop, Mouse, Teclado...',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '⚠️ El nombre es obligatorio';
          }
          if (value.trim().length < 2) {
            return '⚠️ El nombre debe tener al menos 2 caracteres';
          }
          return null;
        },
        enabled: !productProvider.isLoading,
      ),
    );
  }

  // Campo de precio con diseño moderno
  Widget _buildPriceField(ProductProvider productProvider) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _precioController,
        decoration: InputDecoration(
          labelText: 'Precio del producto',
          hintText: '0.00',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF34D399)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.attach_money_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '⚠️ El precio es obligatorio';
          }

          final precio = double.tryParse(value.trim());
          if (precio == null) {
            return '⚠️ Ingresa un precio válido';
          }

          if (precio <= 0) {
            return '⚠️ El precio debe ser mayor a 0';
          }

          return null;
        },
        enabled: !productProvider.isLoading,
      ),
    );
  }

  // Mensaje de error con diseño moderno
  Widget _buildErrorMessage(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[200]!),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.error_outline_rounded, color: Colors.red[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botón de guardar con gradiente
  Widget _buildSaveButton(ProductProvider productProvider) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: productProvider.isLoading ? null : _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: productProvider.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isEditing ? Icons.check_rounded : Icons.add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isEditing ? 'Actualizar Producto' : 'Crear Producto',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Botón de cancelar moderno
  Widget _buildCancelButton(ProductProvider productProvider) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextButton(
        onPressed: productProvider.isLoading ? null : _cancel,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close_rounded, color: Colors.grey[600], size: 24),
            const SizedBox(width: 8),
            Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final productProvider = context.read<ProductProvider>();

    // Limpiar errores previos
    productProvider.clearError();

    final nombre = _nombreController.text.trim();
    final precio = double.parse(_precioController.text.trim());

    final product = Product(
      id: _isEditing ? widget.product!.id : null,
      nombre: nombre,
      precio: precio,
    );

    bool success;
    if (_isEditing) {
      success = await productProvider.updateProduct(product);
    } else {
      success = await productProvider.addProduct(product);
    }

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Producto actualizado exitosamente'
                  : 'Producto creado exitosamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Si hay error, se muestra en el Consumer automáticamente
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }
}
