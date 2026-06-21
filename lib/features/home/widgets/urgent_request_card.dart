import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_colors.dart';
// import '../../../../app/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';

class UrgentRequestCard extends StatelessWidget {
  final String hospital;

  final String bloodGroup;

  final String urgency;

  final String quantity;

  final String distance;

  final bool critical;

  final VoidCallback? onTap;

  const UrgentRequestCard({
    super.key,
    required this.hospital,
    required this.bloodGroup,
    required this.urgency,
    required this.quantity,
    required this.distance,
    required this.critical,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color:
              critical
                  ? Colors.red.withOpacity(0.18)
                  : Colors.orange.withOpacity(0.18),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        children: [
          /// ==========================================
          /// ICON
          /// ==========================================
          Container(
            height: 60,
            width: 60,

            decoration: BoxDecoration(
              color:
                  critical
                      ? Colors.red.withOpacity(0.10)
                      : Colors.orange.withOpacity(0.10),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(
              Icons.bloodtype_rounded,

              color: critical ? Colors.red : Colors.orange,

              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          /// ==========================================
          /// CONTENT
          /// ==========================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  hospital,

                 style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children: [
                    _badge(bloodGroup, Colors.red),

                    _badge(urgency, critical ? Colors.red : Colors.orange),

                    _badge(quantity, Colors.blue),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),

                    const SizedBox(width: 6),

                    Text(
                      distance,

                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// ==========================================
          /// BUTTON
          /// ==========================================
          ElevatedButton(
            onPressed: onTap,

            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 48),

              padding: const EdgeInsets.symmetric(horizontal: 18),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

           child: Text(l10n.imGoing),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: TextStyle(
          color: color,

          fontWeight: FontWeight.w800,

          fontSize: 11,
        ),
      ),
    );
  }
}
