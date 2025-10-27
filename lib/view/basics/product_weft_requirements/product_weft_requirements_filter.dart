import 'package:abtxt/view/basics/product_weft_requirements/product_weft_requirements_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/ProductGroupModel.dart';
import '../../../widgets/MyFilterTextField.dart';

class ProductWeftRequirementsFilter extends StatelessWidget {
  const ProductWeftRequirementsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool productC = RxBool(false);
    RxBool designNoC = RxBool(false);
    RxBool groupNameC = RxBool(false);
    RxBool isActiveC = RxBool(false);

    Rxn<ProductGroupModel> groupName = Rxn<ProductGroupModel>();

    TextEditingController productNameController = TextEditingController();
    TextEditingController designNoController = TextEditingController();
    TextEditingController isactivecontroller =
        TextEditingController(text: "Yes");


    var groupId;
    final _formKey = GlobalKey<FormState>();
    return GetX<ProductWeftRecuirementsController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 450,
            height: 180,
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
                  // SizedBox(
                  //   width: 325,
                  //   child: ListTile(
                  //     leading: Checkbox(
                  //       value: groupNameC.value,
                  //       onChanged: (value) => groupNameC.value = value!,
                  //     ),
                  //     subtitle: MyAutoComplete(
                  //       label: 'Group Name',
                  //       items: controller.groups,
                  //       isValidate: groupNameC.value,
                  //       selectedItem: groupName.value,
                  //       onChanged: (ProductGroupModel item) {
                  //         groupName.value = item;
                  //         groupId = item.groupName;
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 325,
                  //   child: ListTile(
                  //       leading: Checkbox(
                  //         value: isActiveC.value,
                  //         onChanged: (value) => isActiveC.value = value!,
                  //       ),
                  //       subtitle: MyDropdownButtonFormField(
                  //         controller: isactivecontroller,
                  //         hintText: 'Is Active',
                  //         items: ["Yes", "No"],
                  //       )),
                  // ),
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
             /* if (groupNameC.value == true) {
                request['group_name'] = groupId;
              }
              if (isActiveC.value == true) {
                request['is_active'] = isactivecontroller.text;
              }*/

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
