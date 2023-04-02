import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/helpers/helpers.dart';
import 'package:flutter_fortune_wheel/src/models/models.dart';
import 'package:flutter_fortune_wheel/src/views/arrow_view.dart';
import 'package:flutter_fortune_wheel/src/views/board_view.dart';
import '../core/core.dart';

class FortuneWheel extends StatefulWidget {
  const FortuneWheel({
    Key? key,
    required this.wheel,
    required this.onChanged,
    required this.onResult,
    this.onAnimationStart,
    this.onAnimationEnd,
  }) : super(key: key);

  ///Configure wheel
  final Wheel wheel;

  ///Handling updates of changed values while spinning
  final Function(Fortune item) onChanged;

  ///Handling returning the result of the spin
  final Function(Fortune item) onResult;

  ///Handling when starting to spin
  final VoidCallback? onAnimationStart;

  ///Handling when spinning ends
  final VoidCallback? onAnimationEnd;

  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _wheelAnimationController;
  late Animation _wheelAnimation;

  ///Wheel rotation angle
  ///Default value [_angle] = 0
  double _angle = 0;

  ///Current rotation angle of the wheel after spinning
  ///Default value [_currentAngle]=0
  double _currentAngle = 0;

  ///Index of the current position of the prize value on wheel
  int _currentIndex = 0;

  ///Index of the result after spinning the wheel
  int _indexResult = 0;

  ///List of wheel elements prioritized for winning spins
  late List<Fortune> _fortuneValuesByPriority;

  double get wheelSize =>
      widget.wheel.size ?? MediaQuery.of(context).size.shortestSide * 0.8;

  @override
  void initState() {
    super.initState();
    _wheelAnimationController =
        AnimationController(vsync: this, duration: widget.wheel.duration);
    _wheelAnimation = CurvedAnimation(
      parent: _wheelAnimationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    _fortuneValuesByPriority = getFortuneValuesByPriority(widget.wheel.items);
  }

  @override
  void dispose() {
    super.dispose();
    _wheelAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final meanSize = (deviceSize.width + deviceSize.height) / 2;
    final panFactor = 6 / meanSize;
    return PanAwareBuilder(
      physics: CircularPanPhysics(),
      onFling: widget.wheel.isSpinByPriority
          ? _handleSpinByPriorityPressed
          : _handleSpinByRandomPressed,
      builder: (BuildContext context, PanState panState) {
        final panAngle = panState.distance * panFactor;
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _wheelAnimation,
              child: BoardView(
                items: widget.wheel.items,
                size: wheelSize,
              ),
              builder: (context, child) {
                ///Rotation angle of the wheel
                final angle = _wheelAnimation.value * _angle;
                if (_wheelAnimationController.isAnimating) {
                  _indexResult = _getIndexFortune(angle + _currentAngle);
                  widget.onChanged.call(widget.wheel.items[_indexResult]);
                }
                final rotationAngle =
                    2 * pi * widget.wheel.rotationCount * _wheelAnimation.value;

                ///Current angle position of the standing wheel
                final current = _currentAngle + rotationAngle + panAngle;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: angle + current,
                      child: child,
                    ),
                    _buildCenterOfWheel(),
                    _buildButtonSpin(),
                  ],
                );
              },
            ),
            SizedBox(
              height: wheelSize,
              width: wheelSize,
              child: Align(
                alignment: const Alignment(1.08, 0),
                child: widget.wheel.arrowView ?? const ArrowView(),
              ),
            ),
          ],
        );
      },
    );
  }

  ///UI Wheel center
  Widget _buildCenterOfWheel() {
    return const CircleAvatar(radius: 16, backgroundColor: Colors.white);
  }

  ///UI Button Spin
  Widget _buildButtonSpin() {
    return Visibility(
      visible: !_wheelAnimationController.isAnimating,
      child: widget.wheel.action ??
          TextButton(
            onPressed: widget.wheel.isSpinByPriority
                ? _handleSpinByPriorityPressed
                : _handleSpinByRandomPressed,
            style: widget.wheel.spinButtonStyle ??
                TextButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.4),
                ),
            child: widget.wheel.childSpinButton ??
                Text(
                  widget.wheel.titleSpinButton ?? 'Click here to spin',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
          ),
    );
  }

  ///Handling mode random spinning
  Future<void> _handleSpinByRandomPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      //Random hệ số thập phân từ 0 đến 1
      double randomDouble = Random().nextDouble();
      //random theo số phần tử
      int randomLength = Random().nextInt(widget.wheel.items.length);
      _angle =
          (randomDouble + widget.wheel.rotationCount + randomLength) * 2 * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((_) {
        double factor = _currentAngle / (2 * pi);
        factor += _angle / (2 * pi);
        factor %= 1;
        _currentAngle = factor * 2 * pi;
        widget.onResult.call(widget.wheel.items[_indexResult]);
        _wheelAnimationController.reset();
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }

  ///Handling the calculation of the index value of the element while spinning
  int _getIndexFortune(double value) {
    int itemCount = widget.wheel.items.length;
    double rightOffset = value - (pi / itemCount);
    return (itemCount - rightOffset / (2 * pi) * itemCount).floor() % itemCount;
  }

  ///Handling mode spinning based on prioritized winning values
  Future<void> _handleSpinByPriorityPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      final int randomIndex = Random().nextInt(_fortuneValuesByPriority.length);
      Fortune result = _fortuneValuesByPriority[randomIndex];
      int index = widget.wheel.items.indexWhere((element) => element == result);
      if (index == -1) {
        _indexResult = 0;
      } else {
        _indexResult = index;
      }

      int itemCount = widget.wheel.items.length;

      //Number of items to reach the result by index
      int angleFactor = _currentIndex > _indexResult
          ? _currentIndex - _indexResult
          : itemCount - (_indexResult - _currentIndex);

      //Calculate the rotation angle to the winning spin value
      _angle = (2 * pi / itemCount) * angleFactor +
          widget.wheel.rotationCount * 2 * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((_) {
        double factor = _currentAngle / (2 * pi);
        factor += (_angle / (2 * pi));
        factor %= 1;
        _currentAngle = factor * 2 * pi;
        _wheelAnimationController.reset();
        _currentIndex = _indexResult;
        widget.onResult.call(widget.wheel.items[_indexResult]);
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }
}
