import 'package:flutter/material.dart';

class MyAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final double width;
  final FocusNode? focusNode;
  final String message;

  const MyAddButton({
    super.key,
    required this.onPressed,
    this.focusNode,
    this.color = const Color(0xFF5700BC),
    this.width = 180,
    this.message = "Add (Ctrl+S)",
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: OutlinedButton(
        focusNode: focusNode,
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(width, 46)),
          foregroundColor:
              WidgetStateProperty.resolveWith((states) => Colors.white),
          shape: WidgetStateProperty.resolveWith((s) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return color;
            }
            return Colors.blue;
          }),
        ),
        child: const Text('ADD'),
      ),
    );
  }
}
