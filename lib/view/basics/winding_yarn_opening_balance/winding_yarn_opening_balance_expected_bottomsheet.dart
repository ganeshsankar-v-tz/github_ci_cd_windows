import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/basics/winding_yarn_opening_balance/winding_yarn_opening_balance_controller.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class WindingYarnOpeningBalanceExpectedBottomSheet extends StatefulWidget {
  const WindingYarnOpeningBalanceExpectedBottomSheet({Key? key})
      : super(key: key);

  @override
  State<WindingYarnOpeningBalanceExpectedBottomSheet> createState() => _State();
}

class _State extends State<WindingYarnOpeningBalanceExpectedBottomSheet> {
  Rxn<YarnModel> exyarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController expectedQuantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WindingYarnOpeningBalanceController>(
        builder: (controller) {
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add item to Winding Yarn Opening Balance')),
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                Container(
                                  child: Wrap(
                                    children: [
                                      const Text(
                                        'Expected Yarn',
                                        style:
                                            TextStyle(fontSize: 16, color: Color(0xff5700BC)),
                                      ),
                                      const SizedBox(height: 40),
                                      Wrap(
                                        children: [
                                          Row(
                                            children: [
                                              MyDialogList(
                                                labelText: 'Yarn Name',
                                                controller: yarnNameController,
                                                list: controller.yarn_dropdown,
                                                showCreateNew: true,
                                                onItemSelected: (YarnModel item) {
                                                  yarnNameController.text =
                                                  '${item.name}';
                                                  exyarnName.value = item;
                                                  // controller.request['group_name'] = item.id;
                                                },
                                                onCreateNew: (value) async {
                                                  //supplier.value = null;
                                                  var item =
                                                  await Get.toNamed(AddYarn.routeName);
                                                  controller.onInit();
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              MyTextField(
                                                controller: expectedQuantityController,
                                                hintText: 'Quantity',
                                                validate: 'number',
                                                suffix: const Text('Kg', style: TextStyle(color: Color(0xFF5700BC))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MyCloseButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Close'),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 200,
                                      child: MyElevatedButton(
                                        onPressed: () => submit(),
                                        child: const Text('ADD'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        //Expected Yarn
        "ex_yarn_id": exyarnName.value?.id,
        "ex_yarn_name": exyarnName.value?.name,
        "ex_qty":int.tryParse( expectedQuantityController.text)??0,
      };
      Get.back(result: request);
    }
  }

  void _initValue(){
    WindingYarnOpeningBalanceController controller = Get.find();

    if(Get.arguments != null){
      var item = Get.arguments['item'];

expectedQuantityController.text = '${item['ex_qty']}';

      var yarnNameList = controller.yarn_dropdown
          .where((element) => '${element.id}' == '${item['ex_yarn_id']}')
          .toList();
      if (yarnNameList.isNotEmpty) {
        exyarnName.value = yarnNameList.first;
        yarnNameController.text='${yarnNameList.first.name}';
      }

    }

  }

}
