import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelHistoryPage extends StatelessWidget {
  const FortuneWheelHistoryPage({Key? key, required this.resultsHistory})
      : super(key: key);

  final List<Fortune> resultsHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spin history')),
      body: ListView.separated(
        itemCount: resultsHistory.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '--Result ${index + 1}--' +
                    (resultsHistory[index].titleName?.replaceAll('\n', '') ??
                        ''),
                style: const TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: resultsHistory[index].icon ?? const SizedBox(),
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
