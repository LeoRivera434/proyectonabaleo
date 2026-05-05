
import 'package:cloud_firestore/cloud_firestore.dart';

class Perfume {
  final String? id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final int stock;

  Perfume({
    this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.stock,
  });

  factory Perfume.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Perfume(
      id: doc.id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'brand': brand,
      'description': description,
      'price': price,
      'stock': stock,
    };
  }
}
