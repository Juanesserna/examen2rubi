import 'package:flutter/material.dart';

// Modelo de Datos del Producto
class Product {
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageAsset; 
  final List<String> portions;
  final List<ExtraItem> extras;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageAsset,
    required this.portions,
    required this.extras,
  });
}

class ExtraItem {
  final String name;
  final double price;
  bool isSelected;

  ExtraItem({required this.name, required this.price, this.isSelected = false});
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  
  final List<Product> _products = [
    Product(
      name: 'Strawberry Cream Cake',
      category: 'PREMIUM BAKERY',
      price: 24.99,
      description:
          'A light and fluffy sponge cake layered with fresh organic strawberries and rich whipped cream. Perfect for any celebration or a sweet afternoon treat. Crafted with Madagascar vanilla and locally sourced dairy.',
      imageAsset: 'assets/images/pastel.jpeg',
      portions: ['4-6 Portions', '8-10 Portions'],
      extras: [
        ExtraItem(name: 'Extra Strawberries', price: 3.00),
        ExtraItem(name: 'Chocolate Drizzle', price: 2.00),
      ],
    ),
  ];

  final int _currentProductIndex = 0;
  int _selectedPortionIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = _products[_currentProductIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
           // Header
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
               child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
               IconButton(
                     icon: const Icon(Icons.arrow_back, color: Colors.black),
                     onPressed: () {
                     Navigator.pop(context); // Regresa a la pantalla anterior
                     },
                   ),
               const Text(
              'Product Detail',
               style: TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
               color: Colors.black,
               ),
               ),
                 IconButton(
                   icon: const Icon(Icons.share_outlined, color: Colors.black),
                   onPressed: () {},
                ),
              ],
            ),
          ),

            // Contenido Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen del Producto con animación
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        key: ValueKey<String>(product.imageAsset),
                        height: 320,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(product.imageAsset),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Título, Categoría, Precio y Corazón animado
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFED2C6D),
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botón Favorito con animación de escala
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 1.0,
                              end: _isFavorite ? 1.25 : 1.0,
                            ),
                            duration: const Duration(milliseconds: 200),
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isFavorite = !_isFavorite;
                                    });
                                  },
                                  icon: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: const Color(0xFFED2C6D),
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                    const SizedBox(height: 12),

                    // Descripción
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7C7C7C),
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Porciones
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Select Portions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: List.generate(product.portions.length, (index) {
                          bool isSelected = _selectedPortionIndex == index;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == 0 ? 10.0 : 0.0,
                                left: index > 0 ? 10.0 : 0.0,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFED2C6D)
                                        : const Color(0xFFE0E0E0),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  color: Colors.white,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setState(() {
                                      _selectedPortionIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0),
                                    child: Center(
                                      child: Text(
                                        product.portions[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? const Color(0xFFED2C6D)
                                              : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Extras
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Extra Toppings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: product.extras.length,
                      itemBuilder: (context, index) {
                        final extra = product.extras[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 6.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: extra.isSelected
                                    ? const Color(0xFFED2C6D).withValues(alpha: 0.5)
                                    : const Color(0xFFEEEEEE),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  extra.isSelected = !extra.isSelected;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 12.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: extra.isSelected,
                                        activeColor: const Color(0xFFED2C6D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7),
                                          side: const BorderSide(
                                            color: Color.fromARGB(255, 216, 216, 216),
                                            width: 1.2,
                                          ),
                                        ),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            extra.isSelected = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        extra.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '+\$${extra.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Barra inferior (Contador y Botón)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED2C6D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Added $_quantity ${product.name}(s) to cart!',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
    );
  }
}