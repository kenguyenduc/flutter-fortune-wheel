import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    Key? key,
    required this.angle,
    required this.current,
    required this.items,
    this.size,
  }) : super(key: key);

  final double angle;
  final double current;

  ///List value of wheel
  final List<Fortune> items;

  final Size? size;

  @override
  State<StatefulWidget> createState() {
    return _BoardViewState();
  }
}

class _BoardViewState extends State<BoardView> {
  Size get size =>
      widget.size ??
      Size(MediaQuery.of(context).size.shortestSide * 0.8,
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
              children: List.generate(widget.items.length,
                  (index) => _buildSlicedCircle(widget.items[index])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlicedCircle(Fortune fortune) {
    double _rotate = _getRotateOfItem(widget.items.indexOf(fortune));
    return Transform.rotate(
      angle: _rotate,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildCard(fortune),
          _buildValue(fortune),
        ],
      ),
    );
  }

  Widget _buildCard(Fortune fortune) {
    double _angle = 2 * pi / widget.items.length;
    return ClipPath(
      clipper: _SlicesPath(_angle),
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              fortune.backgroundColor,
              fortune.backgroundColor.withOpacity(0)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValue(Fortune fortune) {
    return Container(
      height: size.height,
      width: size.width,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: size.height / 3, width: 54),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fortune.titleName != null)
              Flexible(
                child: AutoSizeText(
                  fortune.titleName!,
                  style: fortune.textStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  minFontSize: 10,
                  maxFontSize: 20,
                  overflow: TextOverflow.clip,
                ),
              ),
            if (fortune.icon != null)
              Padding(
                padding: EdgeInsets.all(fortune.titleName != null ? 8 : 0),
                child: fortune.icon!,
              ),
          ],
        ),
      ),
    );
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
