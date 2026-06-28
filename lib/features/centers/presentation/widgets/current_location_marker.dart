import 'package:flutter/material.dart';

class CurrentLocationMarker
    extends StatefulWidget {
  const CurrentLocationMarker({
    super.key,
  });

  @override
  State<CurrentLocationMarker>
  createState() =>
      _CurrentLocationMarkerState();
}

class _CurrentLocationMarkerState
    extends State<CurrentLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _controller;

  late final Animation<double>
  _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(
        milliseconds: 1800,
      ),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(
          begin: 0.92,
          end: 1.18,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _pulseAnimation,

      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,

          child: Stack(
            alignment: Alignment.center,

            children: [
              /// =========================
              /// OUTER PULSE
              /// =========================
              Container(
                height: 64,

                width: 64,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: colors.primary.withOpacity(0.10),
                ),
              ),

              /// =========================
              /// MIDDLE PULSE
              /// =========================
              Container(
                height: 44,

                width: 44,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: colors.primary.withOpacity(0.18),
                ),
              ),

              /// =========================
              /// MAIN DOT
              /// =========================
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary,
                      colors.primary.withOpacity(0.8),
                    ],
                  ),

                  border: Border.all(
                    color: colors.surface,
                    width: 4,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}