import 'package:flutter/material.dart';

class MyFilterIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool filterIcon;
  final String? tooltipText;

  const MyFilterIconButton({
    Key? key,
    required this.onPressed,
    this.filterIcon = false,
    this.tooltipText = "null",
  }) : super(key: key);

  @override
  State<MyFilterIconButton> createState() => _MyFilterIconButtonState();
}

class _MyFilterIconButtonState extends State<MyFilterIconButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeFocusTraversal(
      child: Tooltip(
        message: widget.tooltipText! == "null"
            ? 'Filter (Ctrl+F)'
            : 'Filter (Ctrl+F) ${widget.tooltipText!}',
        child: TextButton.icon(
          onPressed: widget.onPressed,
          icon: widget.filterIcon
              ? Image.asset(
                  'assets/images/isFilter.png',
                  color: const Color(0xF5188112),
                  width: 24,
                  height: 24,
                )
              : Image.asset(
                  'assets/images/filter.png',
                  color: const Color(0xF5188112),
                  width: 24,
                  height: 24,
                ),
          label: const Text(
            'FILTER',
            style: TextStyle(color: Color(0xF5188112)),
          ),
        ),
      ),
    );
  }
}
