import 'package:flutter/foundation.dart';
import '../models/product.dart';

// Singleton simple con ChangeNotifier para que cualquier pantalla
// pueda escuchar cambios en el carrito sin pasar callbacks manualmente.
class CartModel extends ChangeNotifier {
  CartModel._internal();
  static final CartModel instance = CartModel._internal();

  final List<Product> _items = [];

  List<Product> get items => _items;
  int get itemCount => _items.length;
  double get total => _items.fold(0, (sum, p) => sum + p.price);

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
