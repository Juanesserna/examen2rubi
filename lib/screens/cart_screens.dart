import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../widgets/cart_item_card.dart';
import 'product_detail_screens.dart';

const _kAccentColor = Color(0xFFE91E63);
const _kBackground = Color(0xFFF6F5F8);

/// Pantalla "Shopping Cart" — réplica exacta del diseño compartido.
///
/// Animación principal: STAGGERED ANIMATION. Cada tarjeta de producto
/// entra con un pequeño desfase (fade + slide hacia arriba) controlado
/// por un único [AnimationController] y distintos [Interval] por índice,
/// tal como pide el patrón de "staggered animations" de Flutter.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late List<CartItemModel> _items;

  static const double _deliveryFee = 2.99;
  static const double _discount = 2.00;

  @override
  void initState() {
    super.initState();
    _items = buildSampleCartItems();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get _total => _subtotal + _deliveryFee - _discount;

  void _updateQuantity(CartItemModel item, int delta) {
    setState(() {
      final newQty = item.quantity + delta;
      item.quantity = newQty < 1 ? 1 : newQty;
    });
  }

  /// Genera la animación con desfase (stagger) para el índice [index]
  /// dentro de la lista de productos.
  Animation<double> _staggerAnimationFor(int index) {
    final start = (index * 0.15).clamp(0.0, 1.0);
    final end = (start + 0.6).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _staggerController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  void _openProductDetail(CartItemModel item) {
    // Transición de ruta personalizada (Animate a page route transition):
    // combina fade + scale en lugar de la transición por defecto.
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: [
                  _buildSectionTitle(),
                  const SizedBox(height: 16),
                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final animation = _staggerAnimationFor(index);
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) => Opacity(
                        opacity: animation.value,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - animation.value)),
                          child: child,
                        ),
                      ),
                      child: CartItemCard(
                        item: item,
                        onIncrement: () => _updateQuantity(item, 1),
                        onDecrement: () => _updateQuantity(item, -1),
                        onImageTap: () => _openProductDetail(item),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  _PromoCodeField(),
                  const SizedBox(height: 16),
                  _buildSummaryCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CircleIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.maybePop(context),
            ),
            const Text(
              'Dulce Aroma',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            _CircleIconButton(
              icon: Icons.delete_outline,
              iconColor: _kAccentColor,
              onTap: () {
                setState(() {
                  for (final item in _items) {
                    item.quantity = 1;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE4EC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_items.length} Items',
            style: const TextStyle(
              color: _kAccentColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 10),
          _summaryRow(
            'Delivery Fee',
            '\$${_deliveryFee.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _summaryRow(
            'Discount',
            '-\$${_discount.toStringAsFixed(2)}',
            valueColor: const Color(0xFF2ECC71),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _summaryRow(
            'Total',
            '\$${_total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14.5,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isTotal ? _kAccentColor : Colors.black87),
          ),
        ),
      ],
    );
  }

  /// Caja blanca inferior única que agrupa el botón "Proceed to Checkout"
  /// (arriba) y la barra de navegación (abajo), tal como en el diseño.
  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCheckoutButton(),
              const SizedBox(height: 14),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return _AnimatedPressButton(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Procediendo al checkout...')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _kAccentColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _kAccentColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed to Checkout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _NavItem(icon: Icons.storefront_outlined, label: 'SHOP'),
        _NavItem(icon: Icons.search, label: 'SEARCH'),
        _NavItem(
          icon: Icons.shopping_cart,
          label: 'CART',
          isActive: true,
          badgeCount: 1,
        ),
        _NavItem(icon: Icons.person_outline, label: 'PROFILE'),
      ],
    );
  }
}

/// Botón circular reutilizable para el header (flecha de volver, papelera).
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}

/// Campo de código promocional con botón "Apply".
/// El botón usa una animación implícita (AnimatedScale) al presionarlo.
class _PromoCodeField extends StatefulWidget {
  @override
  State<_PromoCodeField> createState() => _PromoCodeFieldState();
}

class _PromoCodeFieldState extends State<_PromoCodeField> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E5EC)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Promo code', 
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          GestureDetector(
            onTapDown: (_) => setState(() => _scale = 0.94),
            onTapUp: (_) => setState(() => _scale = 1.0),
            onTapCancel: () => setState(() => _scale = 1.0),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código de promoción aplicado')),
              );
            },
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 120),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: _kAccentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Envoltorio genérico que anima ligeramente cualquier botón al presionarlo.
class _AnimatedPressButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedPressButton({required this.child, required this.onTap});

  @override
  State<_AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<_AnimatedPressButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

/// Ítem individual de la barra de navegación inferior.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final int? badgeCount;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _kAccentColor : Colors.grey[400];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: color, size: 24),
            if (badgeCount != null)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: _kAccentColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: Text(
                    '$badgeCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10.5, color: color)),
      ],
    );
  }
}
