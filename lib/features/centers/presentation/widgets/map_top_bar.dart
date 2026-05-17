import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class MapTopBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const MapTopBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      top: 18,
      left: 18,
      right: 18,
      child: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),

                borderRadius: BorderRadius.circular(AppRadius.xl),

                border: Border.all(color: Colors.white.withOpacity(0.4)),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),

                    blurRadius: 24,

                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,

                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      decoration: BoxDecoration(
                        color: AppColors.silverBackground,

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: Colors.grey),

                          const SizedBox(width: 10),

                          Expanded(
                            child: TextField(
                              controller: controller,

                              onChanged: onChanged,

                              decoration: InputDecoration(
                                hintText: l10n.searchCenter,

                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Container(
                    height: 52,
                    width: 52,

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE53946), Color(0xFFC1121F)],
                      ),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(Icons.tune_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
