import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
// import '../../../../app/theme/app_radius.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController controller;

  const ProfileTabBar({
    tabAlignment = TabAlignment.fill,
    labelPadding = const EdgeInsets.symmetric(horizontal: 2),
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 75,

      padding: const EdgeInsets.all(6),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

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

        unselectedLabelColor: Colors.grey[700],

        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),

        tabs: [
          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(Icons.dashboard_rounded, size: 18),

                const SizedBox(height: 2),

                Text(
                  l10n.overview,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(Icons.history_rounded, size: 18),

                const SizedBox(height: 2),

                Text(
                  l10n.history,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(Icons.qr_code_rounded, size: 18),

                const SizedBox(height: 2),

                Text(
                  l10n.qr,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(Icons.person_rounded, size: 18),

                const SizedBox(height: 2),

                Text(
                  l10n.info,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
