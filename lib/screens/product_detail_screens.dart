import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../widgets/product_image.dart';

/// Pantalla de detalle a la que se llega al tocar la imagen de un producto
/// en el carrito. Recibe la imagen animada vía [Hero] y el resto del
/// contenido aparece con un Fade In (animación implícita con
/// [AnimatedOpacity]).
class ProductDetailScreen extends StatefulWidget {
  final CartItemModel item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Pequeño retraso para que el fade-in se note después
    // de que el Hero termine su vuelo.
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
              ),
            ),
            Center(
              child: Hero(
                tag: 'product-image-${item.id}',
                child: ProductImage(item: item, size: 220, borderRadius: 32),
              ),
            ),
            const SizedBox(height: 28),
            // Fade In / Fade Out: el bloque de información aparece
            // suavemente una vez cargada la pantalla.
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: AnimatedSlide(
                offset: _visible ? Offset.zero : const Offset(0, 0.08),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Producto horneado en casa, elaborado con ingredientes '
                        'seleccionados por Dulce Aroma. Cantidad actual en tu '
                        'carrito: ${item.quantity}.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
