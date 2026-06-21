import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class CenterMarker extends StatefulWidget {
  final VoidCallback onTap;

  final bool selected;

  const CenterMarker({
    super.key,
    required this.onTap,
    this.selected = false,
  });

  @override
  State<CenterMarker> createState() =>
      _CenterMarkerState();
}

class _CenterMarkerState
    extends State<CenterMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double>
  _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(
        milliseconds: 1600,
      ),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(
          begin: 1,
          end: 1.12,
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: widget.onTap,

      child: AnimatedBuilder(
        animation: _pulseAnimation,

        builder: (context, child) {
          return Transform.scale(
            scale:
                widget.selected
                    ? _pulseAnimation.value
                    : 1,

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                /// =========================
                /// MAIN PIN
                /// =========================
                Container(
                  height:
                      widget.selected
                          ? 60
                          : 54,

                  width:
                      widget.selected
                          ? 60
                          : 54,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient:
                        const LinearGradient(
                          begin:
                              Alignment
                                  .topLeft,

                          end:
                              Alignment
                                  .bottomRight,

                          colors: [
                            Color(
                              0xFFE53946,
                            ),
                            Color(
                              0xFFC1121F,
                            ),
                          ],
                        ),

                    border: Border.all(
                      color: colors.surface,
                      width: 3,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primaryRed
                            .withOpacity(
                              0.30,
                            ),

                        blurRadius: 22,

                        spreadRadius:
                            widget.selected
                                ? 4
                                : 1,

                        offset:
                            const Offset(
                              0,
                              10,
                            ),
                      ),
                    ],
                  ),

                  child: Icon(
                    Icons.local_hospital_rounded,

                    color: colors.onPrimary,

                    size: 28,
                  ),
                ),

                /// =========================
                /// PIN TAIL
                /// =========================
                Container(
                  width: 5,

                  height: 16,

                  decoration: BoxDecoration(
                    color:
                        AppColors
                            .primaryRed,

                    borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}