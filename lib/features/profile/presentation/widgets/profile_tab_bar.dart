import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController controller;

  const ProfileTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 75,

      padding: const EdgeInsets.all(6),

      decoration: BoxDecoration(
        color: isDark ? colors.surface : Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: isDark
            ? Border.all(
                color: colors.outline.withOpacity(0.2),
              )
            : null,

        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: TabBar(
        controller: controller,

        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        dividerColor: Colors.transparent,

        indicator: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(18),
        ),

        indicatorSize: TabBarIndicatorSize.tab,

        labelColor: Colors.white,

        unselectedLabelColor: isDark
            ? colors.onSurface.withOpacity(0.6)
            : Colors.grey[700],

        labelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),

        tabs: [
          _tab(
            icon: Icons.dashboard_rounded,
            label: l10n.overview,
          ),

          _tab(
            icon: Icons.history_rounded,
            label: l10n.history,
          ),

          _tab(
            icon: Icons.qr_code_rounded,
            label: l10n.qr,
          ),

          _tab(
            icon: Icons.person_rounded,
            label: l10n.info,
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required IconData icon,
    required String label,
  }) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 18),

          const SizedBox(height: 2),

          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}