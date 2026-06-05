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

                  color: const Color(
                    0xFF2196F3,
                  ).withOpacity(0.10),
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

                  color: const Color(
                    0xFF2196F3,
                  ).withOpacity(0.18),
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

                  gradient:
                      const LinearGradient(
                        begin:
                            Alignment.topLeft,

                        end:
                            Alignment.bottomRight,

                        colors: [
                          Color(0xFF42A5F5),
                          Color(0xFF1976D2),
                        ],
                      ),

                  border: Border.all(
                    color: Colors.white,

                    width: 4,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF2196F3,
                      ).withOpacity(0.35),

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