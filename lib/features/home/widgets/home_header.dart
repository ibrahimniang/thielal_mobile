import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class HomeHeader extends StatefulWidget {
  final TextEditingController controller;

  /// 🔥 prénom utilisateur
  final String? firstName;

  /// 🔥 données recherche
  final List<String> suggestions;

  /// 🔥 callback recherche
  final Function(String)? onChanged;

  final Function(String)? onSuggestionTap;

  final VoidCallback? onMenuTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    required this.controller,
    required this.suggestions,
    this.firstName,
    this.onChanged,
    this.onSuggestionTap,
    this.onMenuTap,
    this.onChatTap,
    this.onProfileTap,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    debugPrint('👤 FIRST NAME => ${widget.firstName}');

    final letter =
        (widget.firstName != null && widget.firstName!.trim().isNotEmpty)
            ? widget.firstName!.trim()[0].toUpperCase()
            : '?';

    return SafeArea(
      bottom: false,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          12,
          AppSpacing.screenPadding,
          0,
        ),

        child: Column(
          children: [
            /// ==========================================
            /// HEADER
            /// ==========================================
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.90),

                    borderRadius: BorderRadius.circular(AppRadius.xl),

                    border: Border.all(color: Colors.white.withOpacity(0.45)),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),

                        blurRadius: 24,

                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      /// MENU
                      _squareButton(
                        icon: Icons.menu_rounded,

                        onTap: widget.onMenuTap,
                      ),

                      const SizedBox(width: 12),

                      /// SEARCH
                      Expanded(
                        child: Container(
                          height: 54,

                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          decoration: BoxDecoration(
                            color: AppColors.silverBackground,

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,

                                color: Colors.grey,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: TextField(
                                  controller: widget.controller,

                                  textInputAction: TextInputAction.search,

                                  onChanged: (value) {
                                    debugPrint('🔍 SEARCH => $value');

                                    setState(() {
                                      showSuggestions = value.trim().isNotEmpty;
                                    });

                                    widget.onChanged?.call(value);
                                  },

                                  decoration: InputDecoration(
                                    hintText: l10n.search,

                                    border: InputBorder.none,

                                    isCollapsed: true,
                                  ),

                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,

                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// CHAT
                      _iconButton(
                        icon: Icons.chat_bubble_outline_rounded,

                        onTap: widget.onChatTap,
                      ),

                      const SizedBox(width: 12),

                      /// PROFILE
                      GestureDetector(
                        onTap: widget.onProfileTap,

                        child: Container(
                          height: 54,
                          width: 54,

                          decoration: BoxDecoration(
                            color: AppColors.primaryRed.withOpacity(0.12),

                            borderRadius: BorderRadius.circular(18),

                            border: Border.all(
                              color: AppColors.primaryRed.withOpacity(0.18),
                            ),
                          ),

                          child: Center(
                            child: Text(
                              letter,

                              style: const TextStyle(
                                color: AppColors.primaryRed,

                                fontWeight: FontWeight.w900,

                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ==========================================
            /// LIVE SUGGESTIONS
            /// ==========================================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),

              child:
                  showSuggestions && widget.suggestions.isNotEmpty
                      ? Container(
                        margin: const EdgeInsets.only(top: 10),

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(24),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),

                              blurRadius: 18,

                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),

                        child: Column(
                          children:
                              widget.suggestions
                                  .take(5)
                                  .map(
                                    (item) => ListTile(
                                      dense: true,

                                      leading: const Icon(
                                        Icons.search_rounded,

                                        color: AppColors.primaryRed,
                                      ),

                                      title: Text(item),

                                      onTap: () {
                                        widget.controller.text = item;

                                        widget.onSuggestionTap?.call(item);

                                        setState(() {
                                          showSuggestions = false;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      )
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================================
  /// MENU BUTTON
  /// ==========================================

  Widget _squareButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 54,
        width: 54,

        decoration: BoxDecoration(
          color: AppColors.silverBackground,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }

  /// ==========================================
  /// ICON BUTTON
  /// ==========================================

  Widget _iconButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 54,
        width: 54,

        decoration: BoxDecoration(
          color: AppColors.silverBackground,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
