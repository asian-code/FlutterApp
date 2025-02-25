import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A custom bottom navigation bar with animations
class CustomBottomNavBar extends StatelessWidget {
  /// Currently selected index
  final int currentIndex;

  /// Callback when an item is tapped
  final Function(int) onTap;

  /// Navigation items to display
  final List<BottomNavItem> items;

  /// Constructor
  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.inputBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated selection indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: (MediaQuery.of(context).size.width - 32) / items.length * currentIndex,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 32) / items.length,
              height: 80,
              child: CustomPaint(
                painter: SelectionPainter(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                ),
              ),
            ),
          ),
          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildNavItem(index, item.icon, item.label);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 80,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Icon glow effect
                    if (isSelected)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    // Icon
                    Icon(
                      icon,
                      size: isSelected ? 28 : 24,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Class for bottom navigation items
class BottomNavItem {
  /// Icon for the item
  final IconData icon;

  /// Label for the item
  final String label;

  /// Constructor
  const BottomNavItem({
    required this.icon,
    required this.label,
  });
}

/// Custom painter for selection indicator
class SelectionPainter extends CustomPainter {
  /// Color for the selection indicator
  final Color color;

  /// Constructor
  SelectionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(15, 0)
      ..lineTo(size.width - 15, 0)
      ..lineTo(size.width - 15, size.height)
      ..lineTo(15, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) => false;
}