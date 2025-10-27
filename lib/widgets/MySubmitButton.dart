import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;
  final double width;
  final bool enabled;
  final String message;
  final FocusNode? focusNode;

  const MySubmitButton({
    super.key,
    required this.onPressed,
    this.color = const Color(0xFF5700BC),
    this.width = 180,
    this.enabled = true,
    this.message = "Submit (Ctrl+S)",
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: OutlinedButton(
        focusNode: focusNode,
        onPressed: enabled ? onPressed : null,
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
        child: const Text('SUBMIT'),
      ),
    );
  }
}
