import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/models/models.dart';
import 'package:auto_size_text/auto_size_text.dart';

///UI Vòng quay
class BoardView extends StatefulWidget {
  const BoardView({
    Key? key,
    required this.angle,
    required this.current,
    required this.items,
    this.radius,
  }) : super(key: key);

  ///Góc xoay của vòng quay
  final double angle;

  ///vị trị góc hiện tại vòng xoay đang đứng
  final double current;

  ///danh sách giá trị phần tử vòng quay
  final List<Fortune> items;

  ///Bán kính của vòng quay
  final double? radius;

  @override
  State<StatefulWidget> createState() {
    return _BoardViewState();
  }
}

class _BoardViewState extends State<BoardView> {
  double get radius =>
      widget.radius ?? MediaQuery.of(context).size.shortestSide * 0.8;

  ///Xử lý tính độ xoay của giá trị may mắn
  double _getRotateOfItem(int index) =>
      (index / widget.items.length) * 2 * math.pi + math.pi / 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius,
      width: radius,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: widget.angle + widget.current,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(
                widget.items.length,
                (index) => _buildSlicedCircle(
                  widget.items[index],
                ),
              ),
              // children: [_buildSlicedCircle(widget.items[0])],
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
    double _angle = 2 * math.pi / widget.items.length;
    return CustomPaint(
      painter: _BorderPainter(_angle),
      child: ClipPath(
        clipper: _SlicesPath(_angle),
        child: Container(
          height: radius,
          width: radius,
          color: fortune.backgroundColor,
        ),
      ),
    );
  }

  Widget _buildValue(Fortune fortune) {
    return Container(
      height: radius,
      width: radius,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: radius / 3, width: 54),
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

class _BorderPainter extends CustomPainter {
  final double angle;

  _BorderPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    const double radiusDot = 3;
    double radius = size.width / 2;
    Offset center = size.center(Offset.zero);

    //Khung ngoài cùng
    Paint outlineBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.red;
    Rect rect = Rect.fromCircle(center: center, radius: size.width / 2);
    Path pathFirst = Path()
      ..arcTo(rect, -math.pi / 2 - angle / 2, angle, false);

    //Khung thứ 2 nền trắng
    Paint outlineBrushSecond = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..color = Colors.white;
    Rect rectSecond =
        Rect.fromCircle(center: center, radius: size.width / 2 - 6);
    Path pathSecond = Path()
      ..arcTo(rectSecond, -math.pi / 2 - angle / 2, angle, false);

    //đèn LED
    Paint centerDot = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellowAccent
      ..strokeWidth = 4.0;

    Paint secondaryDot = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..strokeWidth = 4.0;

    //Tọa độ giữa cung tròn
    Offset centerSlice = Offset(radius, 0);

    //hệ số tọa độ chênh lệch 2 đầu cung tròn
    double dxFactor = math.sin(angle / 2) * radius;
    double dyFactor = math.cos(angle / 2) * radius;

    Offset rightSlice = Offset(radius - dxFactor, radius - dyFactor);
    Offset leftSlice = Offset(radius + dxFactor, radius - dyFactor);

    canvas.drawPath(pathFirst, outlineBrush);
    canvas.drawPath(pathSecond, outlineBrushSecond);
    canvas.drawCircle(centerSlice, radiusDot, centerDot);
    canvas.drawCircle(rightSlice, radiusDot, secondaryDot);
    canvas.drawCircle(leftSlice, radiusDot, secondaryDot);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _SlicesPath extends CustomClipper<Path> {
  final double angle;

  _SlicesPath(this.angle);

  @override
  Path getClip(Size size) {
    Offset center = size.center(Offset.zero);
    Rect rect = Rect.fromCircle(center: center, radius: size.width / 2 - 7);
    Path path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, -math.pi / 2 - angle / 2, angle, false)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(_SlicesPath oldClipper) {
    return angle != oldClipper.angle;
  }
}
