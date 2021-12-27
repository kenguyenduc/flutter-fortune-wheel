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
          child: FortunerWheel(
            items: <Luck>[
              Luck(1, Colors.accents[0]),
              Luck(2, Colors.accents[2]),
              Luck(3, Colors.accents[4]),
              Luck(4, Colors.accents[6]),
              Luck(5, Colors.accents[8]),
              Luck(6, Colors.accents[10]),
              Luck(7, Colors.accents[12]),
              Luck(8, Colors.accents[14]),
              Luck(9, Colors.accents[15]),
              Luck(10, Colors.accents[3]),
              Luck(11, Colors.accents[5]),
              Luck(12, Colors.accents[7]),
            ],
            onChanged: (luck) {},
          ),
        ),
      ),
    );
  }
}
