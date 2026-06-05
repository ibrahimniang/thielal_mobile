import 'package:flutter/material.dart';

class InformationTicker extends StatefulWidget {
  final String text;

  const InformationTicker({
    super.key,
    required this.text,
  });

  @override
  State<InformationTicker> createState() =>
      _InformationTickerState();
}

class _InformationTickerState
    extends State<InformationTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _textWidth = 0;

  double _screenWidth = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,

      duration: const Duration(
        seconds: 30,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _calculateTextWidth(
    BuildContext context,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,

        style: const TextStyle(
          fontSize: 14,

          fontWeight: FontWeight.w600,

          letterSpacing: 0.2,
        ),
      ),

      maxLines: 1,

      textDirection: TextDirection.ltr,
    )..layout();

    _textWidth = textPainter.width;

    _screenWidth =
        MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    _calculateTextWidth(context);

    return Container(
      height: 56,

      width: double.infinity,

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [
            Color(0xFFE53946),
            Color(0xFFC1121F),
          ],
        ),

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFE53946,
            ).withOpacity(0.25),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(22),

        child: Row(
          children: [
            /// =====================================
            /// LIVE ICON
            /// =====================================
            Container(
              width: 54,

              height: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  0.10,
                ),
              ),

              child: const Center(
                child: Icon(
                  Icons.graphic_eq_rounded,

                  color: Colors.white,

                  size: 24,
                ),
              ),
            ),

            /// =====================================
            /// TEXT TICKER
            /// =====================================
            Expanded(
              child: ClipRect(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: AnimatedBuilder(
                    animation: _controller,

                    builder:
                        (context, child) {
                      /// distance totale
                      final totalDistance =
                          _textWidth +
                              _screenWidth;

                      /// animation fluide
                      final animationValue =
                          totalDistance *
                              _controller.value;

                      return Transform.translate(
                        offset: Offset(
                          _screenWidth -
                              animationValue,

                          0,
                        ),

                        child: child,
                      );
                    },

                    child: Align(
                      alignment:
                          Alignment.centerLeft,

                      child: Text(
                        widget.text,

                        maxLines: 1,

                        softWrap: false,

                        overflow:
                            TextOverflow.visible,

                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 14,

                          fontWeight:
                              FontWeight.w600,

                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
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