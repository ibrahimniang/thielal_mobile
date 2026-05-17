import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class PremiumCollectionSection extends StatefulWidget {
  final String title;

  final String location;

  final DateTime date;

  final int participants;

  final int maxPlaces;

  /// 🔥 déjà inscrit
  final bool alreadyRegistered;

  final VoidCallback? onTap;

  const PremiumCollectionSection({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.participants,
    required this.maxPlaces,
    required this.alreadyRegistered,
    this.onTap,
  });

  @override
  State<PremiumCollectionSection> createState() =>
      _PremiumCollectionSectionState();
}

class _PremiumCollectionSectionState extends State<PremiumCollectionSection> {
  late Timer timer;

  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _updateTimer();

    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());
  }

  void _updateTimer() {
    final diff = widget.date.difference(DateTime.now());

    if (!mounted) return;

    setState(() {
      remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),

          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
          ),
        ),

        child: Stack(
          clipBehavior: Clip.none,

          children: [
            /// ==========================================
            /// BUBBLES
            /// ==========================================
            Positioned(top: -20, right: -10, child: _bubble(120, 0.05)),

            Positioned(top: 80, right: 50, child: _bubble(26, 0.06)),

            Positioned(bottom: -20, left: -10, child: _bubble(100, 0.04)),

            Positioned(bottom: 40, left: 120, child: _bubble(18, 0.05)),

            Positioned(top: 30, left: 180, child: _bubble(14, 0.05)),

            /// ==========================================
            /// CONTENT
            /// ==========================================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// ==========================================
                /// HEADER
                /// ==========================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            l10n.activeCollection,

                            style: TextStyle(
                              color: Colors.white70,

                              fontWeight: FontWeight.w800,

                              letterSpacing: 2,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            widget.title,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 23,

                              fontWeight: FontWeight.w900,

                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                /// ==========================================
                /// ACTION + TIMER
                /// ==========================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// ==========================================
                    /// BUTTON
                    /// ==========================================
                    ElevatedButton(
                      onPressed: () {
                        /// 🔥 déjà inscrit
                        if (widget.alreadyRegistered) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,

                              backgroundColor: Colors.orange,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),

                              content: Text(l10n.alreadyRegisteredCollection),
                            ),
                          );

                          return;
                        }

                        widget.onTap?.call();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,

                        foregroundColor: const Color(0xFF1A237E),

                        elevation: 0,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),

                        minimumSize: Size.zero,

                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: Text(
                        widget.alreadyRegistered
                            ? l10n.registered
                            : l10n.registerAction,

                        style: const TextStyle(
                          fontWeight: FontWeight.w800,

                          fontSize: 13,
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// ==========================================
                    /// SMALL TIMER
                    /// ==========================================
                    Row(
                      children: [
                        _miniTime(remaining.inDays, l10n.daysShort),

                        const SizedBox(width: 6),

                        _miniTime(remaining.inHours % 24, l10n.hoursShort),

                        const SizedBox(width: 6),

                        _miniTime(remaining.inMinutes % 60, l10n.minutesShort),

                        const SizedBox(width: 6),

                        _miniTime(remaining.inSeconds % 60, l10n.secondsShort),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// ==========================================
                /// LOCATION
                /// ==========================================
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,

                      color: Colors.white70,

                      size: 18,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        widget.location,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.white70,

                          fontSize: 14,

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ==========================================
                /// DATE
                /// ==========================================
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,

                      color: Colors.white70,

                      size: 18,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      '${widget.date.day}/${widget.date.month}/${widget.date.year}',

                      style: const TextStyle(
                        color: Colors.white70,

                        fontSize: 14,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                /// ==========================================
                /// PARTICIPANTS
                /// ==========================================
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 38,

                      child: Stack(
                        children: [
                          _avatar(0),

                          _avatar(20),

                          _avatar(40),

                          _avatar(60),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        '${widget.participants} ${l10n.registeredPlural}',

                        style: const TextStyle(
                          color: Colors.white,

                          fontWeight: FontWeight.w700,

                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(double size, double opacity) {
    return Container(
      height: size,
      width: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _miniTime(int value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),

            style: const TextStyle(
              color: Colors.white,

              fontWeight: FontWeight.w900,

              fontSize: 13,
            ),
          ),

          Text(
            label,

            style: const TextStyle(
              color: Colors.white70,

              fontWeight: FontWeight.w700,

              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(double left) {
    return Positioned(
      left: left,

      child: Container(
        height: 36,
        width: 36,

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),

          border: Border.all(color: Colors.white, width: 2),

          shape: BoxShape.circle,
        ),

        child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}
