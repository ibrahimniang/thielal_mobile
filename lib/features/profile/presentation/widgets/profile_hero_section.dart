import 'dart:ui';

import 'package:flutter/material.dart';

// import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
// import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final letter =
        fullName.trim().isNotEmpty
            ? fullName.trim()[0].toUpperCase()
            : '?';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        gradient: AppGradients.primaryRed,
        borderRadius: BorderRadius.circular(34),
      ),

      child: Column(
        children: [
          /// TOP
          Row(
            children: [
              /// AVATAR
              ClipRRect(
                borderRadius: BorderRadius.circular(30),

                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),

                  child: Container(
                    height: 88,
                    width: 88,

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),

                      borderRadius: BorderRadius.circular(30),

                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),

                    child: Center(
                      child: Text(
                        letter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 12),

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
                  height: 52,
                  width: 52,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// STATS
          Row(
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
        ],
      ),
    );
  }
}