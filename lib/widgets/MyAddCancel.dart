import 'package:flutter/material.dart';

class MyAddCancel extends StatelessWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;

  const MyAddCancel({
    Key? key,
    required this.onCancelPressed,
    required this.onSavePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onCancelPressed,
          child: Container(
            width: 200,
            height: 38,
            decoration: ShapeDecoration(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: const Center(
                child: Text(
              "Cancel",
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onSavePressed,
          child: Container(
            width: 200,
            height: 38,
            decoration: ShapeDecoration(
              color: const Color(0xff5700BC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: const Center(
                child: Text(
              "Add",
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )),
          ),
        ),
      ],
    );
  }
}
