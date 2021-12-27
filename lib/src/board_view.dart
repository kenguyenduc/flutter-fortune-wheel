import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/arrow_view.dart';
import 'package:flutter_fortune_wheel/src/gradient_border_container.dart';
import 'package:flutter_fortune_wheel/src/models/luck.dart';

class BoardView extends StatefulWidget {
  final double angle;
  final double current;

  ///List value of wheel
  final List<Luck> items;

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

  double _rotote(int index) => (index / widget.items.length) * 2 * pi;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //shadow
        Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black38),
          ]),
        ),
        Transform.rotate(
          angle: -(widget.current + widget.angle) * 2 * pi,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              for (Luck luck in widget.items) ...[_buildCard(luck)],
              for (Luck luck in widget.items) ...[_buildValue(luck)],
            ],
          ),
        ),
        SizedBox(
          height: size.height,
          width: size.width,
          child: const ArrowView(),
        ),
      ],
    );
  }

  Widget _buildCard(Luck luck) {
    double _rotate = _rotote(widget.items.indexOf(luck));
    double _angle = 2 * pi / widget.items.length;
    return Transform.rotate(
      angle: _rotate,
      child: ClipPath(
        clipper: _LuckPath(_angle),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [luck.color, luck.color.withOpacity(0)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValue(Luck luck) {
    double _rotate = _rotote(widget.items.indexOf(luck));
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
          child: Text(
            luck.value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _LuckPath extends CustomClipper<Path> {
  final double angle;

  _LuckPath(this.angle);

  @override
  Path getClip(Size size) {
    Path _path = Path();
    Offset _center = size.center(Offset.zero);
    Rect _rect = Rect.fromCircle(center: _center, radius: size.width / 2);
    _path.moveTo(_center.dx, _center.dy);
    _path.arcTo(_rect, -pi / 2 - angle / 2, angle, false);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(_LuckPath oldClipper) {
    return angle != oldClipper.angle;
  }
}
