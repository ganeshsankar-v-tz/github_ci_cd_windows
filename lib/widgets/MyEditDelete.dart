import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEditDelete extends StatelessWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const MyEditDelete({
    Key? key,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: Text("Are you sure you want to delete?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("CLOSE"),
                    onPressed: () => Get.back(),
                  ),
                  TextButton(
                    child: Text(
                      "DELETE",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Get.back();
                      onDeletePressed();
                    },
                  ),
                ],
              ),
            );
          },
          child: Image.asset(
            'assets/images/ic_delete.png',
            width: 24,
            height: 24,
          ),
        ),
        SizedBox(width: 12),
        InkWell(
          onTap: onEditPressed,
          child: Image.asset(
            'assets/images/ic_edit.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}
