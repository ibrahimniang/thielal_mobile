import 'package:flutter/material.dart';

// import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class BadgeLevelCard extends StatelessWidget {
  final String title;

  final String description;

  final IconData icon;

  final Color color;

  final bool unlocked;

  const BadgeLevelCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.unlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: unlocked ? color.withOpacity(0.10) : Colors.white,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color:
              unlocked
                  ? color.withOpacity(0.25)
                  : Colors.grey.withOpacity(0.10),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 12,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          /// ICON
          Container(
            height: 56,
            width: 56,

            decoration: BoxDecoration(
              color:
                  unlocked
                      ? color.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.08),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(
              unlocked ? icon : Icons.lock_rounded,

              color: unlocked ? color : Colors.grey,

              size: 26,
            ),
          ),

          const SizedBox(height: 12),

          /// TITLE
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: unlocked ? Colors.black : Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          /// DESC
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: unlocked ? Colors.grey[700] : Colors.grey,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          /// STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: unlocked ? color : Colors.grey.withOpacity(0.14),

              borderRadius: BorderRadius.circular(30),
            ),

            child: Text(
              unlocked ? l10n.unlocked : l10n.locked,

              style: TextStyle(
                color: unlocked ? Colors.white : Colors.grey[700],

                fontWeight: FontWeight.w700,fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
