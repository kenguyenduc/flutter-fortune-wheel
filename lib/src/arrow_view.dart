import 'dart:math';
import 'package:flutter/material.dart';

///Ui Mũi tên chọn giá trị vòng quay
class ArrowView extends StatelessWidget {
  const ArrowView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Align(
    //   // alignment: const Alignment(1.1, 0),
    //   alignment: Alignment.center,
    //   child: Padding(
    //     padding: const EdgeInsets.only(top: 80),
    //     child: ClipPath(
    //       clipper: _ArrowClipper(),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           gradient: const LinearGradient(
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter,
    //             // colors: [Colors.redAccent, Colors.red],
    //             colors: [Colors.black12, Colors.black],
    //           ),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withOpacity(0.07),
    //               blurRadius: 15,
    //             ),
    //           ],
    //         ),
    //         height: 40,
    //         width: 40,
    //       ),
    //     ),
    //   ),
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
                  // colors: [Colors.redAccent, Colors.red],
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

    ///size 40, 40
    ///Offset(20.0, 20.0)
    ///
    // _path.moveTo(size.width, 0);
    // _path.lineTo(0, _center.dy);
    // _path.lineTo(size.width, size.height);
    // _path.lineTo(_center.dx, _center.dy);

    // Offset _centerRight = size.centerRight(Offset.zero);
    // _path.moveTo(_centerRight.dx, size.height / 2);
    // _path.lineTo(_centerRight.dx, size.height * 1.5);
    // _path.lineTo(0, _centerRight.dy);
    // _path.lineTo(0, size.height / 2);

    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
