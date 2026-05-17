import 'package:flutter/material.dart';

class InformationTicker
    extends StatefulWidget {

  final String text;

  const InformationTicker({
    super.key,
    required this.text,
  });

  @override
  State<InformationTicker>
      createState() =>
          _InformationTickerState();
}

class _InformationTickerState
    extends State<InformationTicker>
    with SingleTickerProviderStateMixin {

  late final AnimationController
      _controller;

  late final Animation<double>
      _animation;

  @override
  void initState() {
    super.initState();

    /// 🔥 animation fluide
    _controller =
        AnimationController(
          vsync: this,

          duration:
              const Duration(
                seconds: 10,
              ),
        )..repeat();

    _animation =
        Tween<double>(
          begin: 1,
          end: -1.4,
        ).animate(
          CurvedAnimation(
            parent:
                _controller,

            curve:
                Curves.linear,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {

    final screenWidth =
        MediaQuery.of(
          context,
        ).size.width;

    return Container(
      height: 62,

      margin:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),

      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
              begin:
                  Alignment.topLeft,

              end:
                  Alignment.bottomRight,

              colors: [
                Color(
                  0xFF162B69,
                ),

                Color(
                  0xFF162B69,
                ),
              ],
            ),

        borderRadius:
            BorderRadius.circular(
              30,
            ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
                      0.12,
                    ),

            blurRadius: 18,

            offset:
                const Offset(
                  0,
                  10,
                ),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(
              30,
            ),

        child: Row(
          children: [

            /// =====================================
            /// ICON HEART
            /// =====================================

            const Padding(
              padding:
                  EdgeInsets.only(
                    left: 18,
                    right: 14,
                  ),

              child: Text(
                '',

                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),

            /// =====================================
            /// TEXT ANIMATION
            /// =====================================

            Expanded(
              child:
                  AnimatedBuilder(
                    animation:
                        _animation,

                    builder:
                        (
                          context,
                          child,
                        ) {

                      return Transform.translate(
                        offset: Offset(
                          _animation.value *
                              screenWidth,

                          0,
                        ),

                        child:
                            child,
                      );
                    },

                    child: Text(
                      widget.text,

                      maxLines: 1,

                      overflow:
                          TextOverflow
                              .visible,

                      style:
                          const TextStyle(
                            color:
                                Colors.white,

                            fontSize:
                                16,

                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}