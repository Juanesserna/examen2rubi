import 'package:flutter/material.dart';
import 'components/product_detail.dart'; // <-- Ruta correcta según tu estructura

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductDetailScreen(), // <-- Llama a tu pantalla de detalles
    );
  }
}