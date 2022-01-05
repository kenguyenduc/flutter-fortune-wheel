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
    this.durationWheel = const Duration(milliseconds: 10000),
  }) : super(key: key);

  final List<FortuneItem> items;
  final Duration durationWheel;
  final Function(FortuneItem item) onChanged;
  final Function(FortuneItem item) onResult;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;

  @override
  _FortunerWheelState createState() => _FortunerWheelState();
}

class _FortunerWheelState extends State<FortunerWheel>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _currentAngle = 0;
  int _currentIndex = 0;
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
        // final index =
        //     _getIndexFortuneItem(angle + _currentAngle);
        // widget.onChanged.call(widget.items[index]);
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
                alignment: Alignment(1.07, 0),
                child: ArrowView(),
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

  Future<void> _handleButtonGoPressed() async {
    if (!_wheelAnimationController.isAnimating) {
      ///random index trong danh sách được tạo theo ưu tiên quay trúng
      final int randomIndex = Random().nextInt(_fortuneValuesByPriority.length);
      FortuneItem luckResult = _fortuneValuesByPriority[randomIndex];
      int index = widget.items.indexWhere((element) => element == luckResult);

      ///2*pi/length *(currentIndex > index ? currentIndex - index : length - (index - currentIndex))
      // _angle = pi;
      // _angle = 2 * pi / 8 * 4 + 100 * pi;
      _angle = (2 * pi / widget.items.length) *
              (_currentIndex > index
                  ? _currentIndex - index
                  : widget.items.length - (index - _currentIndex)) +
          100 * pi;
      await Future.microtask(() => widget.onAnimationStart?.call());
      await _wheelAnimationController.forward(from: 0.0).then((value) {
        double factor = _currentAngle / (2 * pi);
        factor += (_angle / (2 * pi));
        factor %= 1;
        _currentAngle = factor * 2 * pi;
        _wheelAnimationController.reset();
        // _wheelAnimationController.repeat();
        _currentIndex = index;
        widget.onResult.call(widget.items[index]);
      });
      await Future.microtask(() => widget.onAnimationEnd?.call());
    }
  }

  int _getIndexFortuneItem(value) {
    double _base = (2 * pi / widget.items.length / 2) / (2 * pi);
    print('base == $_base');
    print('value == $value');
    print((((_base + value) % 1) * widget.items.length).floor());
    return (((_base + value) % 1) * widget.items.length).floor();
  }

  // Offset _calculateWheelOffset(
  //     BoxConstraints constraints, TextDirection textDirection) {
  //   final smallerSide = getSmallerSide(constraints);
  //   var offsetX = constraints.maxWidth / 2;
  //   if (textDirection == TextDirection.rtl) {
  //     offsetX = offsetX * -1 + smallerSide / 2;
  //   }
  //   return Offset(offsetX, constraints.maxHeight / 2);
  // }

  double _calculateSliceAngle(int index, int itemCount) {
    final anglePerChild = 2 * pi / itemCount;
    final childAngle = anglePerChild * index;
    // first slice starts at 90 degrees, if 0 degrees is at the top.
    // The angle offset puts the center of the first slice at the top.
    final angleOffset = -(pi / 2 + anglePerChild / 2);
    return childAngle + angleOffset;
  }

  ///di chuyển tới người trúng thưởng
  Future<void> _scrollToElement({
    required int second,
    required int indexItem,
    required int lengthItems,
  }) async {
    /// Thời gian bắt đầu giảm vận tốc
    ///const double gameDurationReduce = 10;
    const int numberReverseLoop = 20;
    const int partMove = 10;

    /// Vận tốc
    const double speed = 100;

    /// Loop 60ms
    const double gameLoop = 17;

    /// góc radian của 1 item
    // final double itemHeight = _itemHeight;
    final double itemAngle = 2 * pi / lengthItems;

    /// Số vòng lặp
    final double gameTime = second * 1000 / gameLoop;

    /// Khoảng cách
    final double distance = gameTime * (speed / 2);

    /// Bước lùi
    final double speedStep = speed / gameTime;

    /// Vị trí dừng
    final double endOffset = itemAngle * indexItem;

    /// Vị trí khởi đầu
    final double startOffset = endOffset - distance - 50;

    /// Vị trí hiện tại
    double tempOffset = startOffset;

    /// Vận tốc hiện tại
    double tempSpeed = speed;

    ///khởi động lấy đà
    for (final int i in List<int>.generate(numberReverseLoop, (i) => i + 1)) {
      // _playerController.jumpTo((_itemHeight / partMove) * i);
      // await Future.delayed(const Duration(milliseconds: 25));
    }

    ///di chuyển trở lại vị trí cũ
    for (final int i
        in List<int>.generate(numberReverseLoop, (i) => i + 1).reversed) {
      // _playerController.jumpTo(-(_itemHeight / partMove) * i);
      // await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
    }

    /// loop
    while (tempSpeed > 0) {
      // _playerController.jumpTo(tempOffset);
      // await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
      // tempOffset += tempSpeed;
      // tempSpeed -= speedStep;
    }

    // await Navigator.of(context, rootNavigator: true)
    //     .push<dynamic>(_HeroDialogRoute<dynamic>(
    //   builder: (BuildContext context) {
    //     return _buildWinnerDialog(_players[playerIndex], playerIndex);
    //   },
    // ));

    // if (_luckyWheelSetting.saveWhenFinished == true) {
    //   _gameLuckyWheelBloc.add(GameLuckyWheelWinnerSaved());
    // }

    await Future.delayed(const Duration(milliseconds: 1000));
    // await showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return _buildWinnerDialog(_players[playerIndex], playerIndex);
    //   },
    //   useRootNavigator: false,
    // );

    // _isPlaying = false;
    // setState(() {});
  }
}
