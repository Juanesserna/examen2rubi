import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _inactiveColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.storefront,
        'iconOutlined': Icons.storefront_outlined,
        'label': 'Shop',
      },
      {'icon': Icons.search, 'iconOutlined': Icons.search, 'label': 'Search'},
      {
        'icon': Icons.receipt_long,
        'iconOutlined': Icons.receipt_long_outlined,
        'label': 'Orders',
      },
      {
        'icon': Icons.person,
        'iconOutlined': Icons.person_outline,
        'label': 'Profile',
      },
    ];

    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          final iconData =
              (isSelected ? items[index]['icon'] : items[index]['iconOutlined'])
                  as IconData;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  iconData,
                  color: isSelected ? AppColors.primaryPink : _inactiveColor,
                ),
                Text(
                  (items[index]['label'] as String).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isSelected ? AppColors.primaryPink : _inactiveColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
