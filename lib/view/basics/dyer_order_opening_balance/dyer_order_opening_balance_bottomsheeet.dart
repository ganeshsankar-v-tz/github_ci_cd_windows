import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/view/basics/dyer_order_opening_balance/dyer_order_opening_balance_controller.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class DyerOrderOpeningBalanceBottomSheet extends StatefulWidget {
  const DyerOrderOpeningBalanceBottomSheet({Key? key}) : super(key: key);
  static const String routeName = '/DropdownNew';


  @override
  State<DyerOrderOpeningBalanceBottomSheet> createState() => _State();
}

class _State extends State<DyerOrderOpeningBalanceBottomSheet> {
  Rxn<NewColorModel> colortName = Rxn<NewColorModel>();
  TextEditingController colorNameController = TextEditingController();
  TextEditingController packController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DyerOrderOpeningBalanceController>(builder: (controller) {
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
          appBar: AppBar(title: const Text('Add item to Dyer Order Opening Balance')),
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
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                Container(
                                    child: Wrap(
                                      children: [

                                        MyDialogList(
                                          labelText: 'Color Name',
                                          controller: colorNameController,
                                          list: controller.color_dropdown,
                                          showCreateNew: true,
                                          onItemSelected: (NewColorModel item) {
                                            colorNameController.text =
                                            '${item.name}';
                                            colortName.value = item;
                                            // controller.request['group_name'] = item.id;
                                          },
                                          onCreateNew: (value) async {
                                            //supplier.value = null;
                                            var item =
                                            await Get.toNamed(AddNewColor.routeName);
                                            controller.onInit();
                                          },
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
                                          controller: qtyController,
                                          hintText: 'Quantity',
                                          validate: 'number',
                                          suffix: const Text('Pondhu', style: TextStyle(color: Color(0xFF5700BC))),
                                        ),

                                      ],
                                    )),
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
        "color_name": colortName.value?.name,
        "colour_id": colortName.value?.id,
        "pack": int.tryParse(packController.text)??0,
        "quantity": int.tryParse(qtyController.text)??0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    DyerOrderOpeningBalanceController controller = Get.find();

    if (Get.arguments != null){
      var item = Get.arguments['item'];

      packController.text = '${item['pack']}';
      qtyController.text = '${item['quantity']}';


      var colorList = controller.color_dropdown
          .where((element) => '${element.id}' == '${item['colour_id']}')
          .toList();
      if (colorList.isNotEmpty) {
        colortName.value = colorList.first;
        colorNameController.text = '${colorList.first.name}';
      }
    }
  }
}
