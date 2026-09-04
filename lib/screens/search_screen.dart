import 'package:flutter/material.dart';
import '../data/products_data.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final results = allProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3F2),
        elevation: 0,
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar productos...',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => query = value),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: results.isEmpty
            ? const Center(
                key: ValueKey('empty'),
                child: Text('Sin resultados'),
              )
            : GridView.builder(
                key: const ValueKey('grid'),
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final Product product = results[index];
                  return ProductCard(product: product);
                },
              ),
      ),
    );
  }
}
