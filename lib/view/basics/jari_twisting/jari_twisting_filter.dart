import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/basics/jari_twisting/jari_twisting_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/MyFilterTextField.dart';


class JariTwistingFilter extends StatelessWidget {
  const JariTwistingFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool yarnC = RxBool(false);
    RxBool wagesC = RxBool(false);

    Rxn<YarnModel> yarnName = Rxn<YarnModel>();


    TextEditingController wagescontroller = TextEditingController();
    var yarnId;
    final _formKey = GlobalKey<FormState>();
    return GetX<JariTwistingController>(builder: (controller) {
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
                        value: yarnC.value,
                        onChanged: (value) => yarnC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Yarn',
                        items: controller.yarnDropdown,
                        isValidate: yarnC.value,
                        selectedItem: yarnName.value,
                        onChanged: (YarnModel item) {
                          yarnName.value = item;
                          yarnId = item.id;
                          yarnC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: wagesC.value,
                        onChanged: (value) => wagesC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: wagescontroller,
                        hintText: 'Wages',
                        validate: wagesC.value ? 'number': '',
                        onChanged: (value){
                          wagesC.value = wagescontroller.text.isNotEmpty;
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
              if (yarnC.value == true) {
                request['yarn_id'] = yarnId;
              }
              if (wagesC.value == true) {
                request['wages'] = wagescontroller.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
