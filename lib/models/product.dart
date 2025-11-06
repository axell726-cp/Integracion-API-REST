class Product {
  final int? id;
  final String nombre;
  final double precio;

  const Product({this.id, required this.nombre, required this.precio});

  // Convertir desde JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'nombre': nombre, 'precio': precio};
  }

  // Crear una copia con campos modificados
  Product copyWith({int? id, String? nombre, double? precio}) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, nombre: $nombre, precio: $precio}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.nombre == nombre &&
        other.precio == precio;
  }

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ precio.hashCode;
}
