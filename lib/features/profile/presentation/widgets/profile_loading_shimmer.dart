import 'package:flutter/material.dart';

class ProfileLoadingShimmer extends StatefulWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  State<ProfileLoadingShimmer> createState() =>
      _ProfileLoadingShimmerState();
}

class _ProfileLoadingShimmerState extends State<ProfileLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
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

    return AnimatedBuilder(
      animation: _controller,

      builder: (_, __) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              _box(
                height: 260,
                radius: 34,
                isDark: isDark,
                colors: colors,
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _box(
                      height: 120,
                      isDark: isDark,
                      colors: colors,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _box(
                      height: 120,
                      isDark: isDark,
                      colors: colors,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _box(height: 180, isDark: isDark, colors: colors),

              const SizedBox(height: 20),

              _box(height: 180, isDark: isDark, colors: colors),

              const SizedBox(height: 20),

              _box(height: 180, isDark: isDark, colors: colors),
            ],
          ),
        );
      },
    );
  }

  Widget _box({
    required double height,
    double radius = 28,
    required bool isDark,
    required ColorScheme colors,
  }) {
    return Container(
      height: height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),

        gradient: LinearGradient(
          begin: Alignment(-1 + (_controller.value * 2), 0),
          end: Alignment(1 + (_controller.value * 2), 0),

          colors: isDark
              ? [
                  colors.surface.withOpacity(0.6),
                  colors.surface.withOpacity(0.3),
                  colors.surface.withOpacity(0.6),
                ]
              : [
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                ],
        ),
      ),
    );
  }
}