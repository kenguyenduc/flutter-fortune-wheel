import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_fortune_wheel_example/common/constants.dart';
import 'package:flutter_fortune_wheel_example/widgets/custom_form_fortune_add_edit.dart';
import 'package:flutter_fortune_wheel_example/widgets/fortune_item.dart';
import 'package:flutter_fortune_wheel_example/widgets/fortune_template.dart';
import '../models/wheel.dart';

class FortuneWheelSettingPage extends StatefulWidget {
  const FortuneWheelSettingPage({
    Key? key,
    required this.wheel,
  }) : super(key: key);

  final Wheel wheel;

  @override
  _FortuneWheelSettingPageState createState() =>
      _FortuneWheelSettingPageState();
}

class _FortuneWheelSettingPageState extends State<FortuneWheelSettingPage> {
  late Wheel _wheel;

  final TextEditingController _durationWheelController =
      TextEditingController();

  late final StreamController<bool> _fortuneValuesController;

  @override
  void initState() {
    super.initState();
    _wheel = widget.wheel;
    _durationWheelController.text = _wheel.duration.inSeconds.toString();
    _fortuneValuesController = StreamController<bool>.broadcast();
  }

  @override
  void dispose() {
    super.dispose();
    _durationWheelController.dispose();
    _fortuneValuesController.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleConfirmBack();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Cấu hình'),
            actions: [
              IconButton(
                splashRadius: 28,
                tooltip: 'Save',
                onPressed: () {
                  Navigator.pop(context, _wheel);
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              _buildGameMode(),
              _buildDuration(),
              _buildExpansionFortuneValues(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleConfirmBack() {
    Widget cancelButton = TextButton(
      child: const Text('Hủy'),
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
    );
    Widget okButton = TextButton(
      child: const Text('Xác nhận'),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        primary: Colors.blue,
      ),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Thông báo'),
      content: const Text(
          'Bạn có chắc chắn muốn trở mà không lưu cấu hình đã thay đổi?'),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildGameMode() {
    return ListTile(
      title: const Text(
        'Chế độ quay',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0.0,
            visualDensity: const VisualDensity(vertical: -4, horizontal: 0),
            onTap: () {
              setState(() {
                _wheel = _wheel.copyWith(isGoByPriority: true);
              });
            },
            title: const Text('Theo ưu tiên'),
            leading: Radio<bool>(
              value: true,
              groupValue: _wheel.isGoByPriority,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (_) {
                setState(() {
                  _wheel = _wheel.copyWith(isGoByPriority: true);
                });
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0.0,
            visualDensity: const VisualDensity(vertical: -4, horizontal: 0),
            title: const Text('Theo ngẫu nhiên'),
            onTap: () {
              setState(() {
                _wheel = _wheel.copyWith(isGoByPriority: false);
              });
            },
            leading: Radio<bool>(
              value: false,
              groupValue: _wheel.isGoByPriority,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (_) {
                setState(() {
                  _wheel = _wheel.copyWith(isGoByPriority: false);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuration() {
    return ListTile(
      title: Row(
        children: [
          const Text(
            'Thời gian quay (s)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              int second = int.tryParse(_durationWheelController.text) ?? 0;
              if (second > 1) {
                second--;
                _wheel = _wheel.copyWith(duration: Duration(seconds: second));
                _durationWheelController.text = second.toString();
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: Transform.rotate(
                angle: pi / 2,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: TextField(
              controller: _durationWheelController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Nhập thời gian'),
              onChanged: (String? value) {
                if (value == '') {
                  _durationWheelController.text = '1';
                }
                int? second = int.tryParse(_durationWheelController.text);
                if (second != null) {
                  _wheel = _wheel.copyWith(duration: Duration(seconds: second));
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              int second = int.tryParse(_durationWheelController.text) ?? 0;
              second++;
              _wheel = _wheel.copyWith(duration: Duration(seconds: second));
              _durationWheelController.text = second.toString();
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: Transform.rotate(
                angle: -pi / 2,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionFortuneValues() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: const Text(
        'Giá trị vòng quay',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: [
        Row(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    onPressed: _handleInsertItem,
                    child: const Text('+ Thêm mới'))),
            const SizedBox(width: 16),
            Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    onPressed: _handleGetDefaultTemplate,
                    child: const Text('Chọn mẫu mặc định'))),
          ],
        ),
        _buildFortuneValues(),
      ],
    );
  }

  Widget _buildFortuneValues() {
    return StreamBuilder<bool>(
      stream: _fortuneValuesController.stream,
      builder: (context, snapshot) {
        return ListView.separated(
          key: const ValueKey<String>('FortuneValues'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _wheel.fortuneValues.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) => FortuneItem(
            key: ValueKey<String>(
                'fortuneWheelItem<${_wheel.fortuneValues[index].id}>'),
            fortune: _wheel.fortuneValues[index],
            onEditPressed: () => _handleEditFortuneItemPressed(index),
            onDeletePressed: () => _handleDeleteFortuneItemPressed(index),
          ),
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }

  void _handleGetDefaultTemplate() {
    List<FortuneTemplate> templates = <FortuneTemplate>[
      FortuneTemplate(
        title: 'Ai sẽ phải uống?',
        fortuneValues: Constants.actionDrinkBeerList,
        onPressed: () {
          _wheel =
              _wheel.copyWith(fortuneValues: Constants.actionDrinkBeerList);
          _fortuneValuesController.sink.add(true);
          Navigator.pop(context);
        },
      ),
      FortuneTemplate(
        title: 'Hôm nay ăn gì?',
        fortuneValues: Constants.todayWhatDoEat,
        onPressed: () {
          _wheel = _wheel.copyWith(fortuneValues: Constants.todayWhatDoEat);
          _fortuneValuesController.sink.add(true);
          Navigator.pop(context);
        },
      ),
      FortuneTemplate(
        title: 'Có hoặc không?',
        fortuneValues: Constants.yesOrNo,
        onPressed: () {
          _wheel = _wheel.copyWith(fortuneValues: Constants.yesOrNo);
          _fortuneValuesController.sink.add(true);
          Navigator.pop(context);
        },
      ),
      FortuneTemplate(
        title: 'Yêu hoặc không yêu?',
        fortuneValues: Constants.loveOrNotLove,
        onPressed: () {
          _wheel = _wheel.copyWith(fortuneValues: Constants.loveOrNotLove);
          _fortuneValuesController.sink.add(true);
          Navigator.pop(context);
        },
      ),
      FortuneTemplate(
        title: 'Chọn số (1- 12)',
        fortuneValues: Constants.list12Item,
        onPressed: () {
          _wheel = _wheel.copyWith(fortuneValues: Constants.list12Item);
          _fortuneValuesController.sink.add(true);
          Navigator.pop(context);
        },
      ),
      FortuneTemplate(
        title: 'Chọn số (1- 16)',
        fortuneValues: Constants.numbers,
        onPressed: () {
          _wheel = _wheel.copyWith(fortuneValues: Constants.numbers);
          _fortuneValuesController.sink.add(true);
          Navigator.pop(context);
        },
      ),
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn mẫu mặc định'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: templates,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleInsertItem() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: CustomFormFortuneAddEdit(
            isInsert: true,
            fortuneItem: Fortune(
              id: _wheel.fortuneValues.length + 1,
              titleName: '',
              backgroundColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ),
            onChanged: (fortuneItem) {
              _wheel.fortuneValues.add(fortuneItem);
              _fortuneValuesController.sink.add(true);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _handleEditFortuneItemPressed(int index) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: CustomFormFortuneAddEdit(
            fortuneItem: _wheel.fortuneValues[index],
            onChanged: (fortuneItem) {
              _wheel.fortuneValues[index] = fortuneItem;
              _fortuneValuesController.sink.add(true);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _handleDeleteFortuneItemPressed(int index) {
    Widget cancelButton = TextButton(
      child: const Text('Hủy'),
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
    );
    Widget okButton = TextButton(
      child: const Text('Xác nhận'),
      onPressed: () {
        Navigator.pop(context);
        _wheel.fortuneValues.removeAt(index);
        _fortuneValuesController.sink.add(true);
      },
      style: TextButton.styleFrom(
        primary: Colors.blue,
      ),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Thông báo'),
      content: const Text('Bạn có chắc chắn muốn xóa giá trị này?'),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
