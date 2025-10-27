import 'package:abtxt/view/trasaction/Yarn_Delivery_to_Dyer/yarn_delivery_to_dyer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../model/NewColorModel.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class YarnDeliveryToDyerBottomSheet extends StatefulWidget {
  const YarnDeliveryToDyerBottomSheet({Key? key}) : super(key: key);

  @override
  State<YarnDeliveryToDyerBottomSheet> createState() => _State();
}

class _State extends State<YarnDeliveryToDyerBottomSheet> {
  Rxn<NewColorModel> color_Name = Rxn<NewColorModel>();
  TextEditingController colornameController = TextEditingController();
  TextEditingController packController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late YarnDeliveryToDyerController controller;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnDeliveryToDyerController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyS,
            'Save',
                () async => submit(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: const Text('Add Item Yarn Delivery to Dyer')),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFF9F3FF),width: 16)),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      //color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    MyAutoComplete(
                                      label: 'Color Name',
                                      items: controller.colors_dropdown,
                                      selectedItem: color_Name.value,
                                      onChanged: (NewColorModel item) {
                                        color_Name.value = item;
                                        //  _firmNameFocusNode.requestFocus();
                                      },
                                    ),
                                  ],
                                ),
                                MyTextField(
                                  controller: packController,
                                  hintText: 'Pack',
                                  validate: 'number',
                                ),
                                MyTextField(
                                  controller: qtyController,
                                  hintText: 'Quantity',
                                  validate: 'double',
                                  suffix: const Text('Pondhu',
                                      style: TextStyle(color: Color(0xFF5700BC))),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: Get.arguments != null,
                                      child: MyElevatedButton(
                                        color: Colors.red,
                                        onPressed: () => Get.back(
                                            result: {'item': 'delete'}),
                                        child: const Text('DELETE'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      child: MyAddButton(
                                        onPressed: () => submit(),
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
        "color_name": color_Name.value?.name,
        "color_id": color_Name.value?.id,
        "pack": int.tryParse(packController.text),
        "qty": int.tryParse(qtyController.text),
      };
      Get.back(result: request);
      // print("${request["color_name"].runtimeType}");
      // print("${request["pack"].runtimeType}");
      // print("${request["qty"].runtimeType}");
    }

  }
  void _initValue(){
    YarnDeliveryToDyerController controller = Get.find();
    if (Get.arguments != null){
      var item = Get.arguments['item'];
      packController.text = '${item['pack']}';
      qtyController.text = '${item['qty']}';
      colornameController.text = '${item['color_name']}';

    }
  }

}
