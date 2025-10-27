import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyFilterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/WarpGroupModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import 'new_warp_controller.dart';

class WarpInfoFilter extends StatelessWidget {
  const WarpInfoFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool warpTypeC = RxBool(false);
    RxBool totalEndsC = RxBool(false);
    RxBool lengthC = RxBool(false);
    RxBool warpName = RxBool(false);
    RxBool groupC = RxBool(false);

    TextEditingController warpTypeController =
        TextEditingController(text: "Main Warp");
    TextEditingController totalEndsController = TextEditingController();
    TextEditingController warpNameController = TextEditingController();
    TextEditingController lengthController =
        TextEditingController(text: "Metre");
    Rxn<WarpGroupModel> groupName = Rxn<WarpGroupModel>();
    int? groupId;

    final formKey = GlobalKey<FormState>();
    return GetX<NewWarpController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 400,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: totalEndsC.value,
                          onChanged: (value) => totalEndsC.value = value!,
                        ),
                        subtitle: MyFilterTextField(
                          controller: totalEndsController,
                          hintText: 'Total Ends',
                          validate: totalEndsC.value ? 'number' : '',
                          autofocus: true,
                          onChanged: (value){
                            totalEndsC.value = totalEndsController.text.isNotEmpty;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                        leading: Checkbox(
                          value: warpTypeC.value,
                          onChanged: (value) => warpTypeC.value = value!,
                        ),
                        subtitle: MyDropdownButtonFormField(
                          controller: warpTypeController,
                          hintText: 'Warp Type',
                          items: const ["Main Warp", "Other"],
                          onChanged: (items){
                            warpTypeController.text = items;
                            warpTypeC.value = true;
                          },
                        )),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: lengthC.value,
                        onChanged: (value) => lengthC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: lengthController,
                        hintText: 'Length Type',
                        items: const ["Metre", "Yards"],
                        onChanged: (items){
                          lengthController.text = items;
                          lengthC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: groupC.value,
                        onChanged: (value) => groupC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Group',
                        items: controller.groups,
                        selectedItem: groupName.value,
                        isValidate: groupC.value,
                        onChanged: (WarpGroupModel item) {
                          groupId = item.id;
                          groupName.value = item;
                          groupC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: warpName.value,
                        onChanged: (value) => warpName.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: warpNameController,
                        hintText: "Warp Name",
                        validate: warpName.value ? 'string' : '',
                        onChanged: (value){
                          warpName.value = warpNameController.text.isNotEmpty;
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
            child: const Text('APPLY'),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (warpTypeC.value == true) {
                request['warp_type'] = warpTypeController.text;
              }
              if (totalEndsC.value == true) {
                request['total_ends'] = totalEndsController.text;
              }
              if (lengthC.value == true) {
                request['length_type'] = lengthController.text;
              }
              if (warpName.value == true) {
                request['warp_name'] =
                    warpNameController.text.replaceAll("+", "%2b");
              }
              if (groupC.value == true) {
                request['group_id'] = groupId;
              }

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
