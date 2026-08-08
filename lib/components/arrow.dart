import 'package:flutter/material.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';

class ArrowAnimation extends StatefulWidget {
  final bool isAnimationActive;

  const ArrowAnimation({super.key, required this.isAnimationActive});

  @override
  ArrowAnimationState createState() => ArrowAnimationState();
}

class ArrowAnimationState extends State<ArrowAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _opacities;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (widget.isAnimationActive) {
              _controllers[index].reverse();
            }
          } else if (status == AnimationStatus.dismissed) {
            if (widget.isAnimationActive) {
              _controllers[index].forward();
            }
          }
        });
    });

    _opacities = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ),
      );
    });

    if (widget.isAnimationActive) {
      _startSequentialAnimation();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startSequentialAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 * i));
      if (widget.isAnimationActive) {
        if (mounted) {
          _controllers[i].forward();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SizedBox(
        width: 50,
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 2,
              child: AnimatedBuilder(
                animation: _controllers[0],
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacities[0].value,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: swipeBtnBgColor,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 14,
              child: AnimatedBuilder(
                animation: _controllers[1],
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacities[1].value,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: swipeBtnBgColor,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 26,
              child: AnimatedBuilder(
                animation: _controllers[2],
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacities[2].value,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: swipeBtnBgColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
