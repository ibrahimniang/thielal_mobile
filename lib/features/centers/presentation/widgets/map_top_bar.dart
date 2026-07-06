import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class MapTopBar extends StatefulWidget {
  final TextEditingController controller;

  final Function(String) onChanged;

  const MapTopBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<MapTopBar> createState() => _MapTopBarState();
}

class _MapTopBarState extends State<MapTopBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (!mounted) return;

      setState(() {
        _hasText = widget.controller.text.trim().isNotEmpty;
      });
    });
  }

  void _clearSearch() {
    widget.controller.clear();

    widget.onChanged('');

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      top: 16,

      left: 16,

      right: 16,

      child: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.90),

                borderRadius: BorderRadius.circular(AppRadius.xl),

                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withOpacity(0.20),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),

                    blurRadius: 18,

                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Row(
                children: [
                  /// =========================
                  /// SEARCH FIELD
                  /// =========================
                  Expanded(
                    child: Container(
                      height: 52,

                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Row(
                        children: [
                          /// SEARCH ICON
                          const Icon(
                            Icons.search_rounded,

                            color: Colors.grey,

                            size: 22,
                          ),

                          const SizedBox(width: 10),

                          /// TEXT FIELD
                          Expanded(
                            child: TextField(
                              controller: widget.controller,

                              textInputAction: TextInputAction.search,

                              onChanged: widget.onChanged,

                              onSubmitted: (value) {
                                /// AUTO CLEAR
                                Future.delayed(
                                  const Duration(milliseconds: 600),

                                  () {
                                    if (!mounted) return;

                                    _clearSearch();
                                  },
                                );
                              },

                              style: const TextStyle(
                                fontSize: 14,

                                fontWeight: FontWeight.w600,
                              ),

                              decoration: InputDecoration(
                                hintText: l10n.searchCenter,

                                hintStyle: TextStyle(
                                  color: Colors.grey[500],

                                  fontSize: 13,
                                ),

                                border: InputBorder.none,

                                isCollapsed: true,
                              ),
                            ),
                          ),

                          /// CLEAR BUTTON
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),

                            child:
                                _hasText
                                    ? GestureDetector(
                                      key: const ValueKey(1),

                                      onTap: _clearSearch,

                                      child: Container(
                                        height: 24,

                                        width: 24,

                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.12),

                                          shape: BoxShape.circle,
                                        ),

                                        child: const Icon(
                                          Icons.close_rounded,

                                          size: 16,

                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                    : const SizedBox(key: ValueKey(2)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// =========================
                  /// FILTER BUTTON
                  /// =========================
                  GestureDetector(
                    onTap: () {},

                    child: Container(
                      height: 52,

                      width: 52,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: AppColors.primaryRed,

                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRed.withOpacity(0.22),

                            blurRadius: 14,

                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.tune_rounded,

                        color: Colors.white,

                        size: 24,
                      ),
                    ),
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
