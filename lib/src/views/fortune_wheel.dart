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

  ///Cấu hình vòng quay
  final Wheel wheel;

  ///Xử lý cập nhật kết quả thay đổi các giá trị khi đang quay
  final Function(Fortune item) onChanged;

  ///Xứ lý trả về kết quả vòng xoay
  final Function(Fortune item) onResult;

  ///Xử lý khi bắt đầu quay
  final VoidCallback? onAnimationStart;

  ///Xử lý khi kết thúc quay
  final VoidCallback? onAnimationEnd;

  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _wheelAnimationController;
  late Animation _wheelAnimation;

  ///Góc xoay của bánh xe
  ///Default ban đầu [_angle]=0
  double _angle = 0;

  ///Góc xoay hiện tại của bánh xe sau khi có kết quả xoay
  ///Default ban đầu [_currentAngle]=0
  double _currentAngle = 0;

  ///index giá trị phần thưởng kim chi xoay hiện tại đang đứng
  int _currentIndex = 0;

  ///index kết quả vòng quay sau khi quay
  int _indexResult = 0;

  ///Danh sách phần tử vòng xoay được lấy theo ưu tiên quay trúng
  late List<Fortune> _fortuneValuesByPriority;

  double get radius =>
      widget.wheel.radius ?? MediaQuery.of(context).size.shortestSide * 0.8;

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
  void didUpdateWidget(covariant FortuneWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wheel.duration != oldWidget.wheel.duration) {
      _wheelAnimationController.duration = widget.wheel.duration;
      _wheelAnimation = CurvedAnimation(
        parent: _wheelAnimationController,
        curve: Curves.fastLinearToSlowEaseIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PanAwareBuilder(
      physics: CircularPanPhysics(),
      onFling: widget.wheel.isSpinByPriority
          ? _handleSpinByPriorityPressed
          : _handleSpinByRandomPressed,
      builder: (BuildContext context, PanState panState) {
        return AnimatedBuilder(
          animation: _wheelAnimation,
          builder: (context, _) {
            final size = MediaQuery.of(context).size;
            final meanSize = (size.width + size.height) / 2;
            final panFactor = 6 / meanSize;

            final animationValue = _wheelAnimation.value;
            final angle = animationValue * _angle;

            if (_wheelAnimationController.isAnimating) {
              _indexResult = _getIndexFortune(angle + _currentAngle);
              widget.onChanged.call(widget.wheel.items[_indexResult]);
            }
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, constraints) {
                    final panAngle = panState.distance * panFactor;
                    final rotationAngle = 2 *
                        pi *
                        widget.wheel.rotationCount *
                        _wheelAnimation.value;
                    return BoardView(
                      items: widget.wheel.items,
                      current: _currentAngle + rotationAngle + panAngle,
                      angle: angle,
                      radius: radius,
                    );
                  },
                ),
                _buildCenterOfWheel(),
                _buildButtonSpin(),
                SizedBox(
                  height: radius,
                  width: radius,
                  child: Align(
                    alignment: const Alignment(1.08, 0),
                    child: widget.wheel.arrowView ?? const ArrowView(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ///UI Tâm của bánh xe
  Widget _buildCenterOfWheel() {
    return const CircleAvatar(radius: 16, backgroundColor: Colors.white);
  }

  ///UI Button quay
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
                  widget.wheel.titleSpinButton ?? 'Bấm vào đây để quay',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
          ),
    );
  }

  ///Xử lý xoay ngẫu nhiên
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

  ///Xử lý tính toán giá trị index của phần tử khi đang quay
  int _getIndexFortune(double value) {
    int itemCount = widget.wheel.items.length;
    double rightOffset = value - (pi / itemCount);
    return (itemCount - rightOffset / (2 * pi) * itemCount).floor() % itemCount;
  }

  ///Xử lý xoay theo giá trị ưu tiên quay trúng
  Future<void> _handleSpinByPriorityPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      //random index trong danh sách được tạo theo ưu tiên quay trúng
      final int randomIndex = Random().nextInt(_fortuneValuesByPriority.length);
      Fortune result = _fortuneValuesByPriority[randomIndex];
      int index = widget.wheel.items.indexWhere((element) => element == result);
      if (index == -1) {
        _indexResult = 0;
      } else {
        _indexResult = index;
      }

      int itemCount = widget.wheel.items.length;

      //Số item để đi đến kết quả theo index
      int angleFactor = _currentIndex > _indexResult
          ? _currentIndex - _indexResult
          : itemCount - (_indexResult - _currentIndex);

      //Tính góc xoay đến giá trị quay trúng
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
