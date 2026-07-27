import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../theme/app_theme.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartItemCount = Provider.of<CartProvider>(context).itemCount;
    final wishlistCount = Provider.of<WishlistProvider>(context).itemCount;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCharcoal.withOpacity(0.95),
        border: const Border(top: BorderSide(color: AppTheme.cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.goldAccent,
        unselectedItemColor: AppTheme.textMuted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: AppTheme.goldAccent),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded, color: AppTheme.goldAccent),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(
              icon: Icons.favorite_border,
              count: wishlistCount,
              badgeColor: AppTheme.roseGold,
            ),
            activeIcon: _buildBadgeIcon(
              icon: Icons.favorite,
              count: wishlistCount,
              badgeColor: AppTheme.roseGold,
              iconColor: AppTheme.goldAccent,
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(
              icon: Icons.shopping_bag_outlined,
              count: cartItemCount,
              badgeColor: AppTheme.goldAccent,
            ),
            activeIcon: _buildBadgeIcon(
              icon: Icons.shopping_bag,
              count: cartItemCount,
              badgeColor: AppTheme.goldAccent,
              iconColor: AppTheme.goldAccent,
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: AppTheme.goldAccent),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon({
    required IconData icon,
    required int count,
    required Color badgeColor,
    Color? iconColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: iconColor),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: AppTheme.obsidianBlack,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
