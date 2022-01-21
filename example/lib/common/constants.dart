import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Constants {
  Constants._();

  static List<Fortune> list8Item = <Fortune>[
    Fortune(
        id: 1,
        titleName: '1',
        backgroundColor: Colors.primaries[0],
        priority: 10),
    Fortune(
        id: 2,
        titleName: '2',
        backgroundColor: Colors.primaries[2],
        priority: 5),
    Fortune(
        id: 3,
        titleName: '3',
        backgroundColor: Colors.primaries[4],
        priority: 2),
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

  static List<Fortune> list12Item = <Fortune>[
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
  ];

  static List<Fortune> numbers160 = List.generate(
    160,
    (index) => Fortune(
        id: index + 1,
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        titleName: '${index + 1}'),
  );
  static List<Fortune> numbers100 = List.generate(
    100,
    (index) => Fortune(
        id: index + 1,
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        titleName: '${index + 1}'),
  );

  static List<Fortune> numbers = <Fortune>[
    Fortune(
        id: 1,
        titleName: '1',
        backgroundColor: Colors.primaries[0],
        priority: 10),
    Fortune(
        id: 2,
        titleName: '2',
        backgroundColor: Colors.primaries[2],
        priority: 20),
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
    Fortune(id: 3, titleName: 'Qua tua', backgroundColor: Colors.primaries[4]),
    Fortune(
        id: 4,
        titleName: 'Chỉ ai đó bất kỳ uống',
        backgroundColor: Colors.primaries[6]),
    Fortune(id: 5, titleName: 'Quay lại', backgroundColor: Colors.primaries[8]),
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
      id: 2,
      titleName: 'Cơm gà',
      backgroundColor: Colors.green,
      priority: 10,
    ),
    const Fortune(
        id: 3,
        titleName: 'Cơm chiên dương châu',
        backgroundColor: Colors.amber),
    const Fortune(id: 4, titleName: 'Bún rêu cua', backgroundColor: Colors.red),
    const Fortune(id: 5, titleName: 'Bánh mì', backgroundColor: Colors.green),
    const Fortune(id: 6, titleName: 'Hải sản', backgroundColor: Colors.amber),
    const Fortune(id: 7, titleName: 'Cơm tấm', backgroundColor: Colors.red),
    const Fortune(id: 8, titleName: 'Pizza', backgroundColor: Colors.amber),
  ];

  static List<Fortune> todayWhatDoEat2 = <Fortune>[
    const Fortune(id: 1, titleName: 'Cơm tấm', backgroundColor: Colors.red),
    const Fortune(id: 2, titleName: 'Cơm gà', backgroundColor: Colors.green),
    const Fortune(id: 3, titleName: 'Bún thái', backgroundColor: Colors.amber),
    const Fortune(
        id: 4, titleName: 'Cơm gà xối mỡ', backgroundColor: Colors.blue),
    const Fortune(id: 5, titleName: 'Cơm sườn', backgroundColor: Colors.blue),
  ];

  ///Yêu hoặc không yêu?
  static List<Fortune> loveOrNotLove = <Fortune>[
    const Fortune(id: 1, titleName: 'Yêu', backgroundColor: Colors.red),
    const Fortune(id: 2, titleName: 'Không yêu', backgroundColor: Colors.green),
    const Fortune(id: 3, titleName: 'Yêu', backgroundColor: Colors.amber),
    const Fortune(id: 4, titleName: 'Không yêu', backgroundColor: Colors.pink),
    const Fortune(id: 5, titleName: 'Yêu', backgroundColor: Colors.blue),
    const Fortune(id: 6, titleName: 'Không yêu', backgroundColor: Colors.red),
    const Fortune(id: 7, titleName: 'Yêu', backgroundColor: Colors.green),
    const Fortune(id: 8, titleName: 'Không yêu', backgroundColor: Colors.amber),
  ];

  static List<Fortune> icons = <Fortune>[
    const Fortune(
        id: 1,
        backgroundColor: Colors.red,
        icon: Icon(
          Icons.favorite,
          color: Colors.white,
        )),
    const Fortune(
        id: 2,
        backgroundColor: Colors.green,
        icon: Icon(
          Icons.lock_clock,
          color: Colors.white,
        )),
    const Fortune(
        id: 3,
        backgroundColor: Colors.amber,
        icon: Icon(
          Icons.car_rental,
          color: Colors.white,
        )),
    const Fortune(
        id: 4,
        backgroundColor: Colors.red,
        icon: Icon(
          Icons.phone_android_outlined,
          color: Colors.white,
        )),
    const Fortune(
        id: 5,
        backgroundColor: Colors.green,
        icon: Icon(
          Icons.house_outlined,
          color: Colors.white,
        )),
    const Fortune(
        id: 6,
        backgroundColor: Colors.amber,
        icon: Icon(
          Icons.security,
          color: Colors.white,
        )),
    const Fortune(
        id: 7,
        backgroundColor: Colors.red,
        icon: Icon(
          Icons.perm_camera_mic_sharp,
          color: Colors.white,
        )),
    const Fortune(
        id: 8,
        backgroundColor: Colors.amber,
        icon: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        )),
  ];

  static List<Fortune> icons2 = <Fortune>[
    const Fortune(
        id: 1,
        backgroundColor: Colors.red,
        titleName: 'favorite',
        icon: Icon(
          Icons.favorite,
          color: Colors.white,
        )),
    const Fortune(
        id: 2,
        backgroundColor: Colors.green,
        titleName: 'clock',
        icon: Icon(
          Icons.lock_clock,
          color: Colors.white,
        )),
    const Fortune(
        id: 3,
        backgroundColor: Colors.amber,
        titleName: 'car',
        icon: Icon(
          Icons.car_rental,
          color: Colors.white,
        )),
    const Fortune(
        id: 4,
        backgroundColor: Colors.red,
        titleName: 'phone',
        icon: Icon(
          Icons.phone_android_outlined,
          color: Colors.white,
        )),
    const Fortune(
        id: 5,
        backgroundColor: Colors.green,
        titleName: 'house',
        icon: Icon(
          Icons.house_outlined,
          color: Colors.white,
        )),
    const Fortune(
        id: 6,
        backgroundColor: Colors.amber,
        titleName: 'security',
        icon: Icon(
          Icons.security,
          color: Colors.white,
        )),
    const Fortune(
        id: 7,
        backgroundColor: Colors.red,
        titleName: 'Micro',
        icon: Icon(
          Icons.perm_camera_mic_sharp,
          color: Colors.white,
        )),
    const Fortune(
        id: 8,
        backgroundColor: Colors.amber,
        titleName: 'Camera',
        icon: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        )),
  ];

  static List<Fortune> liXiNamMoi = [
    //5-2 10-5 20-30 50-20 100-10 200-5 500-1
    const Fortune(
      id: 1,
      backgroundColor: Colors.amber,
      titleName: 'Lì xì \n5K',
      priority: 2,
    ),
    const Fortune(
      id: 2,
      backgroundColor: Colors.red,
      titleName: 'Lì xì \n10K',
      priority: 5,
    ),
    const Fortune(
      id: 3,
      backgroundColor: Colors.green,
      titleName: 'Lì xì \n20K',
      priority: 30,
    ),
    const Fortune(
      id: 4,
      backgroundColor: Colors.amber,
      titleName: 'Lì xì \n50K',
      priority: 20,
    ),
    const Fortune(
      id: 5,
      backgroundColor: Colors.red,
      titleName: 'Lì xì \n100K',
      priority: 10,
    ),
    const Fortune(
      id: 6,
      backgroundColor: Colors.green,
      titleName: 'Lì xì \n200K',
      priority: 5,
    ),
    const Fortune(
      id: 7,
      backgroundColor: Colors.amber,
      titleName: 'Lì xì \n500K',
      priority: 1,
    ),
    const Fortune(
      id: 8,
      backgroundColor: Colors.green,
      titleName: 'Chúc bạn may mắn lần sau',
      priority: 5,
    ),
  ];
}
