import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/arrow_view_center_right.dart';
import 'package:flutter_fortune_wheel/src/board_view.dart';
import 'package:flutter_fortune_wheel/src/helpers/fortune_item_helper.dart';
import 'package:flutter_fortune_wheel/src/models/fortune_item.dart';

class FortunerWheel extends StatefulWidget {
  const FortunerWheel({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.onResult,
    this.durationWheel = const Duration(milliseconds: 5000),
  }) : super(key: key);

  final List<FortuneItem> items;
  final Duration durationWheel;
  final Function(FortuneItem item) onChanged;
  final Function(FortuneItem item) onResult;

  @override
  _FortunerWheelState createState() => _FortunerWheelState();
}

class _FortunerWheelState extends State<FortunerWheel>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  late AnimationController _wheelAnimationController;
  late Animation _wheelAnimation;
  late List<FortuneItem> _fortuneValuesByPriority;

  @override
  void initState() {
    super.initState();
    _wheelAnimationController =
        AnimationController(vsync: this, duration: widget.durationWheel);
    _wheelAnimation = CurvedAnimation(
        parent: _wheelAnimationController,
        curve: Curves.fastLinearToSlowEaseIn);
    _fortuneValuesByPriority = getFortuneValuesByPriority(widget.items);
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
        final animationValue = _wheelAnimation.value;
        final angle = animationValue * _angle;
        final index = _getIndexFortuneItem(animationValue * angle + _current);
        widget.onChanged.call(widget.items[index]);
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: pi / 2,
              child: BoardView(
                items: widget.items,
                current: _current,
                angle: angle,
              ),
            ),
            _buildCenterOfWheel(),
            _buildGo(),
            SizedBox(
              height: MediaQuery.of(context).size.shortestSide * 0.8,
              width: MediaQuery.of(context).size.shortestSide * 0.8,
              child: const Align(
                alignment: Alignment(1.07, 0),
                child: ArrowViewCenterRight(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCenterOfWheel() {
    return const CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildGo() {
    return Visibility(
      visible: !_wheelAnimationController.isAnimating,
      child: TextButton(
        onPressed: _handleButtonGoPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.4),
        ),
        child: const Text(
          'Bấm vào đây để quay',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _handleButtonGoPressed() {
    ///random index trong danh sách được tạo theo ưu tiên quay trúng
    final int randomIndex = Random().nextInt(_fortuneValuesByPriority.length);
    FortuneItem luckResult = _fortuneValuesByPriority[randomIndex];

    int index = widget.items.indexWhere((element) => element == luckResult);

    final selectedAngle = -2 * pi * (index / widget.items.length);

    if (!_wheelAnimationController.isAnimating) {
      double _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _wheelAnimationController.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current.floor();
        _wheelAnimationController.reset();

        ///Lấy kết quả vòng quay
        final animationValue = _wheelAnimation.value;
        final angle = _wheelAnimation.value * _angle;
        final index = _getIndexFortuneItem(animationValue * angle + _current);
        widget.onResult.call(widget.items[index]);
      });
    }
  }

  int _getIndexFortuneItem(value) {
    double _base = (2 * pi / widget.items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * widget.items.length).floor();
  }
}
