import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class FloatingRequestButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingRequestButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 66,

        padding: const EdgeInsets.symmetric(horizontal: 22),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.35),

              blurRadius: 26,

              offset: const Offset(0, 10),
            ),
          ],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.bloodtype_rounded,

              color: Theme.of(context).colorScheme.onPrimary,

              size: 28,
            ),

            const SizedBox(width: 12),

            Text(
              l10n.iNeedBlood,

              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,

                fontSize: 16,

                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}