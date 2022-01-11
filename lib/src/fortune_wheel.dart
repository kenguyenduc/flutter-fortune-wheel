import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/arrow_view.dart';
import 'package:flutter_fortune_wheel/src/board_view.dart';
import 'package:flutter_fortune_wheel/src/helpers/helpers.dart';
import 'package:flutter_fortune_wheel/src/models/models.dart';

class FortuneWheel extends StatefulWidget {
  const FortuneWheel({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.onResult,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.duration = const Duration(milliseconds: 10000),
    this.rotationCount = 50,
    this.isGoByPriority = true,
  }) : super(key: key);

  ///Danh sách các phần tử giá trị của vòng quay
  final List<Fortune> items;

  ///Thời gian quay
  final Duration duration;

  ///Số vòng quay trước khi quay đến kết quả
  final int rotationCount;

  ///Xử lý cập nhật kết quả thay đổi các giá trị khi đang quay
  final Function(Fortune item) onChanged;

  ///Xứ lý trả về kết quả vòng xoay
  final Function(Fortune item) onResult;

  ///Xử lý khi bắt đầu quay
  final VoidCallback? onAnimationStart;

  ///Xử lý khi kết thúc quay
  final VoidCallback? onAnimationEnd;

  ///Kiểm tra đang là chế độ quay ngẫu nhiên hay theo giá trị ưu tiên quay trúng
  ///[isGoByPriority] = true : theo giá trị ưu tiên quay trúng
  ///[isGoByPriority] = false : quay ngẫu nhiên
  final bool isGoByPriority;

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

  @override
  void initState() {
    super.initState();
    _wheelAnimationController =
        AnimationController(vsync: this, duration: widget.duration);
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

        if (_wheelAnimationController.isAnimating) {
          _indexResult = _getIndexFortune(angle + _currentAngle);
          widget.onChanged.call(widget.items[_indexResult]);
        }
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            BoardView(
              items: widget.items,
              current: _currentAngle,
              angle: angle,
            ),
            _buildCenterOfWheel(),
            _buildButtonSpin(),
            SizedBox(
              height: MediaQuery.of(context).size.shortestSide * 0.8,
              width: MediaQuery.of(context).size.shortestSide * 0.8,
              child: const Align(
                alignment: Alignment(1.08, 0),
                child: ArrowView(),
              ),
            ),
          ],
        );
      },
    );
  }

  ///UI Tâm của vòng tròn
  Widget _buildCenterOfWheel() {
    return const CircleAvatar(radius: 16, backgroundColor: Colors.white);
  }

  ///UI Button quay
  Widget _buildButtonSpin() {
    return Visibility(
      visible: !_wheelAnimationController.isAnimating,
      child: TextButton(
        onPressed: widget.isGoByPriority
            ? _handleSpinByPriorityPressed
            : _handleSpinByRandomPressed,
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

  ///Xử lý xoay ngẫu nhiên
  Future<void> _handleSpinByRandomPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      double randomDouble = Random().nextDouble();
      int randomLength = Random().nextInt(widget.items.length);
      _angle = (randomDouble + widget.rotationCount + randomLength) * 2 * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((_) {
        double factor = _currentAngle / (2 * pi);
        factor += _angle / (2 * pi);
        factor %= 1;
        _currentAngle = factor * 2 * pi;
        widget.onResult.call(widget.items[_indexResult]);
        _wheelAnimationController.reset();
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }

  ///Xử lý tính toán giá trị index của phần tử khi đang quay
  int _getIndexFortune(double value) {
    int itemCount = widget.items.length;
    double rightOffset = value - (pi / (widget.items.length));
    return (itemCount - rightOffset / (2 * pi) * itemCount).floor() % itemCount;
  }

  ///Xử lý xoay theo giá trị ưu tiên quay trúng
  Future<void> _handleSpinByPriorityPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      ///random index trong danh sách được tạo theo ưu tiên quay trúng
      final int randomIndex = Random().nextInt(_fortuneValuesByPriority.length);
      Fortune luckResult = _fortuneValuesByPriority[randomIndex];
      int index = widget.items.indexWhere((element) => element == luckResult);
      if (index == -1) {
        _indexResult = 0;
      } else {
        _indexResult = index;
      }

      ///Tính góc xoay đến giá trị quay trúng
      _angle = (2 * pi / widget.items.length) *
              (_currentIndex > _indexResult
                  ? _currentIndex - _indexResult
                  : widget.items.length - (_indexResult - _currentIndex)) +
          widget.rotationCount * 2 * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((_) {
        double factor = _currentAngle / (2 * pi);
        factor += (_angle / (2 * pi));
        factor %= 1;
        _currentAngle = factor * 2 * pi;
        _wheelAnimationController.reset();
        _currentIndex = _indexResult;
        widget.onResult.call(widget.items[_indexResult]);
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }
}
