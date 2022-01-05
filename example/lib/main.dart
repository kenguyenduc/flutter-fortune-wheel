import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_fortune_wheel_example/fortune_wheel_page.dart';

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
    FortuneItem('2', Colors.accents[2], priority: 10),
    FortuneItem('3', Colors.accents[4], priority: 1),
    FortuneItem('4', Colors.accents[6], priority: 1),
    FortuneItem('5', Colors.accents[8], priority: 1),
    FortuneItem('6', Colors.accents[10], priority: 1),
    FortuneItem('7', Colors.accents[12], priority: 1),
    FortuneItem('8', Colors.accents[14], priority: 1),
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
    const FortuneItem('Bên phải uống 1 ly', Colors.green,
        icon: Icon(Icons.message)),
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
  void dispose() {
    super.dispose();
    _resultsHistoryController.close();
    _resultWheelController.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example 1'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Center(
                child: FortunerWheel(
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
                          contentPadding: const EdgeInsets.all(8),
                          title: const Text(
                            'Xin chúc mừng!',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.value.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Đóng'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    _resultsHistory.add(item);
                    _resultsHistoryController.add(_resultsHistory);
                  },
                  onAnimationEnd: () => print('onAnimationEnd'),
                  onAnimationStart: () => print('onAnimationStart'),
                ),
              ),
              _buildResult(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Danh sách kết quả vòng quay:',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildResultsHistory(),
            ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              return Text(
                'Quay Lần ${index + 1}: ${_resultsHistory[index].value}',
                style: const TextStyle(fontSize: 16),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
