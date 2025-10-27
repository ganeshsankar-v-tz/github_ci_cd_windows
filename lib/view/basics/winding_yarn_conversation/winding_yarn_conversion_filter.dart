
import 'package:abtxt/view/basics/winding_yarn_conversation/winding_yarn_coversation_controller.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/YarnModel.dart';
import '../../../widgets/MyFilterTextField.dart';


class WindingYarnConversionFilter extends StatelessWidget {
  const WindingYarnConversionFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool fromYarnNameC = RxBool(false);
    RxBool toYarnNameC = RxBool(false);
    RxBool fromyarnQtyC = RxBool(false);
    RxBool toyarnQtyC = RxBool(false);

    Rxn<YarnModel> fromyarnName = Rxn<YarnModel>();
    Rxn<YarnModel> toyarnName = Rxn<YarnModel>();

    TextEditingController fromyarnQtycontroller = TextEditingController();
    TextEditingController toyarnQtycontroller = TextEditingController();
    var fromYarnId;
    var toYarnId;
    final _formKey = GlobalKey<FormState>();
    return GetX<WindingYarnConversationController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: Container(
            width: 500,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: fromYarnNameC.value,
                        onChanged: (value) => fromYarnNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'From Yarn',
                        items: controller.fromYarns,
                        isValidate: fromYarnNameC.value,
                        selectedItem: fromyarnName.value,
                        onChanged: (YarnModel item) {
                          fromyarnName.value =item;
                          fromYarnId = item.id;
                          fromYarnNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: fromyarnQtyC.value,
                        onChanged: (value) => fromyarnQtyC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: fromyarnQtycontroller,
                        hintText: 'From Yarn Qty',
                        validate: fromyarnQtyC.value ? 'number': '',
                        onChanged: (value){
                          fromyarnQtyC.value = fromyarnQtycontroller.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: toYarnNameC.value,
                        onChanged: (value) => toYarnNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'To Yarn',
                        items: controller.fromYarns,
                        isValidate: toYarnNameC.value,
                        selectedItem: toyarnName.value,
                        onChanged: (YarnModel item) {
                          toyarnName.value =item;
                          toYarnId = item.id;
                          toYarnNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: toyarnQtyC.value,
                        onChanged: (value) => toyarnQtyC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: toyarnQtycontroller,
                        hintText: 'To Yarn Qty',
                        validate: toyarnQtyC.value ? 'number': '',
                        onChanged: (value){
                          toyarnQtyC.value = toyarnQtycontroller.text.isNotEmpty;
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
              if (fromYarnNameC.value == true) {
                request['from_yarn_id'] = fromYarnId;
              }
              if (fromyarnQtyC.value == true) {
                request['from_qty'] = fromyarnQtycontroller.text;
              }
              if (toYarnNameC.value == true) {
                request['to_yarn_id'] = toYarnId;
              }
              if (toyarnQtyC.value == true) {
                request['to_qty'] = toyarnQtycontroller.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
