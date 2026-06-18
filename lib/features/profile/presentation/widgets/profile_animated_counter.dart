import 'package:flutter/material.dart';

class ProfileAnimatedCounter extends StatefulWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;

  const ProfileAnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1200),
    this.style,
  });

  @override
  State<ProfileAnimatedCounter> createState() =>
      _ProfileAnimatedCounterState();
}

class _ProfileAnimatedCounterState
    extends State<ProfileAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ProfileAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _animation = IntTween(
        begin: 0,
        end: widget.value,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w900,
      color: isDark ? colors.onSurface : colors.onSurface,
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Text(
          '${_animation.value}',
          style: widget.style ?? defaultStyle,
        );
      },
    );
  }
}