import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

/// Muestra la imagen del producto (asset o red) dentro de un contenedor
/// con el degradado del producto de fondo. Si no hay imagen disponible,
/// cae al ícono de respaldo.
class ProductImage extends StatelessWidget {
  final CartItemModel item;
  final double size;
  final double borderRadius;

  const ProductImage({
    super.key,
    required this.item,
    this.size = 64,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final hasAsset = item.imagePath != null && item.imagePath!.isNotEmpty;
    final hasNetwork = item.imageUrl != null && item.imageUrl!.isNotEmpty;

    Widget content;
    if (hasAsset) {
      content = Image.asset(
        item.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(item.fallbackIcon, color: Colors.white, size: size * 0.47),
      );
    } else if (hasNetwork) {
      content = Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
          );
        },
        errorBuilder: (_, __, ___) =>
            Icon(item.fallbackIcon, color: Colors.white, size: size * 0.47),
      );
    } else {
      content = Icon(item.fallbackIcon, color: Colors.white, size: size * 0.47);
    }

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [item.color, item.color.withOpacity(0.7)],
        ),
      ),
      child: Center(child: content),
    );
  }
}
