import 'package:flutter/material.dart';

import 'models/wheel.dart';

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
  ///Chế độ quay có theo ưu tiên giá trị trúng hay không
  bool _isGoByPriority = true;
  late Wheel _wheel;

  @override
  void initState() {
    super.initState();
    _wheel = widget.wheel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tùy chỉnh'),
        actions: [
          IconButton(
            splashRadius: 28,
            tooltip: 'Cài đặt',
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          _buildGameMode(),
          _buildSlicesEdit(),
        ],
      ),
    );
  }

  Widget _buildGameMode() {
    return ExpansionTile(
      title: const Text('Chế độ xoay'),
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0.0,
          onTap: () {
            setState(() {
              _isGoByPriority = true;
            });
          },
          title: const Text('Theo ưu tiên'),
          leading: Radio<bool>(
            value: true,
            groupValue: _isGoByPriority,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) {
              setState(() {
                _isGoByPriority = true;
              });
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0.0,
          title: const Text('Theo ngẫu nhiên'),
          onTap: () {
            setState(() {
              _isGoByPriority = false;
            });
          },
          leading: Radio<bool>(
            value: false,
            groupValue: _isGoByPriority,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) {
              setState(() {
                _isGoByPriority = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlicesEdit() {
    return ExpansionTile(
      title: Text('Chỉnh sửa giá trị vòng quay'),
      children: [],
    );
  }
}
