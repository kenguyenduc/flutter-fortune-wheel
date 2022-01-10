import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelHistoryPage extends StatelessWidget {
  const FortuneWheelHistoryPage({Key? key, required this.resultsHistory})
      : super(key: key);

  final List<Fortune> resultsHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Lịch sử kết quả quay')),
      body: ListView.separated(
        itemCount: resultsHistory.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Text(
            resultsHistory[index].titleName,
            style: const TextStyle(fontSize: 16),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
