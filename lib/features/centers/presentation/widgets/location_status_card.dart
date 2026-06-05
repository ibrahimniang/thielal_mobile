import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';

class LocationStatusCard
    extends StatelessWidget {
  final String locationName;

  const LocationStatusCard({
    super.key,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),

      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.96),

        borderRadius:
            BorderRadius.circular(
              AppRadius.xl,
            ),

        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.06),

            blurRadius: 18,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          /// =========================
          /// LOCATION ICON
          /// =========================
          Container(
            height: 42,

            width: 42,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient:
                  LinearGradient(
                    begin:
                        Alignment.topLeft,

                    end:
                        Alignment
                            .bottomRight,

                    colors: [
                      Colors.green
                          .withOpacity(
                            0.18,
                          ),

                      Colors.green
                          .withOpacity(
                            0.08,
                          ),
                    ],
                  ),
            ),

            child: const Icon(
              Icons.gps_fixed_rounded,

              color: Colors.green,

              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          /// =========================
          /// TEXTS
          /// =========================
          Expanded(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                /// TITLE
                const Text(
                  'Position active',

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style: TextStyle(
                    fontWeight:
                        FontWeight
                            .w800,

                    fontSize: 13,

                    color:
                        AppColors
                            .textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                /// LOCATION
                Text(
                  locationName,

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style: const TextStyle(
                    color:
                        AppColors
                            .textSecondary,

                    fontSize: 12,

                    fontWeight:
                        FontWeight
                            .w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// =========================
          /// LIVE DOT
          /// =========================
          Container(
            height: 10,

            width: 10,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.green,

              boxShadow: [
                BoxShadow(
                  color: Colors.green
                      .withOpacity(
                        0.45,
                      ),

                  blurRadius: 10,

                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}