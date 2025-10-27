import 'package:flutter/material.dart';

class AddItemsElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final double width;
  final String toolTip;
  final bool enabled;
  final FocusNode? focusNode;

  const AddItemsElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.width = 100,
      this.toolTip = 'Ctrl+N',
      this.color = const Color(0xFFDF30B8),
      this.enabled = true,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTip,
      child: OutlinedButton(
        focusNode: focusNode,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(width, 40)),
          foregroundColor:
              WidgetStateProperty.resolveWith((states) => Colors.white),
          shape: WidgetStateProperty.resolveWith((s) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return Colors.orange;
            }
            return color;
          }),
        ),
        /*tooltip: 'Ctrl+N',
        elevation: 0,
        backgroundColor: color,
        avatar: Image.asset('assets/images/ic_add_item.png', color: Colors.white,),
        shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
        label: const Text('Add Item', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),*/
        onPressed: enabled ? onPressed : null,
        child: const Text(
          'Add Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );

    /*return Container(
      width: width,
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset('assets/images/ic_add_item.png'),
        label: child,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(42),
          backgroundColor: color,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );*/
  }
}
