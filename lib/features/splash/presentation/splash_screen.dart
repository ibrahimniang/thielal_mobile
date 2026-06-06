import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/storage/secure_storage_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _initializeApp();
  }

  Future<void> _goOnce(String route) async {
    if (!mounted || _navigated) return;

    _navigated = true;
    print('SPLASH DEBUG -> navigating to: $route');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go(route);
    });
  }

 Future<void> _initializeApp() async {
  await Future.delayed(
    const Duration(seconds: 2),
  );

  if (!mounted) return;

  final hasSeenOnboarding =
      await SecureStorageService.hasSeenOnboarding();

  print(
    'SPLASH DEBUG -> hasSeenOnboarding: '
    '$hasSeenOnboarding',
  );

  if (!hasSeenOnboarding) {
    await _goOnce(
      RouteNames.onboarding,
    );

    return;
  }

  final hasCompletedEntryFlow =
      await SecureStorageService.hasCompletedEntryFlow();

  print(
    'SPLASH DEBUG -> hasCompletedEntryFlow: '
    '$hasCompletedEntryFlow',
  );

  if (hasCompletedEntryFlow) {
    await _goOnce(
      RouteNames.loginUser,
    );
  } else {
    await _goOnce(
      RouteNames.entryIdentity,
    );
  }
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F7F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final scale =
                    1 + (math.sin(_controller.value * 2 * math.pi) * 0.04);

                return Transform.scale(
                  scale: scale,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: CustomPaint(
                      painter: _HeartEcgPainter(progress: _controller.value),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Thielal / LifeLink',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Chargement de votre espace...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
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
