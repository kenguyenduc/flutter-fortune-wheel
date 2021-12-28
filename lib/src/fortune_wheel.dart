import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/board_view.dart';
import 'package:flutter_fortune_wheel/src/models/fortune_item.dart';

class FortunerWheel extends StatefulWidget {
  const FortunerWheel({
    Key? key,
    required this.items,
    required this.onChanged,
    this.durationWheel = const Duration(milliseconds: 5000),
  }) : super(key: key);

  final List<FortuneItem> items;
  final Duration durationWheel;
  final Function(FortuneItem fortuneItem) onChanged;

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
          widget.onChanged.call(
              widget.items[_getIndexWheelItem(_value * _angle + _current)]);
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BoardView(items: widget.items, current: _current, angle: _angle),
              _buildCenterOfWheel(),
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
    // return TextButton(
    //   onPressed: _handleButtonGoPressed,
    //   style: TextButton.styleFrom(
    //     backgroundColor: Colors.black.withOpacity(0.4),
    //   ),
    //   child: const Text(
    //     'Bấm vào đây để quay',
    //     style: TextStyle(fontSize: 16, color: Colors.white),
    //   ),
    // );
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

  int _getIndexWheelItem(value) {
    double _base = (2 * pi / widget.items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * widget.items.length).floor();
  }
}
