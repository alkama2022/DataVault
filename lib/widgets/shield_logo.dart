import 'package:flutter/material.dart';
import '../config/app_colors.dart';

/// Gold shield with lightning bolt — the DataVault brand mark.
/// Drawn with a CustomPainter so no image assets are required.
class ShieldLogo extends StatelessWidget {
  const ShieldLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ShieldPainter(),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shieldPath = Path()
      ..moveTo(w * 0.5, h * 0.04)
      ..lineTo(w * 0.88, h * 0.18)
      ..lineTo(w * 0.88, h * 0.52)
      ..quadraticBezierTo(w * 0.88, h * 0.78, w * 0.5, h * 0.96)
      ..quadraticBezierTo(w * 0.12, h * 0.78, w * 0.12, h * 0.52)
      ..lineTo(w * 0.12, h * 0.18)
      ..close();

    // Shield body gradient
    final shieldPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.gold, Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawPath(shieldPath, shieldPaint);

    // Inner border
    final innerPath = Path()
      ..moveTo(w * 0.5, h * 0.12)
      ..lineTo(w * 0.80, h * 0.23)
      ..lineTo(w * 0.80, h * 0.52)
      ..quadraticBezierTo(w * 0.80, h * 0.73, w * 0.5, h * 0.88)
      ..quadraticBezierTo(w * 0.20, h * 0.73, w * 0.20, h * 0.52)
      ..lineTo(w * 0.20, h * 0.23)
      ..close();
    canvas.drawPath(
      innerPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..color = Colors.white.withOpacity(0.55),
    );

    // Lightning bolt
    final boltPath = Path()
      ..moveTo(w * 0.54, h * 0.30)
      ..lineTo(w * 0.40, h * 0.55)
      ..lineTo(w * 0.48, h * 0.55)
      ..lineTo(w * 0.44, h * 0.72)
      ..lineTo(w * 0.62, h * 0.47)
      ..lineTo(w * 0.53, h * 0.47)
      ..close();
    canvas.drawPath(boltPath, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
