import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/board_view.dart';
import 'package:flutter_fortune_wheel/src/models/luck.dart';

class FortunerWheel extends StatefulWidget {
  const FortunerWheel({
    Key? key,
    required this.items,
    required this.onChanged,
    this.durationWheel = const Duration(milliseconds: 5000),
  }) : super(key: key);

  final List<Luck> items;
  final Duration durationWheel;
  final Function(Luck luck) onChanged;

  @override
  _FortunerWheelState createState() => _FortunerWheelState();
}

class _FortunerWheelState extends State<FortunerWheel>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  late AnimationController _wheelAnimationController;
  late Animation _wheelAnimation;
  static const _durationWheel = Duration(milliseconds: 5000);
  final List<Luck> _itemsWheel = [
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
  ];

  @override
  void initState() {
    super.initState();
    _wheelAnimationController =
        AnimationController(vsync: this, duration: _durationWheel);
    _wheelAnimation = CurvedAnimation(
        parent: _wheelAnimationController,
        curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  void dispose() {
    super.dispose();
    _wheelAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _wheelAnimation,
        builder: (context, child) {
          final _value = _wheelAnimation.value;
          final _angle = _value * this._angle;
          final _index = _getIndexWheelItem(_value * _angle + _current);
          print(_itemsWheel[_index].value);
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BoardView(items: _itemsWheel, current: _current, angle: _angle),
              _buildCenterOfWheel(),
              // if (!_wheelAnimationController.isAnimating)
              _buildGo(),
              // SizedBox(
              //   height: MediaQuery.of(context).size.shortestSide * 0.8,
              //   width: MediaQuery.of(context).size.shortestSide * 0.8,
              //   child: const Align(
              //     alignment: Alignment(1.1, 0),
              //     child: Icon(
              //       Icons.arrow_back_ios_outlined,
              //     ),
              //   ),
              // ),
              _buildResult(_value),
            ],
          );
        });
  }

  Widget _buildCenterOfWheel() {
    return const CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildGo() {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(width: 6, color: Colors.red),
        shape: BoxShape.circle,
      ),
      child: TextButton(
        onPressed: _handleButtonGoPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          shadowColor: Colors.black.withOpacity(0.07),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
        ),
        child: const Text(
          'QUAY',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
    return TextButton(
      onPressed: _handleButtonGoPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.4),
      ),
      child: const Text(
        'Bấm vào đây để quay nó',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  void _handleButtonGoPressed() {
    if (!_wheelAnimationController.isAnimating) {
      double _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _wheelAnimationController.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _wheelAnimationController.reset();
      });
    }
  }

  ///Xử lý lấy index kết quả vòng quay
  int _getIndexWheelItem(value) {
    double _base = (2 * pi / _itemsWheel.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _itemsWheel.length).floor();
  }

  ///Ui kết quả vòng quay
  Widget _buildResult(_value) {
    int _index = _getIndexWheelItem(_value * _angle + _current);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          _itemsWheel[_index].value.toString(),
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
