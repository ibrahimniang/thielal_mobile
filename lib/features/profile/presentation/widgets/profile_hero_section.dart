import 'dart:ui';

import 'package:flutter/material.dart';

// import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
// import '../../../../app/theme/app_radius.dart';
// import '../../../../app/theme/app_spacing.dart';

import 'blood_group_chip.dart';
import 'profile_stat_card.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileHeroSection extends StatelessWidget {
  final String fullName;
  final String bloodGroup;

  final bool verified;

  final int donationsCount;
  final int savedLives;
  final int points;

  final VoidCallback? onEditTap;

  const ProfileHeroSection({
    super.key,
    required this.fullName,
    required this.bloodGroup,
    required this.verified,
    required this.donationsCount,
    required this.savedLives,
    required this.points,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final letter =
        fullName.trim().isNotEmpty ? fullName.trim()[0].toUpperCase() : '?';

    return Stack(
      children: [
        /// =====================================================
        /// DECORATIVE CIRCLES
        /// =====================================================
        Positioned(
          top: -30,
          right: -20,

          child: Container(
            height: 120,
            width: 120,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),

        Positioned(
          bottom: -40,
          left: -30,

          child: Container(
            height: 140,
            width: 140,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.red.withOpacity(0.22),

                blurRadius: 30,

                offset: const Offset(0, 14),
              ),
            ],
            gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF1F2937)],
              )
            : AppGradients.primaryRed,
            borderRadius: BorderRadius.circular(34),
          ),

          child: Column(
            children: [
              /// TOP
              Row(
                children: [
                  /// AVATAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                      child: Container(
                        height: 76,
                        width: 76,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),

                          borderRadius: BorderRadius.circular(26),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),

                        child: Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 18),

                  /// INFOS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 8),

                        BloodGroupChip(
                          bloodGroup: bloodGroup,
                          verified: verified,
                          large: true,
                        ),
                      ],
                    ),
                  ),

                  /// EDIT
                  GestureDetector(
                    onTap: onEditTap,

                    child: Container(
                      height: 46,
                      width: 46,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// STATS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),

                  borderRadius: BorderRadius.circular(24),

                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),

                child: Row(
                  children: [
                    ProfileStatCard(
                      icon: Icons.bloodtype_rounded,
                      value: '$donationsCount',
                      label: l10n.donations,
                    ),

                    ProfileStatCard(
                      icon: Icons.favorite_rounded,
                      value: '$savedLives',
                      label: l10n.lives,
                    ),

                    ProfileStatCard(
                      icon: Icons.workspace_premium_rounded,
                      value: '$points',
                      label: l10n.points,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
