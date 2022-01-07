import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Constants {
  Constants._();

  static List<FortuneItem> fortuneValues = <FortuneItem>[
    FortuneItem('1', Colors.primaries[0]),
    FortuneItem('2', Colors.primaries[2]),
    FortuneItem('3', Colors.primaries[4]),
    FortuneItem('4', Colors.primaries[6]),
    FortuneItem('5', Colors.primaries[8]),
    FortuneItem('6', Colors.primaries[10]),
    FortuneItem('7', Colors.primaries[12]),
    FortuneItem('8', Colors.primaries[14]),
    FortuneItem('9', Colors.primaries[1]),
    FortuneItem('10', Colors.primaries[2]),
    FortuneItem('11', Colors.primaries[3]),
    FortuneItem('12', Colors.primaries[4]),
  ];

  static List<FortuneItem> list3Item = <FortuneItem>[
    FortuneItem('1', Colors.primaries[0], icon: const Icon(Icons.person_sharp)),
    FortuneItem('2', Colors.primaries[2], icon: const Icon(Icons.favorite)),
    FortuneItem('3', Colors.primaries[4], icon: const Icon(Icons.star)),
  ];

  static List<FortuneItem> listPrioty = <FortuneItem>[
    FortuneItem('1', Colors.primaries[0], priority: 1),
    FortuneItem('2', Colors.primaries[2], priority: 1),
    FortuneItem('3', Colors.primaries[4], priority: 1),
    FortuneItem('4', Colors.primaries[6], priority: 1),
    FortuneItem('5', Colors.primaries[8], priority: 1),
    FortuneItem('6', Colors.primaries[10], priority: 1),
    FortuneItem('7', Colors.primaries[12], priority: 1),
    FortuneItem('8', Colors.primaries[14], priority: 1),
    FortuneItem('9', Colors.primaries[9], priority: 1),
    FortuneItem('10', Colors.primaries[1], priority: 1),
    FortuneItem('11', Colors.primaries[8], priority: 1),
    FortuneItem('12', Colors.primaries[12], priority: 1),
    FortuneItem('13', Colors.primaries[5], priority: 1),
    FortuneItem('14', Colors.primaries[6], priority: 1),
    FortuneItem('15', Colors.primaries[4], priority: 1),
    FortuneItem('16', Colors.primaries[7], priority: 1),
    FortuneItem('17', Colors.primaries[12], priority: 1),
    FortuneItem('18', Colors.primaries[14], priority: 1),
    FortuneItem('19', Colors.primaries[11], priority: 1),
    FortuneItem('20', Colors.primaries[10], priority: 1),
  ];

  static List<FortuneItem> listAnNhau = <FortuneItem>[
    FortuneItem('Uống 0.5 ly', Colors.primaries[14]),
    FortuneItem('Bên trái uống 1 ly', Colors.primaries[2]),
    FortuneItem('Qua tua', Colors.primaries[4]),
    FortuneItem('Chỉ ai đó bất kỳ uống', Colors.primaries[6]),
    FortuneItem('Quay lại', Colors.primaries[8]),
    FortuneItem('Được ăn mồi', Colors.primaries[10]),
    FortuneItem('Uống 2 ly', Colors.primaries[12]),
    FortuneItem('Bên phải uống 1 ly', Colors.primaries[3]),
    FortuneItem('Người tiếp theo', Colors.primaries[4]),
  ];
}
