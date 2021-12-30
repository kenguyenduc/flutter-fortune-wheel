import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    title: 'Example',
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///Hệ số ưu tiên
  int numberBonusPriority = 1;

  final List<FortuneItem> _fortuneValues = <FortuneItem>[
    FortuneItem('1', Colors.accents[0], icon: const Icon(Icons.person_sharp)),
    FortuneItem('2', Colors.accents[2], icon: const Icon(Icons.favorite)),
    FortuneItem('3', Colors.accents[4], icon: const Icon(Icons.star)),
    FortuneItem('4', Colors.accents[6]),
    FortuneItem('5', Colors.accents[8]),
    FortuneItem('6', Colors.accents[10]),
    FortuneItem('7', Colors.accents[12]),
    FortuneItem('8', Colors.accents[14]),
    FortuneItem('9', Colors.accents[15]),
    FortuneItem('10', Colors.accents[3]),
    FortuneItem('11', Colors.accents[5]),
    FortuneItem('12', Colors.accents[7]),
  ];
  final List<FortuneItem> _listPrioty = <FortuneItem>[
    FortuneItem('1', Colors.accents[0], priority: 1),
    FortuneItem('2', Colors.accents[2], priority: 5),
    FortuneItem('3', Colors.accents[4], priority: 2),
    FortuneItem('4', Colors.accents[6], priority: 2),
    FortuneItem('5', Colors.accents[8], priority: 1),
  ];

  final List<FortuneItem> _anNhau = <FortuneItem>[
    FortuneItem('Uống 0.5 ly', Colors.accents[14],
        icon: const Icon(Icons.person_sharp)),
    FortuneItem('Bên trái uống 1 ly', Colors.accents[2],
        icon: const Icon(Icons.favorite)),
    FortuneItem('Qua tua', Colors.accents[4], icon: const Icon(Icons.star)),
    FortuneItem('Chỉ ai đó bất kỳ uống', Colors.accents[6],
        icon: const Icon(Icons.stream)),
    FortuneItem('Quay lại', Colors.accents[8], icon: const Icon(Icons.build)),
    FortuneItem('Được ăn mồi', Colors.accents[10],
        icon: const Icon(Icons.phone_android_outlined)),
    FortuneItem('Uống 2 ly', Colors.accents[12],
        icon: const Icon(Icons.extension)),
    FortuneItem(
        'Uống 2 ly test chuỗi dài dài dài dài dài dài dài', Colors.green,
        icon: const Icon(Icons.message)),
  ];

  final StreamController<FortuneItem> _resultWheelController =
      StreamController<FortuneItem>.broadcast();

  final List<FortuneItem> _resultsHistory = <FortuneItem>[];
  final StreamController<List<FortuneItem>> _resultsHistoryController =
      StreamController<List<FortuneItem>>.broadcast();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vòng quay may mắn'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FortunerWheel(
                  items: _listPrioty,
                  onChanged: (FortuneItem item) {
                    _resultWheelController.add(item);
                  },
                  onResult: (FortuneItem item) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Test'),
                          content: Text('Result: ${item.value}'),
                        );
                      },
                    );
                    _resultsHistory.add(item);
                    _resultsHistoryController.add(_resultsHistory);
                  },
                ),
                _buildResult(),
                _buildResultsHistory(),
                const RoulettePageWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    return StreamBuilder<FortuneItem>(
      stream: _resultWheelController.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                snapshot.data!.value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildResultsHistory() {
    return StreamBuilder<List<FortuneItem>>(
      stream: _resultsHistoryController.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _resultsHistory.length,
            itemBuilder: (context, index) {
              return Text('${index + 1}: ${_resultsHistory[index].value}');
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class RoulettePageWidget extends StatefulWidget {
  const RoulettePageWidget({Key? key}) : super(key: key);

  @override
  _RoulettePageWidgetState createState() => _RoulettePageWidgetState();
}

class _RoulettePageWidgetState extends State<RoulettePageWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late Tween<double> _tween;
  late AnimationController _animationController;
  final Random _random = Random();

  int position = 0;

  double getRandomAngle() {
    return pi * 2 / 25 * _random.nextInt(25);
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _tween = Tween(begin: 0.0, end: getRandomAngle());
    _animation = _tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  void setNewPosition() {
    _tween.begin = _tween.end;
    _animationController.reset();
    _tween.end = getRandomAngle();
    _animationController.forward();
  }

  Future<void> _gameLoop() async {
    _animationController.forward();
    _tween.begin = _tween.end;
    _animationController.reset();
    _tween.end = _tween.end??0 + pi * 2 + 100;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child: Transform.rotate(
          angle: _animation.value,
          child: const Icon(
            Icons.arrow_upward,
            size: 100.0,
          ),
        )),
        TextButton(
          child: const Text('SPIN'),
          onPressed: setNewPosition,
        ),
        ElevatedButton(
          child: const Text('SPIN180'),
          onPressed: () {
            // _tween.begin = _tween.end;
            // _animationController.reset();
            // _tween.end = pi/2;
            _animationController.forward(from: 0.0).then((value) {
              _tween.begin = _tween.end;
              _animationController.reset();
            });
          },
        ),
        ElevatedButton(
          child: Text('SPIN360'),
          onPressed: () {
            _gameLoop();
          },
        )
      ],
    );
  }
}
