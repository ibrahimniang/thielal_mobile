import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ProfileErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            /// ICON
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.error_outline_rounded,
                size: 58,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 28),

            /// TITLE
            Text(
              l10n.anErrorOccurred,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 14),

            /// MESSAGE
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? colors.onSurface.withOpacity(0.7)
                    : Colors.grey[700],
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (onRetry != null) ...[
              const SizedBox(height: 32),

              GestureDetector(
                onTap: onRetry,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 18,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withOpacity(
                          isDark ? 0.25 : 0.3,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        l10n.retry,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}