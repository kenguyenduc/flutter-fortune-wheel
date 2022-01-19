import 'dart:math';
import 'package:flutter/material.dart';

///A widget indicator, which is arrow spin result
class ArrowView extends StatelessWidget {
  const ArrowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 2,
      child: ClipPath(
        clipper: _ArrowClipper(),
        child: Container(
          height: 24,
          width: 24,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black12, Colors.black],
            ),
            boxShadow: [
              BoxShadow(color: Colors.black38, blurRadius: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset center = size.center(Offset.zero);
    Path path = Path()
      ..lineTo(center.dx, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(center.dx, size.height / 4);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
