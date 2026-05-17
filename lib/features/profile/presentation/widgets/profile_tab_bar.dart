import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
// import '../../../../app/theme/app_radius.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController controller;

  const ProfileTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 62,

      padding: const EdgeInsets.all(6),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ),

            blurRadius: 18,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: TabBar(
        controller: controller,

        dividerColor: Colors.transparent,

        indicator: BoxDecoration(
          color: AppColors.primaryRed,

          borderRadius: BorderRadius.circular(
            18,
          ),
        ),

        indicatorSize: TabBarIndicatorSize.tab,

        labelColor: Colors.white,

        unselectedLabelColor: Colors.grey[700],

        labelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),

        tabs:  [
          Tab(
            icon: Icon(Icons.dashboard_rounded),
            text: l10n.overview,
          ),

          Tab(
            icon: Icon(Icons.history_rounded),
            text: l10n.history,
          ),

          Tab(
            icon: Icon(Icons.qr_code_rounded),
            text: l10n.qr,
          ),

          Tab(
            icon: Icon(Icons.person_rounded),
            text: l10n.info,
          ),
        ],
      ),
    );
  }
}