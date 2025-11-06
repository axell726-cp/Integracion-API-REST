import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'product_form_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    // Cargar productos al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6366F1), // Indigo
              Color(0xFF8B5CF6), // Purple
              Color(0xFFA855F7), // Pink-purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header personalizado con gradiente
              _buildCustomHeader(),

              // Contenido principal
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
                      // Mostrar mensaje de error si existe
                      if (productProvider.errorMessage != null) {
                        return _buildErrorWidget(productProvider.errorMessage!);
                      }

                      // Mostrar indicador de carga
                      if (productProvider.isLoading &&
                          productProvider.productos.isEmpty) {
                        return _buildLoadingWidget();
                      }

                      // Mostrar mensaje si no hay productos
                      if (productProvider.productos.isEmpty) {
                        return _buildEmptyWidget();
                      }

                      // Mostrar lista de productos
                      return RefreshIndicator(
                        onRefresh: () => productProvider.loadProducts(),
                        color: const Color(0xFF6366F1),
                        child: Column(
                          children: [
                            // Indicador de carga superpuesto si está cargando
                            if (productProvider.isLoading)
                              const LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF6366F1),
                                ),
                              ),

                            // Lista de productos con padding
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: productProvider.productos.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      productProvider.productos[index];
                                  return _buildProductCard(product, index);
                                },
                              ),
                            ),
                          ],
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
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Header personalizado con gradiente
  Widget _buildCustomHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🛍️ Mis Productos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return Text(
                    '${provider.productos.length} productos disponibles',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => context.read<ProductProvider>().loadProducts(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget de carga moderno
  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Cargando productos...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // FAB moderno con gradiente
  Widget _buildFloatingActionButton() {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    final colors = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // Indigo to Purple
      [const Color(0xFF059669), const Color(0xFF10B981)], // Green gradient
      [const Color(0xFFDC2626), const Color(0xFFEF4444)], // Red gradient
      [const Color(0xFFD97706), const Color(0xFFF59E0B)], // Orange gradient
      [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)], // Purple gradient
    ];

    final colorPair = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 12,
        shadowColor: colorPair[0].withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorPair[0].withOpacity(0.1),
                colorPair[1].withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Avatar con gradiente
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colorPair,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: colorPair[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      product.nombre.isNotEmpty
                          ? product.nombre[0].toUpperCase()
                          : 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Contenido del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: colorPair),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${product.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Menú de acciones moderno
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, product),
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: Colors.blue[600],
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Editar',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red[600],
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Eliminar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Ups! Algo salió mal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProductProvider>().clearError();
                  context.read<ProductProvider>().loadProducts();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  '🔄 Reintentar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2_rounded,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '¡Tu tienda está vacía!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega tu primer producto y comienza a gestionar tu inventario',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _navigateToForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text(
                  'Crear mi primer producto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Product product) {
    switch (action) {
      case 'edit':
        _navigateToForm(product: product);
        break;
      case 'delete':
        _showDeleteConfirmation(product);
        break;
    }
  }

  void _navigateToForm({Product? product}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: product),
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${product.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final productProvider = context.read<ProductProvider>();
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              navigator.pop();
              final success = await productProvider.deleteProduct(product.id!);

              if (mounted) {
                if (success) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Producto eliminado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  final errorMessage = productProvider.errorMessage;
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error: $errorMessage'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
