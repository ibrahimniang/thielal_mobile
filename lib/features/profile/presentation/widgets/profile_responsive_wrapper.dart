import 'package:flutter/material.dart';

class ProfileResponsiveWrapper
    extends StatelessWidget {
  final Widget child;

  const ProfileResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return Center(
        child: SizedBox(
          width: 900,
          child: child,
        ),
      );
    }

    if (width >= 700) {
      return Center(
        child: SizedBox(
          width: 680,
          child: child,
        ),
      );
    }

    return child;
  }
}