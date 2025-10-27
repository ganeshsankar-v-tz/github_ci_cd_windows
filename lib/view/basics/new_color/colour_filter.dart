import 'package:abtxt/view/basics/new_color/new_color_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/MyFilterTextField.dart';

class NewColorFilter extends StatelessWidget {
  const NewColorFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool colorC = RxBool(false);
    RxBool isactiveC = RxBool(false);

    TextEditingController colorNamecontroller = TextEditingController();
    TextEditingController isactivecontroller = TextEditingController(text: 'Yes');
    final _formKey = GlobalKey<FormState>();
    return GetX<NewColorController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 400,
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: colorC.value,
                          onChanged: (value) => colorC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          autofocus: true,
                          controller: colorNamecontroller,
                          hintText: 'Color Name',
                          validate: colorC.value ? 'string' : '',
                          onChanged: (value){
                            colorC.value = colorNamecontroller.text.isNotEmpty;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: isactiveC.value,
                        onChanged: (value) => isactiveC.value = value!,
                      ),
                      subtitle: Container(
                          child: MyDropdownButtonFormField(
                            controller: isactivecontroller,
                            hintText: 'Is Active',
                            items: ['Yes','No'],
                            onChanged: (items){
                              isactivecontroller.text = items;
                              isactiveC.value = true;
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('APPLY'),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (colorC.value == true) {
                request['name'] = colorNamecontroller.text;
              }
              if (isactiveC.value == true) {
                request['is_active'] = isactivecontroller.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
