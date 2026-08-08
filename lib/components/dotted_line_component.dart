import 'package:flutter/material.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';

class DottedLineWithIcons extends StatelessWidget {
  final bool isOrderTaken;
  final String distance;

  const DottedLineWithIcons(
      {super.key, required this.isOrderTaken, required this.distance});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double availableWidth = constraints.maxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: swipeBtnBgColor,
              shape: BoxShape.circle,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(availableWidth - 24, 2),
                painter: DottedLinePainter(),
              ),
              if (isOrderTaken)
                Positioned(
                  top: -16,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 14,
                      ),
                      Text(
                        distance,
                        style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: swipeBtnBgColor),
                      )
                    ],
                  ),
                )
            ],
          ),
          if (isOrderTaken)
            const Icon(
              Icons.arrow_right,
              color: swipeBtnBgColor,
              size: 18,
            ),
        ],
      );
    });
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 5;
    double dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
