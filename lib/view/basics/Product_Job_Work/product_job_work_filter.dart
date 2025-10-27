import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ProductJobWork_controller.dart';

class ProductJobworkFilter extends StatelessWidget {
  const ProductJobworkFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool workTypeC = RxBool(false);
    RxBool activeC = RxBool(false);

    TextEditingController workTypeController =
    TextEditingController(text: "JobWork");
    TextEditingController isactiveController =
    TextEditingController(text: "Yes");

    final _formKey = GlobalKey<FormState>();
    return GetX<ProductJobWorkController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 400,
            height: 180,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: workTypeC.value,
                          onChanged: (value) => workTypeC.value = value!,
                        ),
                        subtitle: MyDropdownButtonFormField(
                          controller: workTypeController,
                          hintText: 'Work Type',
                          items: ["JobWork", "Process"],
                          autofocus: true,
                          onChanged: (items){
                            workTypeController.text = items;
                            workTypeC.value = true;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: activeC.value,
                        onChanged: (value) => activeC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: isactiveController,
                        hintText: 'Is Active',
                        items: ["Yes", "No"],
                        onChanged: (items){
                          isactiveController.text = items;
                          activeC.value = true;
                        },
                      ),
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
              if (workTypeC.value == true) {
                request['work_typ'] = workTypeController.text;
              }
              if (activeC.value == true) {
                request['is_active'] = isactiveController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
