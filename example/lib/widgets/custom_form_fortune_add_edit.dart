import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

///UI Form sửa thông tin giá trị vòng quay
class CustomFormFortuneAddEdit extends StatefulWidget {
  const CustomFormFortuneAddEdit({
    Key? key,
    required this.fortuneItem,
    required this.onChanged,
    this.isInsert = false,
  }) : super(key: key);

  final Fortune fortuneItem;
  final Function(Fortune fortuneItem) onChanged;
  final bool isInsert;

  @override
  _CustomFormFortuneAddEditState createState() =>
      _CustomFormFortuneAddEditState();
}

class _CustomFormFortuneAddEditState extends State<CustomFormFortuneAddEdit> {
  final TextEditingController _titleItemController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Fortune _fortuneItem;

  @override
  void initState() {
    super.initState();
    _fortuneItem = widget.fortuneItem;
    _titleItemController.text = _fortuneItem.titleName?.replaceAll('\n', '')  ?? '';
    _priorityController.text = _fortuneItem.priority.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _titleItemController.dispose();
    _priorityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isInsert ? 'Thêm giá trị may mắn' : 'Sửa giá trị may mắn',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleItemController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên',
                      labelText: 'Tên',
                    ),
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'Tên không được để trống'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _priorityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Nhập hệ số',
                      labelText: 'Hệ số ưu tiên',
                    ),
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? 'Hệ số ưu tiên không được để trống'
                          : null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Chọn màu nền: '),
                const SizedBox(width: 16),
                DropdownButton<Color>(
                  value: _fortuneItem.backgroundColor,
                  elevation: 16,
                  icon: Container(
                    height: 24,
                    width: 24,
                    color: _fortuneItem.backgroundColor,
                  ),
                  style: TextStyle(color: _fortuneItem.backgroundColor),
                  underline: const SizedBox(),
                  onChanged: (Color? newValue) {
                    setState(() {
                      _fortuneItem =
                          _fortuneItem.copyWith(backgroundColor: newValue!);
                    });
                  },
                  items: Colors.primaries
                      .map<DropdownMenuItem<Color>>((Color value) {
                    return DropdownMenuItem<Color>(
                      value: value,
                      child: Container(
                        color: value,
                        height: 20,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _fortuneItem = _fortuneItem.copyWith(
                        titleName: _titleItemController.text,
                        priority: int.tryParse(_priorityController.text),
                      );
                      widget.onChanged.call(_fortuneItem);
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
