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
  final int _circleNum = 10;
  final double _smallCircleWidthRatio = 0.04;
  final double _bigCircleWidthRatio = 0.05;

  void _generateRandomCircles() {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    _circlePositions.clear();
    for (int i = 0; i < _circleNum; i++) {
      final double left = Random().nextDouble() *
          MediaQuery.of(context).size.width *
          (1 - _bigCircleWidthRatio);
      final double top = Random().nextDouble() *
          MediaQuery.of(context).size.height *
          (1 - _bigCircleWidthRatio);
      _circlePositions.add(Offset(left, top));
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
    double smallCircleSize =
        MediaQuery.of(context).size.width * _smallCircleWidthRatio;
    double bigCircleSize =
        MediaQuery.of(context).size.width * _bigCircleWidthRatio;
    return Scaffold(
      body: Stack(
        children: [
          for (int i = 0; i < _circleNum; i++)
            Positioned(
              left: _circlePositions[i].dx,
              top: _circlePositions[i].dy,
              width: i == _targetIndex ? bigCircleSize : smallCircleSize,
              height: i == _targetIndex ? bigCircleSize : smallCircleSize,
              child: GestureDetector(
                onTap: (() => setState(() {
                      if (i == _targetIndex) {
                        _generateRandomCircles();
                      }
                    })),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
