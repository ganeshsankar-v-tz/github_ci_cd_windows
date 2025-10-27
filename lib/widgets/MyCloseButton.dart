import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keymap/keymap.dart';

class MyCloseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double width;

  const MyCloseButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color = Colors.blue,
    this.width = 180,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 38,
      child: Tooltip(
        message: 'Close (Ctrl+Q)',
        child: OutlinedButton(
          onPressed: onPressed,
          child: child,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(38),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
