import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
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

class WindingYarnOpeningBalanceDeliveredBottomSheet extends StatefulWidget {
  const WindingYarnOpeningBalanceDeliveredBottomSheet({Key? key})
      : super(key: key);

  @override
  State<WindingYarnOpeningBalanceDeliveredBottomSheet> createState() =>
      _State();
}

class _State extends State<WindingYarnOpeningBalanceDeliveredBottomSheet> {
  TextEditingController packController = TextEditingController();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  Rxn<NewColorModel> colorName = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initValue();
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
          appBar: AppBar(title: const Text( 'Add item to Winding Yarn Opening Balance')),
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
                                        'Delivered Yarn',
                                        style:
                                            TextStyle(fontSize: 16, color: Color(0xff5700BC)),
                                      ),
                                      Wrap(
                                        children: [
                                          MyDialogList(
                                            labelText: 'Yarn Name',
                                            controller: yarnNameController,
                                            list: controller.yarn_dropdown,
                                            showCreateNew: true,
                                            onItemSelected: (YarnModel item) {
                                              yarnNameController.text =
                                              '${item.name}';
                                              yarnName.value = item;
                                              // controller.request['group_name'] = item.id;
                                            },
                                            onCreateNew: (value) async {
                                              //supplier.value = null;
                                              var item =
                                              await Get.toNamed(AddYarn.routeName);
                                              controller.onInit();
                                            },
                                          ),
                                          Row(
                                            children: [
                                              MyDialogList(
                                                labelText: 'Color Name',
                                                controller: colorNameController,
                                                list: controller.color_dropdown,
                                                showCreateNew: true,
                                                onItemSelected: (NewColorModel item) {
                                                  colorNameController.text =
                                                  '${item.name}';
                                                  colorName.value = item;
                                                  // controller.request['group_name'] = item.id;
                                                },
                                                onCreateNew: (value) async {
                                                  //supplier.value = null;
                                                  var item =
                                                  await Get.toNamed(AddNewColor.routeName);
                                                  controller.onInit();
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              MyTextField(
                                                controller: packController,
                                                hintText: 'Pack',
                                                validate: 'number',
                                              ),
                                            ],
                                          ),
                                          MyTextField(
                                            controller: quantityController,
                                            hintText: 'Quantity',
                                            validate: 'number',
                                            suffix: const Text('Pondhu',
                                                style: TextStyle(color: Color(0xFF5700BC))),
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
        //Delivered Yarn
        "de_yarn_id": yarnName.value?.id,
        "de_yarn_name": yarnName.value?.name,
        "de_colour_id": colorName.value?.id,
        "de_color_name": colorName.value?.name,
        "de_pack": int.tryParse(packController.text)??0,
        "de_qty": int.tryParse(quantityController.text)??0,
      };
      Get.back(result: request);
    }
  }
  void _initValue(){
    WindingYarnOpeningBalanceController controller = Get.find();

    if(Get.arguments !=null){
      var item = Get.arguments['item'];

      packController.text = '${item['de_pack']}';
      quantityController.text = '${item['de_qty']}';


      var yarnNameList = controller.yarn_dropdown
          .where((element) => '${element.id}' == '${item['de_yarn_id']}')
          .toList();
      if (yarnNameList.isNotEmpty) {
        yarnName.value = yarnNameList.first;
        yarnNameController.text='${yarnNameList.first.name}';
      }

      var colorNameList = controller.color_dropdown
          .where((element) => '${element.id}' == '${item['de_colour_id']}')
          .toList();
      if (colorNameList.isNotEmpty) {
        colorName.value = colorNameList.first;
        colorNameController.text='${colorNameList.first.name}';
      }
    }

  }

}
