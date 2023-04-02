import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

///Build background painter with animation
///[child] UI
///[painterController] to spin when we call the function [playElementAnimation]
///in the function [BackgroundPainterController]
class FortuneWheelBackground extends StatefulWidget {
  const FortuneWheelBackground(
      {Key? key,
      required this.painterController,
      required this.child,
      this.backgroundColor = const Color(0xff198827),
      this.duration = const Duration(milliseconds: 5000)})
      : super(key: key);

  @override
  _FortuneWheelBackgroundState createState() => _FortuneWheelBackgroundState();

  final BackgroundPainterController? painterController;
  final Widget child;
  final Color backgroundColor;
  final Duration duration;
}

class _FortuneWheelBackgroundState extends State<FortuneWheelBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late BackgroundPainterController _painterController;
  late Animation<double> _rotation;
  final Completer<void> _creatingCompleter = Completer<void>();

  @override
  void initState() {
    _painterController =
        widget.painterController ?? BackgroundPainterController();
    _painterController.reset();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _painterController.addListener(() async {
      if (_painterController.isPlay) {
        if (!_creatingCompleter.isCompleted) {
          _controller.reset();
          _controller.forward();
        }
      }
    });
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.painterController == null) {
      _painterController.dispose();
    }
    _controller.dispose();
    _creatingCompleter.complete();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rotation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rotation = Tween(begin: 0.0, end: 360.0).animate(_rotation);

    return Container(
      color: widget.backgroundColor,
      child: CustomPaint(
        painter: _BackgroundPainter(
          painterController: _painterController,
          rotateAngle: _rotation.value,
          anglePerTriangle: 10,
          numberTriangle: 15,
        ),
        child: widget.child,
      ),
    );
  }
}

///controller điều khiển vòng quay
class BackgroundPainterController extends ChangeNotifier {
  bool isPlay = false;
  bool isInit = false;
  List<Offset> noisePoints = [];
  List<double> noiseSizes = [];

  void reset() {
    noisePoints.clear();
    noiseSizes.clear();
    isInit = false;
  }

  void playAnimation() {
    isPlay = true;
    notifyListeners();
  }
}

///Vẽ background
class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter(
      {required this.anglePerTriangle,
      required this.numberTriangle,
      this.rotateAngle = 0,
      required this.painterController}) {
    painter = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.fill;
  }

  final int numberTriangle;
  final double anglePerTriangle;
  final BackgroundPainterController painterController;
  final double rotateAngle;
  late final Paint painter;

  final int randomNoise = 20;
  final double startRandomNoise = 15;
  final double endRandomNoise = 35;

  double angleToRadian(double angle) {
    return (angle * pi) / 180.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angleToRadian(rotateAngle));
    canvas.translate(-size.width / 2, -size.height / 2);

    final List<int> indices = List<int>.generate(numberTriangle, (i) => i);
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double sizeCircle = size.height / 2 + 100;
    final double radius =
        sqrt(sizeCircle * sizeCircle + sizeCircle * sizeCircle);

    final double spaceBetween =
        (360 - anglePerTriangle * numberTriangle) / numberTriangle;

    final double startAngle = 360 - anglePerTriangle / 2;

    ///draw triangles
    for (final int i in indices) {
      final double angle = startAngle + i * spaceBetween + i * anglePerTriangle;

      final double beginX = centerX + radius * cos(angleToRadian(angle));
      final double beginY = centerY + radius * sin(angleToRadian(angle));

      final double endX =
          centerX + radius * cos(angleToRadian(angle + anglePerTriangle));
      final double endY =
          centerY + radius * sin(angleToRadian(angle + anglePerTriangle));

      final p1 = Offset(centerX, centerY);

      final middle = Offset((beginX + endX) / 2, (endY + beginY) / 2);

      final paint = Paint()
        ..shader = ui.Gradient.linear(p1, middle, [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.0),
        ], <double>[
          0.0,
          0.7
        ]);

      final Path path = Path();
      path.moveTo(centerX, centerY);
      path.lineTo(beginX, beginY);
      path.lineTo(endX, endY);
      path.close();
      canvas.drawPath(path, paint);
    }

    ///draw circle gradient in center
    final Rect rect = Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: size.width,
        height: size.width);

    final gradient = RadialGradient(
      radius: 1,
      colors: [
        Colors.white.withOpacity(0.3),
        Colors.white.withOpacity(0.01),
      ],
      stops: const <double>[0.0, 1],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    if (!painterController.isInit) {
      ///draw random noise small circle gradient
      List<int> randomNoiseList =
          List<int>.generate(randomNoise, (index) => index);
      for (int i = 0; i < randomNoiseList.length; i++) {
        final double randomX = doubleInRange(Random(), 0, size.width);
        final double randomY = doubleInRange(Random(), 0, size.height);
        final double randomSize =
            doubleInRange(Random(), startRandomNoise, endRandomNoise);
        painterController.noisePoints.add(Offset(randomX, randomY));
        painterController.noiseSizes.add(randomSize);
        final Rect randomRect = Rect.fromCenter(
            center: Offset(randomX, randomY),
            width: randomSize,
            height: randomSize);

        final randomGradient = RadialGradient(
          radius: 0.5,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.01),
          ],
          stops: const <double>[0.0, 1.0],
        );
        final randomPaint = Paint()
          ..shader = randomGradient.createShader(randomRect);

        canvas.drawCircle(Offset(randomX, randomY), randomSize, randomPaint);
      }
      painterController.isInit = true;
    } else {
      for (final int i in List<int>.generate(randomNoise, (index) => index)) {
        final Rect randomRect = Rect.fromCenter(
            center: Offset(painterController.noisePoints[i].dx,
                painterController.noisePoints[i].dy),
            width: painterController.noiseSizes[i],
            height: painterController.noiseSizes[i]);

        final randomGradient = RadialGradient(
          radius: 0.5,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.01),
          ],
          stops: const <double>[0.0, 1.0],
        );

        final randomPaint = Paint()
          ..shader = randomGradient.createShader(randomRect);
        canvas.drawRect(randomRect, randomPaint);
      }
    }
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
