import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/arrow_view_center_right.dart';

///Ui Mũi tên chọn giá trị vòng quay
class ArrowView extends StatelessWidget {
  const ArrowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Align(
    //   alignment: Alignment(1.08, 0),
    //   child: ArrowViewCenterRight(),
    // );
    return Align(
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: pi,
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: ClipPath(
            clipper: _ArrowClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black12, Colors.black],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 15,
                  ),
                ],
              ),
              height: 40,
              width: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path _path = Path();
    Offset _center = size.center(Offset.zero);
    _path.lineTo(_center.dx, size.height);
    _path.lineTo(size.width, 0);
    _path.lineTo(_center.dx, _center.dy);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
