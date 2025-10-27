import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDeleteIconButton extends StatelessWidget {
  final Function? onPressed;
  final bool isDialogOpen;

  const MyDeleteIconButton({
    super.key,
    required this.onPressed,
    this.isDialogOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocusTraversal(
      child: Tooltip(
        message: 'Delete',
        child: TextButton.icon(
          onPressed: () {
            if(!isDialogOpen && onPressed != null) {
              onPressed!();
            }else{
              _showDialog(context);
            }
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          label: const Text(
            'DELETE',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          RxBool textVisible = RxBool(true);
          TextEditingController passwordText = TextEditingController();

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            //title: Text('Do you want to delete?'),
            title: RichText(
              textAlign: TextAlign.start,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'ALERT!\n',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Do you want to delete?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            content: Form(
              key: formKey,
              child: Container(
                width: 270,
                height: 70,
                margin: const EdgeInsets.only(left: 8, right: 8),
                //height: 60,
                child: Obx(
                  () => TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    obscureText: textVisible.value,
                    controller: passwordText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        icon: Icon(
                          textVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => textVisible.value = !textVisible.value,
                      ),
                      labelText: 'Password',
                      hintText: 'Enter the Password',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF939393), width: 0.4),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      if (formKey.currentState!.validate()) {
                        if (onPressed != null) {
                          Get.back();
                          onPressed!(passwordText.text);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (onPressed != null) {
                      Get.back();
                      onPressed!(passwordText.text);
                    }
                  }
                },
                child: const Text('YES'),
              ),
            ],
          );
        });
  }
}
