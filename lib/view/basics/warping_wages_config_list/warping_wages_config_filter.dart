import 'package:abtxt/view/basics/warping_wages_config_list/warping_wages_config_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/YarnModel.dart';

class WarpingWagesFilter extends StatelessWidget {
  const WarpingWagesFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool yarnC = RxBool(false);
    int? yarnId;
    Rxn<YarnModel> yarnName = Rxn<YarnModel>();
    final formKey = GlobalKey<FormState>();
    return GetX<WarpingWagesConfigController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 500,
            height: 100,
            child: SingleChildScrollView(
              child: Row(
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: yarnC.value,
                        onChanged: (value) => yarnC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Yarn',
                        items: controller.yarnName,
                        selectedItem: yarnName.value,
                        isValidate: yarnC.value,
                        onChanged: (YarnModel item) {
                          yarnId = item.id;
                          yarnName.value = item;
                          yarnC.value = true;
                        },
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text('APPLY'),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      var request = {};
                      if (yarnC.value == true) {
                        request['yarn_id'] = yarnId;
                      }

                      Get.back(result: controller.filterData = request);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
