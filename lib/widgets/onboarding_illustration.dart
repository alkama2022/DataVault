import 'package:flutter/material.dart';
import '../config/app_colors.dart';

/// Custom-drawn onboarding illustrations (no external image assets needed).
/// Each variant matches one onboarding page.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.variant});

  /// 0: Buy Data in Seconds, 1: Simple. Fast. Secure., 2: Everything You Need
  final int variant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _IllustrationPainter(variant),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  _IllustrationPainter(this.variant);

  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background blob
    final blobPaint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.55);
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.42),
      w * 0.42,
      blobPaint,
    );
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.18),
      w * 0.16,
      Paint()..color = AppColors.primaryLight.withOpacity(0.35),
    );
    canvas.drawCircle(
      Offset(w * 0.15, h * 0.75),
      w * 0.12,
      Paint()..color = AppColors.goldLight.withOpacity(0.5),
    );

    switch (variant) {
      case 0:
        _drawDataPhone(canvas, w, h);
        break;
      case 1:
        _drawSecurePhone(canvas, w, h);
        break;
      default:
        _drawEverythingPhone(canvas, w, h);
    }
  }

  /// Phone with "4G" data waves.
  void _drawDataPhone(Canvas canvas, double w, double h) {
    _phoneFrame(canvas, w, h, const Color(0xFF1E293B));

    // Screen content
    final screenRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.45),
      width: w * 0.30,
      height: h * 0.34,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(screenRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFFF1F5F9),
    );

    // 4G badge
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.38),
      w * 0.085,
      Paint()..color = AppColors.primary,
    );
    _text(canvas, '4G', Offset(w * 0.5, h * 0.38), Colors.white, w * 0.075, true);

    // Data bars
    for (var i = 0; i < 4; i++) {
      final barH = h * 0.03 + i * h * 0.014;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            w * 0.44 + i * w * 0.035,
            h * 0.55 - barH,
            w * 0.022,
            barH,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = AppColors.primary.withOpacity(0.75 - i * 0.12),
      );
    }

    // Signal waves
    for (var i = 1; i <= 3; i++) {
      final rect = Rect.fromCenter(
        center: Offset(w * 0.74, h * 0.24),
        width: w * 0.06 * i,
        height: w * 0.06 * i,
      );
      canvas.drawCircle(
        rect.center,
        rect.width / 2,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = AppColors.primary.withOpacity(0.5 - i * 0.12),
      );
    }
  }

  /// Phone with padlock and shield.
  void _drawSecurePhone(Canvas canvas, double w, double h) {
    _phoneFrame(canvas, w, h, const Color(0xFF1E293B));

    final screenRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.45),
      width: w * 0.30,
      height: h * 0.34,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(screenRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFFF1F5F9),
    );

    // Card on screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.40),
          width: w * 0.20,
          height: h * 0.10,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = AppColors.primary,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.43, h * 0.43, w * 0.14, h * 0.014),
      Paint()..color = Colors.white.withOpacity(0.7),
    );

    // Padlock
    final lockCenter = Offset(w * 0.5, h * 0.55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: lockCenter, width: w * 0.11, height: h * 0.075),
        const Radius.circular(6),
      ),
      Paint()..color = AppColors.gold,
    );
    final arcPath = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(lockCenter.dx, lockCenter.dy - h * 0.02),
          width: w * 0.07,
          height: w * 0.07,
        ),
        3.14,
        3.14,
      );
    canvas.drawPath(
      arcPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.018
        ..color = AppColors.gold,
    );
  }

  /// Phone surrounded by mini service cards.
  void _drawEverythingPhone(Canvas canvas, double w, double h) {
    _phoneFrame(canvas, w, h, const Color(0xFF1E293B));

    final screenRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.45),
      width: w * 0.30,
      height: h * 0.34,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(screenRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFFF1F5F9),
    );

    // Mini app grid on screen
    final colors = [
      AppColors.airtime,
      AppColors.data,
      AppColors.electricity,
      AppColors.cable,
    ];
    for (var r = 0; r < 2; r++) {
      for (var c = 0; c < 2; c++) {
        final cx = w * 0.44 + c * w * 0.075;
        final cy = h * 0.40 + r * h * 0.075;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: w * 0.05, height: w * 0.05),
            const Radius.circular(4),
          ),
          Paint()..color = colors[r * 2 + c],
        );
      }
    }

    // Floating chips
    _chip(canvas, Offset(w * 0.24, h * 0.30), 'Data', AppColors.data, w);
    _chip(canvas, Offset(w * 0.76, h * 0.34), 'Airtime', AppColors.airtime, w);
    _chip(canvas, Offset(w * 0.24, h * 0.62), 'Wallet', AppColors.wallet, w);
    _chip(canvas, Offset(w * 0.76, h * 0.60), 'Bills', AppColors.electricity, w);
  }

  void _phoneFrame(Canvas canvas, double w, double h, Color color) {
    final phoneRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.45),
      width: w * 0.36,
      height: h * 0.44,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(phoneRect, const Radius.circular(16)),
      Paint()..color = color,
    );
  }

  void _chip(Canvas canvas, Offset center, String label, Color color, double w) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.035,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final chipW = textPainter.width + w * 0.06;
    final chipH = w * 0.085;
    final rect = Rect.fromCenter(center: center, width: chipW, height: chipH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      Paint()..color = color,
    );
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  void _text(Canvas canvas, String text, Offset center, Color color, double fontSize, bool bold) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter oldDelegate) =>
      oldDelegate.variant != variant;
}
