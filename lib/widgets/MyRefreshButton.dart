import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyRefreshIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyRefreshIconButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExcludeFocusTraversal(
      child: Tooltip(
        message: 'Refresh (Shift+R)',
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(
            Icons.refresh,
            color: Color(0xFF418BFB),
          ),
          label: Text(
            'Refresh',
            style: TextStyle(color: Color(0xFF418BFB)),
          ),
        ),
      ),
    );
  }
}
