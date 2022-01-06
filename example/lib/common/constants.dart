import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Constants {
  Constants._();

  static List<FortuneItem> fortuneValues = <FortuneItem>[
    FortuneItem('1', Colors.accents[0]),
    FortuneItem('2', Colors.accents[2]),
    FortuneItem('3', Colors.accents[4]),
    FortuneItem('4', Colors.accents[6]),
    FortuneItem('5', Colors.accents[8]),
    FortuneItem('6', Colors.accents[10]),
    FortuneItem('7', Colors.accents[12]),
    FortuneItem('8', Colors.accents[14]),
  ];

  static List<FortuneItem> list3Item = <FortuneItem>[
    FortuneItem('1', Colors.accents[0], icon: const Icon(Icons.person_sharp)),
    FortuneItem('2', Colors.accents[2], icon: const Icon(Icons.favorite)),
    FortuneItem('3', Colors.accents[4], icon: const Icon(Icons.star)),
  ];

  static List<FortuneItem> listPrioty = <FortuneItem>[
    FortuneItem('1', Colors.accents[0], priority: 1),
    FortuneItem('2', Colors.accents[2], priority: 1),
    FortuneItem('3', Colors.accents[4], priority: 1),
    FortuneItem('4', Colors.accents[6], priority: 1),
    FortuneItem('5', Colors.accents[8], priority: 1),
    FortuneItem('6', Colors.accents[10], priority: 1),
    FortuneItem('7', Colors.accents[12], priority: 1),
    FortuneItem('8', Colors.accents[14], priority: 1),
    FortuneItem('9', Colors.accents[9], priority: 1),
    FortuneItem('10', Colors.accents[1], priority: 1),
    FortuneItem('11', Colors.accents[8], priority: 1),
    FortuneItem('12', Colors.accents[12], priority: 1),
    FortuneItem('13', Colors.accents[5], priority: 1),
    FortuneItem('14', Colors.accents[6], priority: 1),
    FortuneItem('15', Colors.accents[4], priority: 1),
    FortuneItem('16', Colors.accents[7], priority: 1),
    FortuneItem('17', Colors.accents[12], priority: 1),
    FortuneItem('18', Colors.accents[14], priority: 1),
    FortuneItem('19', Colors.accents[11], priority: 1),
    FortuneItem('20', Colors.accents[10], priority: 1),
  ];

  static List<FortuneItem> listAnNhau = <FortuneItem>[
    FortuneItem('Người tiếp theo', Colors.accents[4]),
    FortuneItem('Uống 0.5 ly', Colors.accents[14]),
    FortuneItem('Bên trái uống 1 ly', Colors.accents[2]),
    FortuneItem('Qua tua', Colors.accents[4]),
    FortuneItem('Chỉ ai đó bất kỳ uống', Colors.accents[6]),
    FortuneItem('Quay lại', Colors.accents[8]),
    FortuneItem('Được ăn mồi', Colors.accents[10]),
    FortuneItem('Uống 2 ly', Colors.accents[12]),
    FortuneItem('Bên phải uống 1 ly', Colors.accents[3]),
  ];
}
