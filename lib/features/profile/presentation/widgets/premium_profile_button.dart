import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';

class PremiumProfileButton extends StatelessWidget {
  final String text;

  final IconData icon;

  final VoidCallback? onTap;

  final Color color;

  final bool outlined;

  const PremiumProfileButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.color = const Color(0xFFC1121F),
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color:
              outlined
                  ? Colors.transparent
                  : color,

          borderRadius:
              BorderRadius.circular(
                AppRadius.xl,
              ),

          border:
              outlined
                  ? Border.all(
                    color: color,
                    width: 1.5,
                  )
                  : null,

          boxShadow:
              outlined
                  ? null
                  : [
                    BoxShadow(
                      color: color.withOpacity(
                        0.25,
                      ),

                      blurRadius: 18,

                      offset: const Offset(
                        0,
                        10,
                      ),
                    ),
                  ],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icon,
              color:
                  outlined
                      ? color
                      : Colors.white,
            ),

            const SizedBox(width: 12),

            Text(
              text,

              style: TextStyle(
                color:
                    outlined
                        ? color
                        : Colors.white,

                fontWeight:
                    FontWeight.w800,

                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}