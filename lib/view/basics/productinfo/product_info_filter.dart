import 'package:abtxt/view/basics/productinfo/product_info_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/ProductGroupModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyFilterTextField.dart';

class ProductInfoFilter extends StatelessWidget {
  const ProductInfoFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool productC = RxBool(false);
    RxBool designNoC = RxBool(false);
    RxBool groupNameC = RxBool(false);
    RxBool isActiveC = RxBool(false);
    RxBool usedForC = RxBool(false);
    RxBool integratedC = RxBool(false);

    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();

    TextEditingController productNameController = TextEditingController();
    TextEditingController designNoController = TextEditingController();
    TextEditingController isactivecontroller =
        TextEditingController(text: "Yes");
    TextEditingController usedForController =
        TextEditingController(text: 'ALL');
    TextEditingController isIntegratedController =
        TextEditingController(text: "No");

    var group;

    final _formKey = GlobalKey<FormState>();
    return GetX<ProductInfoController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 450,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: productC.value,
                          onChanged: (value) => productC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: productNameController,
                          hintText: 'Product Name',
                          validate: productC.value ? 'string' : '',
                          autofocus: true,
                          onChanged: (value) {
                            productC.value =
                                productNameController.text.isNotEmpty;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: designNoC.value,
                          onChanged: (value) => designNoC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: designNoController,
                          hintText: 'Design No',
                          validate: designNoC.value ? 'string' : '',
                          onChanged: (value) {
                            designNoC.value =
                                designNoController.text.isNotEmpty;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: groupNameC.value,
                        onChanged: (value) => groupNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Group Name',
                        items: controller.groups,
                        isValidate: groupNameC.value,
                        selectedItem: groupName.value,
                        onChanged: (ProductGroupModel item) {
                          groupName.value = item;
                          group = item.groupName;
                          groupNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: isActiveC.value,
                          onChanged: (value) => isActiveC.value = value!,
                        ),
                        subtitle: MyDropdownButtonFormField(
                          controller: isactivecontroller,
                          hintText: 'Is Active',
                          items: ["Yes", "No"],
                          onChanged: (items) {
                            isactivecontroller.text = items;
                            isActiveC.value = true;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: usedForC.value,
                        onChanged: (value) => usedForC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: usedForController,
                        hintText: 'Used For',
                        items: const [
                          "ALL",
                          "Weaving",
                          "Sales",
                          "Job work",
                        ],
                        onChanged: (items) {
                          usedForController.text = items;
                          usedForC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: integratedC.value,
                        onChanged: (value) => integratedC.value = value!,
                      ),
                      subtitle: Container(
                          child: MyDropdownButtonFormField(
                        controller: isIntegratedController,
                        hintText: 'Is Integrated?',
                        items: ["No", "Yes"],
                        onChanged: (items) {
                          isIntegratedController.text = items;
                          integratedC.value = true;
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
              if (productC.value == true) {
                request['product_name'] = productNameController.text;
              }
              if (designNoC.value == true) {
                request['design_no'] = designNoController.text;
              }
              if (groupNameC.value == true) {
                request['group_name'] = group;
              }
              if (isActiveC.value == true) {
                request['is_active'] = isactivecontroller.text;
              }
              if (usedForC.value == true) {
                request['used_for'] = usedForController.text;
              }
              if (integratedC.value == true) {
                request['integrated'] = isIntegratedController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
