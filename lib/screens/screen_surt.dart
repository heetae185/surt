import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class SurtScreen extends StatefulWidget {
  const SurtScreen({super.key});

  @override
  State<SurtScreen> createState() => _SurtScreenState();
}

class _SurtScreenState extends State<SurtScreen> {
  final List<Offset> _circlePositions = [];
  int _targetIndex = -1;
  final int _circleNum = 4;
  final double _smallCircleWidthRatio = 0.04;
  final double _bigCircleWidthRatio = 0.05;

  void _generateRandomCircles() {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);

    _circlePositions.clear();
    for (int i = 0; i < _circleNum; i++) {
      int try_ = 0;
      print("i : ${i} Try : ${try_}");
      while (true) {
        try_ += 1;
        print("i : ${i} Try : ${try_}");
        bool overlapping = false;
        final double x = Random().nextDouble() *
                MediaQuery.of(context).size.width *
                (1 - _bigCircleWidthRatio) +
            MediaQuery.of(context).size.width * _bigCircleWidthRatio / 2;
        final double y = Random().nextDouble() *
                MediaQuery.of(context).size.height *
                (1 - _bigCircleWidthRatio) +
            MediaQuery.of(context).size.height * _bigCircleWidthRatio / 2;
        for (int j = 0; j < _circlePositions.length; j++) {
          double distance = sqrt(
            pow(x - _circlePositions[j].dx, 2) +
                pow(y - _circlePositions[j].dy, 2),
          );
          if (distance <
              MediaQuery.of(context).size.width * _bigCircleWidthRatio) {
            overlapping = true;
            break;
          }
        }
        if (!overlapping) {
          _circlePositions.add(Offset(x, y));
          break;
        }
      }
    }
    print(_circlePositions);
    _targetIndex = Random().nextInt(_circleNum);
    print(_targetIndex);
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateRandomCircles();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    double smallCircleRadius =
        MediaQuery.of(context).size.width * _smallCircleWidthRatio / 2;
    double bigCircleRadius =
        MediaQuery.of(context).size.width * _bigCircleWidthRatio / 2;
    double targetCircleX = _circlePositions[_targetIndex].dx;
    double targetCircleY = _circlePositions[_targetIndex].dy;
    return Scaffold(
      body: Stack(
        children: [
          for (int i = 0; i < _circleNum; i++)
            CustomPaint(
              painter: Circle(_circlePositions[i],
                  i == _targetIndex ? bigCircleRadius : smallCircleRadius),
              size: Size(
                  i == _targetIndex ? bigCircleRadius : smallCircleRadius,
                  i == _targetIndex ? bigCircleRadius : smallCircleRadius),
            ),
          GestureDetector(
            onTapDown: (detail) {
              double touchX = detail.localPosition.dx;
              double touchY = detail.localPosition.dy;
              print("${touchX} / ${targetCircleX}");
              print("${touchY} / ${targetCircleY}");
              if ((touchX > targetCircleX - bigCircleRadius &&
                  touchX < targetCircleX + bigCircleRadius &&
                  touchY > targetCircleY - bigCircleRadius &&
                  touchY < targetCircleY + bigCircleRadius)) {
                setState(() {
                  _generateRandomCircles();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class Circle extends CustomPainter {
  final Offset center;
  final double radius;
  final Paint _paint;

  Circle(this.center, this.radius)
      : _paint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
