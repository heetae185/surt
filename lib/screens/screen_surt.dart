import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surt/provider/participants.dart';

class SurtScreen extends StatefulWidget {
  const SurtScreen({super.key});

  @override
  State<SurtScreen> createState() => _SurtScreenState();
}

class _SurtScreenState extends State<SurtScreen> {
  late Participants _participants;
  final List<Offset> _circlePositions = [];
  int _targetIndex = -1;
  final int _circleNum = 50;
  final double _smallCircleSizeRatio = 0.03;
  final double _bigCircleSizeRatio = 0.04;

  void _generateRandomCircles() {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);

    _circlePositions.clear();
    for (int i = 0; i < _circleNum; i++) {
      while (true) {
        bool overlapping = false;
        final double x = Random().nextDouble() *
                MediaQuery.of(context).size.width *
                (1 - _bigCircleSizeRatio) +
            MediaQuery.of(context).size.width * _bigCircleSizeRatio / 2;
        final double y = Random().nextDouble() *
                MediaQuery.of(context).size.height *
                (1 - _bigCircleSizeRatio) +
            MediaQuery.of(context).size.height * _bigCircleSizeRatio / 2;
        for (int j = 0; j < _circlePositions.length; j++) {
          double distance = sqrt(
            pow(x - _circlePositions[j].dx, 2) +
                pow(y - _circlePositions[j].dy, 2),
          );
          if (distance <
              MediaQuery.of(context).size.width * _bigCircleSizeRatio) {
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
    _participants = Provider.of<Participants>(context);
    double smallCircleRadius =
        MediaQuery.of(context).size.width * _smallCircleSizeRatio / 2;
    double bigCircleRadius =
        MediaQuery.of(context).size.width * _bigCircleSizeRatio / 2;
    double targetCircleX = _circlePositions[_targetIndex].dx;
    double targetCircleY = _circlePositions[_targetIndex].dy;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          for (int i = 0; i < _circleNum; i++)
            CustomPaint(
              painter: Circle(
                  _circlePositions[i],
                  i == _targetIndex ? bigCircleRadius : smallCircleRadius,
                  _targetIndex),
              size: Size(
                  i == _targetIndex ? bigCircleRadius : smallCircleRadius,
                  i == _targetIndex ? bigCircleRadius : smallCircleRadius),
              child: GestureDetector(
                onTap: () => setState(() {
                  _generateRandomCircles();
                  _participants.addCount();
                }),
              ),
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
