import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_fortune_wheel_example/common/constants.dart';
import 'package:flutter_fortune_wheel_example/pages/fortune_wheel_history_page.dart';
import 'package:flutter_fortune_wheel_example/pages/fortune_wheel_setting_page.dart';
import 'package:flutter_fortune_wheel_example/models/wheel.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    title: 'Vòng xoay may mắn',
  ));
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

  Wheel _wheel = Wheel(
    fortuneValues: Constants.todayWhatDoEat,
    isGoByPriority: false,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _resultWheelController.close();
    _fortuneWheelController.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Vòng xoay may mắn'),
          actions: [
            IconButton(
              splashRadius: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FortuneWheelHistoryPage(
                        resultsHistory: _resultsHistory),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart),
            ),
            IconButton(
              splashRadius: 28,
              onPressed: () async {
                final Wheel? result = await Navigator.push(
                  context,
                  MaterialPageRoute<Wheel>(
                    builder: (context) =>
                        FortuneWheelSettingPage(wheel: _wheel),
                  ),
                );
                if (result != null) {
                  _wheel = result;
                  _fortuneWheelController.sink.add(true);
                }
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _buildFortuneWheel(),
              _buildResultIsChange(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneWheel() {
    return Center(
      child: StreamBuilder(
        stream: _fortuneWheelController.stream,
        builder: (context, snapshot) {
          return FortuneWheel(
            key: const ValueKey<String>('ValueKeyFortunerWheel'),
            items: _wheel.fortuneValues,
            isGoByPriority: _wheel.isGoByPriority,
            duration: _wheel.duration,
            onChanged: (Fortune item) {
              _resultWheelController.sink.add(item);
            },
            onResult: _onResult,
          );
        },
      ),
    );
  }

  void _onResult(Fortune item) {
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
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                item.titleName.toString(),
                style: TextStyle(fontSize: 20, color: item.backgroundColor),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
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
  }

  Widget _buildResultIsChange() {
    return StreamBuilder<Fortune>(
      stream: _resultWheelController.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                snapshot.data!.titleName,
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
}
