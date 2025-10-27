import 'package:flutter/material.dart';

class MyAddItemsRemoveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String message;

  const MyAddItemsRemoveButton({
    super.key,
    required this.onPressed,
    this.message = "Remove (Ctrl+R)",
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocusTraversal(
      child: Tooltip(
        message: message,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.red,
          ),
          label: const Text(
            'REMOVE',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
