import 'package:flutter/material.dart';

/// Modelo que representa un producto dentro del carrito de compras.
class CartItemModel {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final IconData fallbackIcon;
  final Color color;
  final String? imagePath; // ej: 'assets/images/croissant.png'
  final String? imageUrl;  // opcional: imagen de red
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.fallbackIcon,
    required this.color,
    this.imagePath,
    this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

/// Datos de ejemplo que replican los productos mostrados en el diseño.
List<CartItemModel> buildSampleCartItems() {
  return [
    CartItemModel(
      id: 'sourdough_bread',
      name: 'Sourdough Bread',
      subtitle: 'Artisanal, 500g',
      price: 8.50,
      fallbackIcon: Icons.bakery_dining_rounded,
      color: const Color(0xFFB98554),
      imagePath: 'assets/images/sourdough_bread.jpg',
      quantity: 1,
    ),
    CartItemModel(
      id: 'chocolate_cupcake',
      name: 'Chocolate Cupcake',
      subtitle: 'Double fudge core',
      price: 4.25,
      fallbackIcon: Icons.cake_rounded,
      color: const Color(0xFF6B4433),
      imagePath: 'assets/images/chocolate_cupcake.jpg',
      quantity: 2,
    ),
    CartItemModel(
      id: 'butter_croissant',
      name: 'Butter Croissant',
      subtitle: 'Flaky & buttery',
      price: 3.50,
      fallbackIcon: Icons.breakfast_dining_rounded,
      color: const Color(0xFFD8A657),
      imagePath: 'assets/images/butter_croissant.jpg',
      quantity: 1,
    ),
  ];
}
