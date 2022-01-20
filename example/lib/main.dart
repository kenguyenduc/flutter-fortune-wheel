import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_fortune_wheel_example/common/constants.dart';
import 'package:flutter_fortune_wheel_example/common/theme.dart';
import 'package:flutter_fortune_wheel_example/pages/fortune_wheel_history_page.dart';
import 'package:flutter_fortune_wheel_example/pages/fortune_wheel_setting_page.dart';
import 'package:flutter_fortune_wheel_example/widgets/fortune_wheel_background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const MyApp(),
      title: 'Vòng xoay may mắn',
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StreamController<Fortune> _resultWheelController =
      StreamController<Fortune>.broadcast();

  final List<Fortune> _resultsHistory = <Fortune>[];
  final StreamController<bool> _fortuneWheelController =
      StreamController<bool>.broadcast();

  final BackgroundPainterController _painterController =
      BackgroundPainterController();

  late ConfettiController _confettiController;

  Wheel _wheel = Wheel(
    // items: Constants.icons2,
    items: Constants.liXiNamMoi,
    // items: Constants.list12Item,
    isSpinByPriority: true,
    duration: const Duration(seconds: 10),
  );

  @override
  void initState() {
    super.initState();
    _painterController.playAnimation();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    super.dispose();
    _resultWheelController.close();
    _fortuneWheelController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3DBF8),
      body: Stack(
        children: [
          FortuneWheelBackground(
            painterController: _painterController,
            child: Center(child: _buildFortuneWheel()),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildResultIsChange(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/fortune_wheel_icon.svg',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 16),
            const Text(
              'Vòng xoay may mắn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            IconButton(
              splashRadius: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FortuneWheelHistoryPage(
                      resultsHistory: _resultsHistory,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart, color: Colors.white),
            ),
            IconButton(
              splashRadius: 28,
              onPressed: () async {
                _fortuneWheelController.add(false);
                final Wheel? result = await Navigator.push(
                  context,
                  MaterialPageRoute<Wheel>(
                    builder: (context) =>
                        FortuneWheelSettingPage(wheel: _wheel),
                  ),
                );
                if (result != null) {
                  _wheel = result;
                  _painterController.playAnimation();
                }
                _resultWheelController.sink.add(_wheel.items[0]);
                _fortuneWheelController.add(true);
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneWheel() {
    return Center(
      child: StreamBuilder<bool>(
        stream: _fortuneWheelController.stream,
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return const SizedBox.shrink();
          }
          return FortuneWheel(
            key: const ValueKey<String>('ValueKeyFortunerWheel'),
            wheel: _wheel,
            onChanged: (Fortune item) {
              _resultWheelController.sink.add(item);
            },
            onResult: _onResult,
          );
        },
      ),
    );
  }

  ///UI hiển thị kết quả vòng quay
  Future<void> _onResult(Fortune item) async {
    _confettiController.play();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  // don't specify a direction, blast randomly
                  // shouldLoop: true,
                  // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Colors.yellowAccent,
                  ],
                  // manually specify the colors to be used
                  createParticlePath: _drawStar, // define a custom shape/path.
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: 200,
                width: double.infinity,
                child: Lottie.asset(
                  'assets/cong_example.json',
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Bạn đã quay vào ô: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: item.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          item.titleName?.replaceAll('\n', '') ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: item.icon ?? const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _confettiController.stop();
                    Navigator.pop(context);
                    _painterController.playAnimation();
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    _resultsHistory.add(item);
  }

  Widget _buildResultIsChange() {
    return StreamBuilder<Fortune>(
      stream: _resultWheelController.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AutoSizeText(
                  snapshot.data != null
                      ? snapshot.data!.titleName?.replaceAll('\n', '') ?? ''
                      : _wheel.items[0].titleName?.replaceAll('\n', '') ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: snapshot.data != null
                    ? snapshot.data!.icon ?? const SizedBox()
                    : _wheel.items[0].icon ?? const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// A custom Path to paint stars.
  Path _drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
