import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class HomeHeader extends StatefulWidget {
  final TextEditingController controller;

  final String? firstName;

  final List<String> suggestions;

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
  State<HomeHeader> createState() =>
      _HomeHeaderState();
}

class _HomeHeaderState
    extends State<HomeHeader> {
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    final letter =
        (widget.firstName != null &&
                widget.firstName!
                    .trim()
                    .isNotEmpty)
            ? widget.firstName!
                .trim()[0]
                .toUpperCase()
            : '?';

    return SafeArea(
      bottom: false,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          8,
          AppSpacing.screenPadding,
          0,
        ),

        child: Column(
          children: [
            /// ==========================================
            /// HEADER
            /// ==========================================
            Row(
              children: [
                /// ==========================================
                /// MENU
                /// ==========================================
                _iconButton(
                  icon: Icons.menu_rounded,
                  onTap: widget.onMenuTap,
                ),

                const SizedBox(width: 6),

                /// ==========================================
                /// SEARCH
                /// ==========================================
                Expanded(
                  child: TextField(
                    controller:
                        widget.controller,

                    maxLines: 1,

                    textInputAction:
                        TextInputAction.search,

                    textAlignVertical:
                        TextAlignVertical
                            .center,

                    onChanged: (value) {
                      setState(() {
                        showSuggestions =
                            value
                                .trim()
                                .isNotEmpty;
                      });

                      widget.onChanged?.call(
                        value,
                      );
                    },

                    cursorColor:
                        AppColors.primaryRed,

                    style: TextStyle(
                      color:
                          Colors.grey.shade900,

                      fontWeight:
                          FontWeight.w500,

                      fontSize: 16,
                    ),

                    decoration:
                        InputDecoration(
                      hintText:
                          l10n.search,

                      border:
                          InputBorder.none,

                      enabledBorder:
                          InputBorder.none,

                      focusedBorder:
                          InputBorder.none,

                      disabledBorder:
                          InputBorder.none,

                      errorBorder:
                          InputBorder.none,

                      focusedErrorBorder:
                          InputBorder.none,

                      filled: true,

                      fillColor:
                          Colors.transparent,

                      prefixIcon: Icon(
                        Icons.search_rounded,

                        color: Colors
                            .grey.shade600,

                        size: 24,
                      ),

                      hintStyle:
                          TextStyle(
                        color: Colors
                            .grey.shade500,

                        fontWeight:
                            FontWeight.w400,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 2),

                /// ==========================================
                /// CHAT
                /// ==========================================
                _iconButton(
                  icon: Icons
                      .chat_bubble_outline_rounded,

                  onTap:
                      widget.onChatTap,
                ),

                const SizedBox(width: 2),

                /// ==========================================
                /// PROFILE
                /// ==========================================
                GestureDetector(
                  onTap:
                      widget.onProfileTap,

                  child: Container(
                    height: 42,
                    width: 42,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFBECEF,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: Center(
                      child: Text(
                        letter,

                        style:
                            const TextStyle(
                          color:
                              AppColors
                                  .primaryRed,

                          fontWeight:
                              FontWeight
                                  .w900,

                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// ==========================================
            /// SUGGESTIONS
            /// ==========================================
            AnimatedSwitcher(
              duration:
                  const Duration(
                milliseconds: 220,
              ),

              child:
                  showSuggestions &&
                          widget
                              .suggestions
                              .isNotEmpty
                      ? Container(
                        margin:
                            const EdgeInsets.only(
                          top: 10,
                        ),

                        padding:
                            const EdgeInsets.all(
                          12,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(
                                0.05,
                              ),

                              blurRadius: 16,

                              offset:
                                  const Offset(
                                0,
                                8,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children:
                              widget
                                  .suggestions
                                  .take(5)
                                  .map(
                                    (
                                      item,
                                    ) => ListTile(
                                      dense:
                                          true,

                                      title:
                                          Text(
                                        item,
                                      ),

                                      onTap:
                                          () {
                                        widget
                                                .controller
                                                .text =
                                            item;

                                        widget
                                            .onSuggestionTap
                                            ?.call(
                                              item,
                                            );

                                        setState(
                                          () {
                                            showSuggestions =
                                                false;
                                          },
                                        );
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
  /// ICON BUTTON
  /// ==========================================

  Widget _iconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: SizedBox(
        height: 36,
        width: 36,

        child: Icon(
          icon,

          color: Colors.grey.shade800,

          size: 24,
        ),
      ),
    );
  }
}