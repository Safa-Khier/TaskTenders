import 'dart:math';

import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final String? title;

  const LoadingScreen({super.key, this.title});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  // Animation Controller and Color Animation for the leading dot
  late AnimationController _leadingPulseController;
  late Animation<Color?> _leadingColorAnimation;

  // Animation Controller and Color Animation for the trailing dot
  late AnimationController _trailingPulseController;
  late Animation<Color?> _trailingColorAnimation;

  @override
  void initState() {
    super.initState();

    _leadingPulseController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _trailingPulseController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _leadingColorAnimation = ColorTween(
      begin: const Color(0xFF00CED1),
      end: const Color(0xFFFFFFFF),
    ).animate(_leadingPulseController);

    _trailingColorAnimation = ColorTween(
      begin: const Color(0xFF00CED1),
      end: const Color(0xFFFFFFFF),
    ).animate(_trailingPulseController);

    _setupAlternatingAnimations();
  }

  @override
  void dispose() {
    // Dispose the animation controllers to stop them from ticking
    _leadingPulseController.dispose();
    _trailingPulseController.dispose();
    super.dispose();
  }

  void _setupAlternatingAnimations() {
    // Listen to _pulseController1
    _leadingPulseController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _leadingPulseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _trailingPulseController.forward();
      }
    });

    // Listen to _pulseController2
    _trailingPulseController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _trailingPulseController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _leadingPulseController.forward();
      }
    });
    _leadingPulseController.forward();
  }

  Widget _buildIndicator(
      BuildContext context, Widget indicator, String? title) {
    return Center(
        child: SizedBox(
            height: 50,
            child: Column(
              children: [
                indicator,
                const SizedBox(height: 10),
                title != null
                    ? Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none))
                    : Container(),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    // return _buildIndicator(
    //   context,
    //   const SizedBox(
    //     width: 50,
    //     child: LinearProgressIndicator(
    //       borderRadius: BorderRadius.all(Radius.circular(10)),
    //     ),
    //   ),
    //   widget.title,
    // );

    return _buildIndicator(
      context,
      Row(mainAxisSize: MainAxisSize.min, children: [
        AnimatedBuilder(
          animation: _leadingPulseController,
          builder: (context, child) {
            double sinBounce =
                sin(((_leadingPulseController.value) * 3.14 / 2));
            // double cosBounce =
            //     cos(((_leadingPulseController.value) * 3.14 / 2));

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: Transform.translate(
                offset: Offset(
                  -(sinBounce * 10).abs(),
                  0,
                  // (cosBounce * 10).abs() - 10,
                ),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _leadingColorAnimation.value,
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF00CED1),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF00CED1),
          ),
        ),
        AnimatedBuilder(
          animation: _trailingPulseController,
          builder: (context, child) {
            double sinBounce = sin((_trailingPulseController.value * 3.14 / 2));
            // double cosBounce = cos((_trailingPulseController.value * 3.14) / 2);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: Transform.translate(
                offset: Offset(
                  (sinBounce * 10).abs(),
                  0,
                  // (cosBounce * 10).abs() - 10,
                ),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _trailingColorAnimation.value,
                  ),
                ),
              ),
            );
          },
        ),
      ]),
      widget.title,
    );
    // return _buildIndicator(
    //   context,
    //   Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: List.generate(3, (index) {
    //       return AnimatedBuilder(
    //         animation: _pulseController,
    //         builder: (context, child) {
    //           double bounce =
    //               sin((_pulseController.value * 3.14) + (index * 1.0));
    //           return Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 2),
    //             child: Transform.translate(
    //               offset: Offset(0, -bounce * 8),
    //               child: Container(
    //                 height: 8,
    //                 width: 8,
    //                 decoration: const BoxDecoration(
    //                   color: Colors.blue,
    //                   shape: BoxShape.circle,
    //                 ),
    //               ),
    //             ),
    //           );
    //         },
    //       );
    //     }),
    //   ),
    //   "Bounce",
    // );

    // return _buildIndicator(
    //   context,
    //   Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: List.generate(3, (index) {
    //       return AnimatedBuilder(
    //         animation: _pulseController,
    //         builder: (context, child) {
    //           return Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 4),
    //             width: 10,
    //             height: 10,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: baseColors[
    //                   (index + (_pulseController.value * 10).toInt()) %
    //                       baseColors.length],
    //             ),
    //           );
    //         },
    //       );
    //     }),
    //   ),
    //   widget.title,
    // );
  }
}
