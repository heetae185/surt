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
  final double _statusColumnRatio = 0.05;
  final double _smallCircleSizeRatio = 0.03;
  final double _bigCircleSizeRatio = 0.04;

  void _generateRandomCircles() {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);

    _circlePositions.clear();
    for (int i = 0; i < _circleNum; i++) {
      while (true) {
        bool overlapping = false;

        // x, y cordinates for the center of circles are randomly selected ((0 + circle radius) ~ (MediaQuery size - circle radius))
        final double x = Random().nextDouble() *
                MediaQuery.of(context).size.width *
                (1 - (_bigCircleSizeRatio + _statusColumnRatio)) +
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
    double statusColumnWidth =
        MediaQuery.of(context).size.width * _statusColumnRatio;
    double smallCircleRadius =
        MediaQuery.of(context).size.width * _smallCircleSizeRatio / 2;
    double bigCircleRadius =
        MediaQuery.of(context).size.width * _bigCircleSizeRatio / 2;
    double targetCircleX = _circlePositions[_targetIndex].dx;
    double targetCircleY = _circlePositions[_targetIndex].dy;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * (1 - _statusColumnRatio),
            child: Stack(
              children: [
                for (int i = 0; i < _circleNum; i++)
                  CustomPaint(
                    painter: Circle(
                        _circlePositions[i],
                        i == _targetIndex ? bigCircleRadius : smallCircleRadius,
                        _targetIndex),
                    size: Size(
                        i == _targetIndex ? bigCircleRadius : smallCircleRadius,
                        i == _targetIndex
                            ? bigCircleRadius
                            : smallCircleRadius),
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
                      _participants.addCount();
                      setState(() {
                        _generateRandomCircles();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: statusColumnWidth,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text("저장하시겠습니까?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      _participants.resetState();
                                      Navigator.pushNamed(context, '/');
                                    },
                                    child: const Text("네")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                    child: const Text("아니오"))
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: statusColumnWidth * 0.8,
                      height: statusColumnWidth * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  )
                ],
              ),
            ),
          )
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
