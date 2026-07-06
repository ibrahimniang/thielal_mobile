import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppHeartLoader extends StatefulWidget {
  final double size;

  const AppHeartLoader({super.key, this.size = 120});

  @override
  State<AppHeartLoader> createState() => _AppHeartLoaderState();
}

class _AppHeartLoaderState extends State<AppHeartLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final scale = 1 + (math.sin(_controller.value * 2 * math.pi) * 0.04);

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _HeartEcgPainter(progress: _controller.value),
            ),
          ),
        );
      },
    );
  }
}

class _HeartEcgPainter extends CustomPainter {
  final double progress;

  _HeartEcgPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final heartPaint =
        Paint()
          ..color = Colors.red.shade600
          ..style = PaintingStyle.fill;

    final shadowPaint =
        Paint()
          ..color = Colors.red.withOpacity(0.10)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final heartPath = _buildHeartPath(size);

    canvas.drawPath(heartPath, shadowPaint);
    canvas.drawPath(heartPath, heartPaint);

    canvas.save();
    canvas.clipPath(heartPath);

    final ecgBaseY = size.height * 0.53;
    final left = size.width * 0.18;
    final right = size.width * 0.82;
    final width = right - left;

    final ecgPaintBg =
        Paint()
          ..color = Colors.white.withOpacity(0.22)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final ecgPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final fullPath =
        Path()
          ..moveTo(left, ecgBaseY)
          ..lineTo(left + width * 0.18, ecgBaseY)
          ..lineTo(left + width * 0.28, ecgBaseY - 6)
          ..lineTo(left + width * 0.36, ecgBaseY + 10)
          ..lineTo(left + width * 0.46, ecgBaseY - 32)
          ..lineTo(left + width * 0.56, ecgBaseY + 16)
          ..lineTo(left + width * 0.66, ecgBaseY)
          ..lineTo(left + width * 0.82, ecgBaseY)
          ..lineTo(right, ecgBaseY);

    canvas.drawPath(fullPath, ecgPaintBg);

    final animatedWidth = width * progress;
    final animatedPath = Path()..moveTo(left, ecgBaseY);

    void safeLine(double x, double y) {
      if (x <= left + animatedWidth) {
        animatedPath.lineTo(x, y);
      }
    }

    safeLine(left + width * 0.18, ecgBaseY);
    safeLine(left + width * 0.28, ecgBaseY - 6);
    safeLine(left + width * 0.36, ecgBaseY + 10);
    safeLine(left + width * 0.46, ecgBaseY - 32);
    safeLine(left + width * 0.56, ecgBaseY + 16);
    safeLine(left + width * 0.66, ecgBaseY);
    safeLine(left + width * 0.82, ecgBaseY);
    safeLine(right, ecgBaseY);

    canvas.drawPath(animatedPath, ecgPaint);

    final glowX = left + animatedWidth;
    final glowPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(glowX.clamp(left, right), ecgBaseY), 4, glowPaint);

    canvas.restore();
  }

  Path _buildHeartPath(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w / 2, h * 0.86);
    path.cubicTo(w * 0.08, h * 0.62, w * 0.02, h * 0.22, w * 0.28, h * 0.16);
    path.cubicTo(w * 0.44, h * 0.12, w * 0.50, h * 0.24, w * 0.50, h * 0.24);
    path.cubicTo(w * 0.50, h * 0.24, w * 0.56, h * 0.12, w * 0.72, h * 0.16);
    path.cubicTo(w * 0.98, h * 0.22, w * 0.92, h * 0.62, w / 2, h * 0.86);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _HeartEcgPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
