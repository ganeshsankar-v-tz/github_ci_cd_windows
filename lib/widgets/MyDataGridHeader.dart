import 'package:flutter/widgets.dart';

class MyDataGridHeader extends StatelessWidget {
  final String title;
  final Alignment alignment;
  final Color? color;

  const MyDataGridHeader({
    super.key,
    required this.title,
    this.alignment = Alignment.centerLeft,
    this.color = const Color(0XFF5700BC),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: alignment,
      child: Text(
        title,
        softWrap: false,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color,
          fontSize: 15,
        ),
      ),
    );
  }
}
