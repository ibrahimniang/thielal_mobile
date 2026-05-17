import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

import '../../donors/data/models/nearby_donor_model.dart';

class NearbyDonorCard
    extends StatelessWidget {
  final NearbyDonorModel donor;

  /// 🔥 ouvrir chat
  final VoidCallback?
      onMessageTap;

  /// 🔥 appel direct
  final VoidCallback?
      onCallTap;

  const NearbyDonorCard({
    super.key,
    required this.donor,
    this.onMessageTap,
    this.onCallTap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    /// =====================================
    /// AVATAR LETTER
    /// =====================================

    final letter =
        donor.prenom != null &&
            donor.prenom!
                .trim()
                .isNotEmpty
        ? donor.prenom!
            .trim()[0]
            .toUpperCase()
        : '?';

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 240,
      ),

      margin:
          const EdgeInsets.only(
            bottom: 16,
          ),

      padding:
          const EdgeInsets.all(
            18,
          ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
              28,
            ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(
                  0.05,
                ),

            blurRadius: 24,

            offset:
                const Offset(
                  0,
                  12,
                ),
          ),
        ],
      ),

      child: Column(
        children: [
          /// =================================
          /// TOP SECTION
          /// =================================

          Row(
            children: [
              /// ==========================
              /// PREMIUM AVATAR
              /// ==========================

              Container(
                height: 64,
                width: 64,

                decoration:
                    BoxDecoration(
                      gradient:
                          LinearGradient(
                            colors: [
                              AppColors
                                  .primaryRed
                                  .withOpacity(
                                    0.18,
                                  ),

                              AppColors
                                  .primaryRed
                                  .withOpacity(
                                    0.06,
                                  ),
                            ],
                          ),

                      borderRadius:
                          BorderRadius.circular(
                            22,
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

                          fontSize:
                              28,
                        ),
                  ),
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              /// ==========================
              /// USER INFOS
              /// ==========================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    /// NAME
                    Text(
                      donor.fullName,

                      maxLines: 1,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          const TextStyle(
                            fontSize:
                                17,

                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    /// BLOOD GROUP
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                                12,

                            vertical:
                                6,
                          ),

                      decoration:
                          BoxDecoration(
                            color:
                                AppColors
                                    .primaryRed
                                    .withOpacity(
                                      0.08,
                                    ),

                            borderRadius:
                                BorderRadius.circular(
                                  40,
                                ),
                          ),

                      child: Text(
                        donor.groupeSanguin ??
                            '--',

                        style:
                            const TextStyle(
                              color:
                                  AppColors
                                      .primaryRed,

                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    /// PHONE
                    Row(
                      children: [
                        Icon(
                          Icons
                              .phone_rounded,

                          size: 16,

                          color:
                              Colors
                                  .grey[600],
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Expanded(
                          child: Text(
                            donor.telephone ??
                                '--',

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                TextStyle(
                                  color:
                                      Colors.grey[
                                          700],

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          /// =================================
          /// BOTTOM SECTION
          /// =================================

          Row(
            children: [
              /// ==========================
              /// DISTANCE
              /// ==========================

              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal:
                            14,

                        vertical:
                            12,
                      ),

                  decoration:
                      BoxDecoration(
                        color:
                            Colors.grey
                                .withOpacity(
                                  0.06,
                                ),

                        borderRadius:
                            BorderRadius.circular(
                              18,
                            ),
                      ),

                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .location_on_rounded,

                        color:
                            Colors
                                .grey[700],

                        size: 18,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Text(
                        '${donor.distance} km',

                        style:
                            TextStyle(
                              color:
                                  Colors
                                      .grey[800],

                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              /// ==========================
              /// CALL BUTTON
              /// ==========================

              GestureDetector(
                onTap:
                    onCallTap,

                child: Container(
                  height: 54,
                  width: 54,

                  decoration:
                      BoxDecoration(
                        color:
                            Colors.green,

                        borderRadius:
                            BorderRadius.circular(
                              18,
                            ),
                      ),

                  child: const Icon(
                    Icons.call_rounded,

                    color:
                        Colors.white,
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              /// ==========================
              /// CHAT BUTTON
              /// ==========================

              GestureDetector(
                onTap:
                    onMessageTap,

                child: Container(
                  height: 54,
                  width: 54,

                  decoration:
                      BoxDecoration(
                        color:
                            AppColors
                                .primaryRed,

                        borderRadius:
                            BorderRadius.circular(
                              18,
                            ),
                      ),

                  child: const Icon(
                    Icons
                        .chat_bubble_rounded,

                    color:
                        Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}