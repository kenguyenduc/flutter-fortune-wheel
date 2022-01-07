import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/models/fortune_item.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BoardView extends StatefulWidget {
  final double angle;
  final double current;

  ///List value of wheel
  final List<FortuneItem> items;

  const BoardView({
    Key? key,
    required this.angle,
    required this.current,
    required this.items,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BoardViewState();
  }
}

class _BoardViewState extends State<BoardView> {
  Size get size => Size(MediaQuery.of(context).size.shortestSide * 0.8,
      MediaQuery.of(context).size.shortestSide * 0.8);

  ///Xử lý tính độ xoay của giá trị may mắn
  double _getRotateOfItem(int index) =>
      (index / widget.items.length) * 2 * pi + pi / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black38),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: widget.angle + widget.current,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                for (FortuneItem item in widget.items) ...[_buildCard(item)],
                for (FortuneItem item in widget.items) ...[_buildValue(item)],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(FortuneItem fortuneItem) {
    double _rotate = _getRotateOfItem(widget.items.indexOf(fortuneItem));
    double _angle = 2 * pi / widget.items.length;
    return Transform.rotate(
      angle: _rotate,
      child: ClipPath(
        clipper: _SlicesPath(_angle),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                fortuneItem.backgroundColor,
                fortuneItem.backgroundColor.withOpacity(0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValue(FortuneItem fortuneItem) {
    double _rotate = _getRotateOfItem(widget.items.indexOf(fortuneItem));
    return Transform.rotate(
      angle: _rotate,
      child: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 16),
        child: ConstrainedBox(
          constraints:
              BoxConstraints.expand(height: size.height / 3, width: 44),
          child: Column(
            children: [
              Expanded(
                child: AutoSizeText(
                  fortuneItem.titleName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  minFontSize: 12,
                  maxFontSize: 16,
                  overflow: TextOverflow.clip,
                ),
              ),
              if (fortuneItem.icon != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: fortuneItem.icon!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isColorDark(Color color) {
    double darkness = 1 -
        ((0.299 * color.red) + (0.587 * color.green) + (0.114 * color.blue)) /
            255;
    if (darkness < 0.5) {
      return false; // It's a light color
    } else {
      return true; // It's a dark color
    }
  }
}

class _SlicesPath extends CustomClipper<Path> {
  final double angle;

  _SlicesPath(this.angle);

  @override
  Path getClip(Size size) {
    Offset _center = size.center(Offset.zero);
    Rect _rect = Rect.fromCircle(center: _center, radius: size.width / 2);
    Path _path = Path()
      ..moveTo(_center.dx, _center.dy)
      ..arcTo(_rect, -pi / 2 - angle / 2, angle, false)
      ..close();
    return _path;
  }

  @override
  bool shouldReclip(_SlicesPath oldClipper) {
    return angle != oldClipper.angle;
  }
}
