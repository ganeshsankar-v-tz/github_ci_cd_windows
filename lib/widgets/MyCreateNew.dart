import 'package:flutter/material.dart';

class MyCreateNew extends StatelessWidget {
  final VoidCallback? onPressed;

  const MyCreateNew({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: Color(0xFFDDFFDC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),side: BorderSide(
        color: Color(0xFF00DE16), width: 0.4
      ),),
      label: const Text('Create New'),
      onPressed: onPressed,
    );
  }
}
