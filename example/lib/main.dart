import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_fortune_wheel_example/common/constants.dart';
import 'package:flutter_fortune_wheel_example/fortune_wheel_setting_page.dart';
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
  final StreamController<FortuneItem> _resultWheelController =
      StreamController<FortuneItem>.broadcast();

  final List<FortuneItem> _resultsHistory = <FortuneItem>[];
  final StreamController<List<FortuneItem>> _resultsHistoryController =
      StreamController<List<FortuneItem>>.broadcast();

  Wheel _wheel = Wheel(
    fortuneValues: Constants.listAnNhau,
    isGoByPriority: true,
  );

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Vòng xoay may mắn'),
          actions: [
            IconButton(
              splashRadius: 28,
              onPressed: () {},
              icon: const Icon(Icons.bar_chart),
            ),
            IconButton(
              splashRadius: 28,
              onPressed: () async {
                _rebuildWheelController.add(false);
                final Wheel? result = await Navigator.push(
                  context,
                  MaterialPageRoute<Wheel>(
                    builder: (context) =>
                        FortuneWheelSettingPage(wheel: _wheel),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _wheel = result;
                  });
                }
                _rebuildWheelController.add(true);
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
              _buildFortunerWheel(),
              _buildResultIsChange(),
              const SizedBox(height: 16),
              // const Padding(
              //   padding: EdgeInsets.all(16.0),
              //   child: Text(
              //     'Danh sách kết quả vòng quay:',
              //     style: TextStyle(
              //       color: Colors.green,
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // _buildResultsHistory(),
            ],
          ),
        ),
      ),
    );
  }

  final StreamController<bool> _rebuildWheelController =
      StreamController<bool>.broadcast();

  Widget _buildFortunerWheel() {
    return Center(
      child: StreamBuilder(
        stream: _rebuildWheelController.stream,
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return const SizedBox();
          }
          return FortunerWheel(
            key: const ValueKey<String>('ValueKeyFortunerWheel'),
            items: _wheel.fortuneValues,
            // isGoByPriority: _wheel.isGoByPriority,
            isGoByPriority: true,
            duration: _wheel.duration,
            onChanged: (FortuneItem item) {
              _resultWheelController.add(item);
            },
            onResult: _onResult,
          );
        },
      ),
    );
  }

  void _onResult(FortuneItem item) {
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
                item.titleName.toString(),
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
  }

  Widget _buildResultIsChange() {
    return StreamBuilder<FortuneItem>(
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
                'Quay Lần ${index + 1}: ${_resultsHistory[index].titleName}',
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
