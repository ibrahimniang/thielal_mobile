import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class MedicalInfoTile extends StatelessWidget {
  final IconData icon;

  final String label;
  final String value;

  final Color? iconColor;

  final VoidCallback? onTap;

  const MedicalInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSpacing.md,
        ),

        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),

              blurRadius: 14,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [
            /// ICON
            Container(
              height: 52,
              width: 52,

              decoration: BoxDecoration(
                color: (iconColor ??
                        AppColors.primaryRed)
                    .withOpacity(0.10),

                borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
              ),

              child: Icon(
                icon,
                color:
                    iconColor ??
                    AppColors.primaryRed,
              ),
            ),

            const SizedBox(width: 16),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    label,

                    style: TextStyle(
                      color: Colors.grey[600],

                      fontWeight:
                          FontWeight.w600,

                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    value,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight:
                          FontWeight.w800,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}