import 'package:flutter/material.dart';

class Circle extends CustomPainter {
  final Offset center;
  final double radius;
  final Paint _paint;
  final int _targetIndex;

  Circle(this.center, this.radius, this._targetIndex)
      : _paint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return _targetIndex == (oldDelegate as Circle)._targetIndex;
  }
}
