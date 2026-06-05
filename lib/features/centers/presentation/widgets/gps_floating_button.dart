import 'package:flutter/material.dart';

// import '../../../../app/theme/app_colors.dart';

class GpsFloatingButton
    extends StatefulWidget {
  final VoidCallback onTap;

  const GpsFloatingButton({
    super.key,
    required this.onTap,
  });

  @override
  State<GpsFloatingButton>
  createState() =>
      _GpsFloatingButtonState();
}

class _GpsFloatingButtonState
    extends State<GpsFloatingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _controller;

  late final Animation<double>
  _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(
        milliseconds: 1800,
      ),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(
          begin: 1,
          end: 1.06,
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
    return GestureDetector(
      onTap: widget.onTap,

      child: AnimatedBuilder(
        animation: _scaleAnimation,

        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,

            child: Container(
              height: 56,

              width: 56,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.white,

                border: Border.all(
                  color: Colors.white,

                  width: 2,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.10),

                    blurRadius: 18,

                    offset: const Offset(
                      0,
                      8,
                    ),
                  ),
                ],
              ),

              child: Container(
                margin: const EdgeInsets.all(
                  6,
                ),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient:
                      const LinearGradient(
                        begin:
                            Alignment.topLeft,

                        end:
                            Alignment.bottomRight,

                        colors: [
                          Color(
                            0xFFE53946,
                          ),
                          Color(
                            0xFFC1121F,
                          ),
                        ],
                      ),
                ),

                child: const Icon(
                  Icons.my_location_rounded,

                  color: Colors.white,

                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}