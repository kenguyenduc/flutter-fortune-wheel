import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/arrow_view.dart';
import 'package:flutter_fortune_wheel/src/board_view.dart';
import 'package:flutter_fortune_wheel/src/helpers/fortune_item_helper.dart';
import 'package:flutter_fortune_wheel/src/models/fortune_item.dart';

class FortunerWheel extends StatefulWidget {
  const FortunerWheel({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.onResult,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.duration = const Duration(milliseconds: 5000),
    this.rotationCount = 100,
    this.isGoByPriority = true,
  }) : super(key: key);

  ///Danh sách các phần tử giá trị của vòng quay
  final List<FortuneItem> items;

  ///Thời gian quay
  final Duration duration;

  ///Số vòng quay trước khi quay đến kết quả
  final int rotationCount;

  ///Xử lý cập nhật kết quả thay đổi các giá trị khi đang quay
  final Function(FortuneItem item) onChanged;

  ///Xứ lý trả về kết quả vòng xoay
  final Function(FortuneItem item) onResult;

  ///Xử lý khi bắt đầu quay
  final VoidCallback? onAnimationStart;

  ///Xử lý khi kết thúc quay
  final VoidCallback? onAnimationEnd;

  ///Kiểm tra đang là chế độ quay ngẫu nhiên hay theo giá trị ưu tiên quay trúng
  ///[isGoByPriority] = true : theo giá trị ưu tiên quay trúng
  ///[isGoByPriority] = false : quay ngẫu nhiên
  final bool isGoByPriority;

  @override
  _FortunerWheelState createState() => _FortunerWheelState();
}

class _FortunerWheelState extends State<FortunerWheel>
    with SingleTickerProviderStateMixin {
  ///Góc xoay của bánh xe
  ///Default ban đầu [_angle]=0
  double _angle = 0;

  ///Góc xoay hiện tại của bánh xe sau khi có kết quả xoay
  ///Default ban đầu [_currentAngle]=0
  double _currentAngle = 0;

  ///Giá trị kết quả xoay
  int _currentIndex = 0;
  late AnimationController _wheelAnimationController;
  late Animation _wheelAnimation;

  ///Danh sách phần tử vòng xoay được lấy theo ưu tiên quay trúng
  late List<FortuneItem> _fortuneValuesByPriority;

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
          ///todo: check
          final index = _getIndexFortune(angle + _currentAngle);
          widget.onChanged.call(widget.items[index]);
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
            _buildGo(),
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
  Widget _buildGo() {
    return Visibility(
      visible: !_wheelAnimationController.isAnimating,
      child: TextButton(
        onPressed: widget.isGoByPriority
            ? _handleGoByPriorityPressed
            : _handleGoRandomPressed,
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
  Future<void> _handleGoRandomPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      double _random = Random().nextDouble();
      _angle = (20 + Random().nextInt(5) + _random) * 2 * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((_) {
        double factor = _currentAngle / (2 * pi);
        factor += _angle / (2 * pi);
        factor %= 1;
        _currentAngle = factor * 2 * pi;

        ///Lấy kết quả vòng quay
        ///todo: check
        final animationValue = _wheelAnimation.value;
        final angle = _wheelAnimation.value * _angle / (2 * pi);
        final angleRadian = _wheelAnimation.value * _angle;
        final int index = _getIndexFortune(angleRadian + _currentAngle);
        widget.onResult.call(widget.items[index]);
        _wheelAnimationController.reset();
        print('_currentAngle: $_currentAngle');
        print('_currentAngle de: ${_currentAngle * 180 / pi}');
        print('angleRadian de: ${angleRadian * 180 / pi}');
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }

  int _testIndex(double value) {
    var divider = 360 / widget.items.length;
    var offset = divider / 2;
    return (((value * 180 / pi + offset).ceil() % 360) / divider).floor();
  }

  int _getIndexFortuneItem(value) {
    double _base = (2 * pi / widget.items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * widget.items.length).floor();
  }

  ///Xử lý xoay theo giá trị ưu tiên quay trúng
  Future<void> _handleGoByPriorityPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      ///random index trong danh sách được tạo theo ưu tiên quay trúng
      final int randomIndex = Random().nextInt(_fortuneValuesByPriority.length);
      FortuneItem luckResult = _fortuneValuesByPriority[randomIndex];
      int index = widget.items.indexWhere((element) => element == luckResult);

      ///Tính góc xoay đến giá trị quay trúng
      _angle = (2 * pi / widget.items.length) *
              (_currentIndex > index
                  ? _currentIndex - index
                  : widget.items.length - (index - _currentIndex)) +
          widget.rotationCount * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((_) {
        double factor = _currentAngle / (2 * pi);
        factor += (_angle / (2 * pi));
        factor %= 1;
        _currentAngle = factor * 2 * pi;
        _wheelAnimationController.reset();
        _currentIndex = index;
        print('_currentAngle: $_currentAngle');
        print('_currentAngle de: ${_currentAngle * 180 / pi}');
        widget.onResult.call(widget.items[index]);
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }

  ///Xử lý tính toán giá trị index của phần tử khi đang quay
  int _getIndexFortune(double value) {
    int itemCount = widget.items.length;
    return (itemCount - value / (2 * pi) * itemCount).floor() % itemCount;
  }
}
