import 'package:flutter/material.dart';

class MyPrintButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyPrintButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExcludeFocusTraversal(
      child: Tooltip(
        message: 'Print (Ctrl+P)',
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(
            Icons.print,
            color: Color(0x960D30E3),
          ),
          label: Text(
            'PRINT',
            style: TextStyle(color: Color(0x960D30E3)),
          ),
        ),
      ),
    );
  }
}
