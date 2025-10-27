import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keymap/keymap.dart';

class MyAddItemButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyAddItemButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'New (Ctrl+N)',
      child: OutlinedButton.icon(
        icon: const Icon(Icons.add),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        label: const Text('New'),
      ),
    );
  }
}
