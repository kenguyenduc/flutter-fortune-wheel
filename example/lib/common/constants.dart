import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Constants {
  Constants._();

  static List<Fortune> list8Item = <Fortune>[
    Fortune(id: 1, titleName: '1', backgroundColor: Colors.primaries[0]),
    Fortune(id: 2, titleName: '2', backgroundColor: Colors.primaries[2]),
    Fortune(id: 3, titleName: '3', backgroundColor: Colors.primaries[4]),
    Fortune(id: 4, titleName: '4', backgroundColor: Colors.primaries[6]),
    Fortune(id: 5, titleName: '5', backgroundColor: Colors.primaries[8]),
    Fortune(id: 6, titleName: '6', backgroundColor: Colors.primaries[10]),
    Fortune(id: 7, titleName: '7', backgroundColor: Colors.primaries[12]),
    Fortune(id: 8, titleName: '8', backgroundColor: Colors.primaries[14]),
    Fortune(id: 9, titleName: '9', backgroundColor: Colors.primaries[1]),
    Fortune(id: 10, titleName: '10', backgroundColor: Colors.primaries[2]),
    Fortune(id: 11, titleName: '11', backgroundColor: Colors.primaries[3]),
    Fortune(id: 12, titleName: '12', backgroundColor: Colors.primaries[4]),
  ];

  static List<Fortune> list3Item = <Fortune>[
    Fortune(
        id: 1,
        titleName: '1',
        backgroundColor: Colors.primaries[0],
        icon: const Icon(Icons.person_sharp)),
    Fortune(
        id: 2,
        titleName: '2',
        backgroundColor: Colors.primaries[2],
        icon: const Icon(Icons.favorite)),
    Fortune(
        id: 3,
        titleName: '3',
        backgroundColor: Colors.primaries[4],
        icon: const Icon(Icons.star)),
  ];

  static List<Fortune> numbers = <Fortune>[
    Fortune(
        id: 1,
        titleName: '1',
        backgroundColor: Colors.primaries[0],
        priority: 1),
    Fortune(
        id: 2,
        titleName: '2',
        backgroundColor: Colors.primaries[2],
        priority: 1),
    Fortune(
        id: 3,
        titleName: '3',
        backgroundColor: Colors.primaries[4],
        priority: 1),
    Fortune(
        id: 4,
        titleName: '4',
        backgroundColor: Colors.primaries[6],
        priority: 1),
    Fortune(
        id: 5,
        titleName: '5',
        backgroundColor: Colors.primaries[8],
        priority: 1),
    Fortune(
        id: 6,
        titleName: '6',
        backgroundColor: Colors.primaries[10],
        priority: 1),
    Fortune(
        id: 7,
        titleName: '7',
        backgroundColor: Colors.primaries[12],
        priority: 1),
    Fortune(
        id: 8,
        titleName: '8',
        backgroundColor: Colors.primaries[14],
        priority: 1),
    Fortune(
        id: 9,
        titleName: '9',
        backgroundColor: Colors.primaries[9],
        priority: 1),
    Fortune(
        id: 10,
        titleName: '10',
        backgroundColor: Colors.primaries[1],
        priority: 1),
    Fortune(
        id: 11,
        titleName: '11',
        backgroundColor: Colors.primaries[8],
        priority: 1),
    Fortune(
        id: 12,
        titleName: '12',
        backgroundColor: Colors.primaries[12],
        priority: 1),
    Fortune(
        id: 13,
        titleName: '13',
        backgroundColor: Colors.primaries[5],
        priority: 1),
    Fortune(
        id: 14,
        titleName: '14',
        backgroundColor: Colors.primaries[6],
        priority: 1),
    Fortune(
        id: 15,
        titleName: '15',
        backgroundColor: Colors.primaries[4],
        priority: 1),
    Fortune(
        id: 16,
        titleName: '16',
        backgroundColor: Colors.primaries[7],
        priority: 1),
  ];

  ///Ai sẽ phải uống?
  static List<Fortune> actionDrinkBeerList = <Fortune>[
    Fortune(
        id: 1, titleName: 'Uống 0.5 ly', backgroundColor: Colors.primaries[14]),
    Fortune(
        id: 2,
        titleName: 'Bên trái uống 1 ly',
        backgroundColor: Colors.primaries[2]),
    Fortune(
        id: 3, titleName: 'Qua tua', backgroundColor: Colors.primaries[4]),
    Fortune(
        id: 4,
        titleName: 'Chỉ ai đó bất kỳ uống',
        backgroundColor: Colors.primaries[6]),
    Fortune(
        id: 5, titleName: 'Quay lại', backgroundColor: Colors.primaries[8]),
    Fortune(
        id: 6, titleName: 'Được ăn mồi', backgroundColor: Colors.primaries[10]),
    Fortune(
        id: 7, titleName: 'Uống 2 ly', backgroundColor: Colors.primaries[12]),
    Fortune(
        id: 8,
        titleName: 'Bên phải uống 1 ly',
        backgroundColor: Colors.primaries[3]),
    Fortune(
        id: 9,
        titleName: 'Người tiếp theo',
        backgroundColor: Colors.primaries[4]),
  ];

  ///Có hoặc không?
  static List<Fortune> yesOrNo = <Fortune>[
    const Fortune(id: 1, titleName: 'YES', backgroundColor: Colors.red),
    const Fortune(id: 2, titleName: 'NO', backgroundColor: Colors.green),
    const Fortune(id: 3, titleName: 'YES', backgroundColor: Colors.amber),
    const Fortune(id: 4, titleName: 'NO', backgroundColor: Colors.red),
    const Fortune(id: 5, titleName: 'YES', backgroundColor: Colors.green),
    const Fortune(id: 6, titleName: 'NO', backgroundColor: Colors.amber),
    const Fortune(id: 7, titleName: 'YES', backgroundColor: Colors.red),
    const Fortune(id: 8, titleName: 'NO', backgroundColor: Colors.amber),
  ];

  ///Hôm nay ăn gì?
  static List<Fortune> todayWhatDoEat = <Fortune>[
    const Fortune(id: 1, titleName: 'Phở', backgroundColor: Colors.red),
    const Fortune(
        id: 2, titleName: 'Cơm gà', backgroundColor: Colors.green),
    const Fortune(
        id: 3,
        titleName: 'Cơm chiên dương châu',
        backgroundColor: Colors.amber),
    const Fortune(
        id: 4, titleName: 'Bún rêu cua', backgroundColor: Colors.red),
    const Fortune(
        id: 5, titleName: 'Bánh mì', backgroundColor: Colors.green),
    const Fortune(
        id: 6, titleName: 'Hải sản', backgroundColor: Colors.amber),
    const Fortune(id: 7, titleName: 'Cơm tấm', backgroundColor: Colors.red),
    const Fortune(id: 8, titleName: 'Pizza', backgroundColor: Colors.amber),
  ];

  ///Yêu hoặc không yêu?
  static List<Fortune> loveOrNotLove = <Fortune>[
    const Fortune(id: 1, titleName: 'Yêu', backgroundColor: Colors.red),
    const Fortune(
        id: 2, titleName: 'Không yêu', backgroundColor: Colors.green),
    const Fortune(id: 3, titleName: 'Yêu', backgroundColor: Colors.amber),
    const Fortune(
        id: 4, titleName: 'Không yêu', backgroundColor: Colors.pink),
    const Fortune(id: 5, titleName: 'Yêu', backgroundColor: Colors.blue),
    const Fortune(
        id: 6, titleName: 'Không yêu', backgroundColor: Colors.red),
    const Fortune(id: 7, titleName: 'Yêu', backgroundColor: Colors.green),
    const Fortune(
        id: 8, titleName: 'Không yêu', backgroundColor: Colors.amber),
    const Fortune(id: 9, titleName: 'Yêu', backgroundColor: Colors.pink),
    const Fortune(
        id: 10, titleName: 'Không yêu', backgroundColor: Colors.blue),
    const Fortune(id: 11, titleName: 'Yêu', backgroundColor: Colors.red),
    const Fortune(
        id: 12, titleName: 'Không yêu', backgroundColor: Colors.green),
  ];
}
