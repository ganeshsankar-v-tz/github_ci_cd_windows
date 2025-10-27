import 'package:abtxt/view/basics/yarn/yarn_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/NewUnitModel.dart';
import '../../../widgets/MyFilterTextField.dart';

class YarnFilter extends StatelessWidget {
  const YarnFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool yarnNameC = RxBool(false);
    RxBool unitC = RxBool(false);
    RxBool isactiveC = RxBool(false);

    Rxn<NewUnitModel> unitName = Rxn<NewUnitModel>();

    TextEditingController yarnNameController = TextEditingController();
    TextEditingController isactivecontroller =
        TextEditingController(text: 'Yes');

    var unitId;

    final _formKey = GlobalKey<FormState>();
    return GetX<YarnController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 400,
            height: 290,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: yarnNameC.value,
                          onChanged: (value) => yarnNameC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: yarnNameController,
                          hintText: 'Yarn Name',
                          validate: yarnNameC.value ? 'string' : '',
                          autofocus: true,
                          onChanged: (value) {
                            yarnNameC.value =
                                yarnNameController.text.isNotEmpty;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: unitC.value,
                        onChanged: (value) => unitC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Unit',
                        items: controller.unitDropdown,
                        isValidate: unitC.value,
                        selectedItem: unitName.value,
                        onChanged: (NewUnitModel item) {
                          unitName.value = item;
                          unitId = item.id;
                          unitC.value = true;
                        },
                      ),
                    ),
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
                        items: ['Yes', 'No'],
                        onChanged: (items) {
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

              if (yarnNameC.value == true) {
                request['name'] = yarnNameController.text;
              }
              if (unitC.value == true) {
                request['unit_id'] = unitId;
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
