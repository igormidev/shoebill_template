import 'package:flutter/material.dart';

/// A circular logo placeholder widget with a pink/coral color.
class LogoPlaceholder extends StatelessWidget {
  /// The size (diameter) of the logo placeholder.
  final double size;

  const LogoPlaceholder({
    super.key,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    // Coral/pink color for the logo placeholder
    const logoColor = Color(0xFFE8A08C);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: logoColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: logoColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.flutter_dash,
          size: size * 0.5,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
