import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneItem extends StatelessWidget {
  const FortuneItem({
    Key? key,
    required this.fortune,
    this.isShowAction = true,
    this.onEditPressed,
    this.onDeletePressed,
  }) : super(key: key);

  final Fortune fortune;
  final bool isShowAction;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fortune.titleName != null)
                Flexible(
                  child: Text(
                    fortune.titleName?.replaceAll('\n', '') ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (fortune.titleName != null) const SizedBox(width: 16),
              fortune.icon ?? const SizedBox(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              Text(
                '  x' + fortune.priority.toString(),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(width: 24),
              CircleAvatar(
                radius: 12,
                backgroundColor: fortune.backgroundColor,
              ),
            ],
          ),
        ],
      ),
      trailing: isShowAction
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEditPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDeletePressed,
                ),
              ],
            )
          : null,
    );
  }
}
