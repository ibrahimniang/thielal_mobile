import 'package:flutter/material.dart';

class ProfileResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ProfileResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    Widget content = child;

    if (width >= 1200) {
      content = Center(
        child: SizedBox(
          width: 900,
          child: child,
        ),
      );
    } else if (width >= 700) {
      content = Center(
        child: SizedBox(
          width: 680,
          child: child,
        ),
      );
    }

    return Container(
      color: colors.background,
      child: content,
    );
  }
}