import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<FortuneItem> _fortuneValues = <FortuneItem>[
    FortuneItem('1', Colors.accents[0], const Icon(Icons.person_sharp)),
    FortuneItem('2', Colors.accents[2], const Icon(Icons.favorite)),
    FortuneItem('3', Colors.accents[4], const Icon(Icons.star)),
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

  final List<FortuneItem> _anNhau = <FortuneItem>[
    FortuneItem(
        'Uống 0.5 ly', Colors.accents[0], const Icon(Icons.person_sharp)),
    FortuneItem(
        'Bên trái uống 1 ly', Colors.accents[2], const Icon(Icons.favorite)),
    FortuneItem('Qua tua', Colors.accents[4], const Icon(Icons.star)),
    FortuneItem('Chỉ ai đó bất kỳ uống', Colors.accents[6]),
    FortuneItem('Quay lại', Colors.accents[8]),
    FortuneItem('Được ăn mồi', Colors.accents[10]),
    FortuneItem('Uống 2 ly', Colors.accents[12]),
    // FortuneItem('8', Colors.accents[14]),
    // FortuneItem('9', Colors.accents[15]),
  ];

  final StreamController<FortuneItem> _resultWheelController =
      StreamController<FortuneItem>.broadcast();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FortunerWheel(
                items: _anNhau,
                onChanged: (FortuneItem item) {
                  _resultWheelController.add(item);
                },
              ),
              StreamBuilder<FortuneItem>(
                stream: _resultWheelController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return _buildResult(snapshot.data!);
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult(FortuneItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          item.value,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
