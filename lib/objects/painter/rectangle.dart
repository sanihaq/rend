import 'package:flutter/material.dart';
import 'package:rend/objects/base_object.dart';

class RectanglePainter extends CustomPainter {
  final BaseObject object;

  RectanglePainter({required this.object});

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the center of the rectangle
    var rectCenter = Offset(object.width / 2, object.height / 2);

    // Draw the rectangle
    canvas.drawRect(
      Rect.fromCenter(
        center: rectCenter,
        width: object.width,
        height: object.height,
      ),
      Paint()
        ..color = object.fills.firstOrNull ?? Colors.transparent
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant RectanglePainter oldDelegate) =>
      object != oldDelegate.object;
}