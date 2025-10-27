//

import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/basics/process_product_opening_balance/process_product_opening_balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class ProcessProductOpeningBalanceItemBottomSheet extends StatefulWidget {
  const ProcessProductOpeningBalanceItemBottomSheet({Key? key})
      : super(key: key);

  @override
  State<ProcessProductOpeningBalanceItemBottomSheet> createState() => _State();
}

class _State extends State<ProcessProductOpeningBalanceItemBottomSheet> {
  Rxn<ProductInfoModel> productNameController = Rxn<ProductInfoModel>();
  TextEditingController productController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController workNameController = TextEditingController();
  TextEditingController piecesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcessProductOpeningBalanceController>(
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
          appBar: AppBar(title: const Text('Add item to Process Product Opening Balance')),
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
                                      MyDialogList(
                                        labelText: 'Product Name',
                                        controller: productController,
                                        list: controller.productDropdown,
                                        showCreateNew: false,
                                        onItemSelected: (ProductInfoModel item) {
                                          productController.text =
                                          '${item.groupName}';
                                          productNameController.value = item;
                                          designNoController.text='${item.designNo}';
                                          // controller.request['group_name'] = item.id;
                                        },
                                        onCreateNew: (value) async {
                                        },
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: designNoController,
                                            hintText: 'Design No',
                                            validate: 'string',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyDropdownButtonFormField(
                                              controller:  workController,
                                              hintText: "Work Type",
                                              items: ['Yes','No'],
                                            // onChanged: (value)
                                            // {
                                            //   _isIntegrated.value = value;
                                            // },
                                          ),
                                          MyTextField(
                                            controller: workNameController,
                                            hintText: 'Work Name',
                                            // validate: 'string',
                                          ),

                                          // Obx(() =>       Visibility(
                                          //   visible: _isIntegrated.value == "Yes",
                                          //   child:
                                          // ),)

                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyTextField(
                                            controller: piecesController,
                                            hintText: 'Pieces',
                                            validate: 'number',
                                          ),
                                        ],
                                      ),
                                      MyTextField(
                                        controller: quantityController,
                                        hintText: 'Quantity',
                                        validate: 'number',
                                        suffix:  Text('${productNameController.value?.productUnit}',
                                            style: TextStyle(color: Color(0xFF5700BC))),
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
        "product_id": productNameController.value?.id,
        "product_name": productNameController.value?.productName,
        "design_no": designNoController.text,
        "work_type": workController.text,
        "pcs": piecesController.text,
        "quantity": int.tryParse(quantityController.text)??0,
      };
      Get.back(result: request);
    }
  }
  void _initValue()  {
    ProcessProductOpeningBalanceController controller = Get.find();
    workController.text='Yes';






    if(Get.arguments != null){
      var item = Get.arguments ['item'];
designNoController.text='${item['design_no']}';
workController.text='${item['work_type']}';
piecesController.text='${item['pcs']}';
quantityController.text='${item['quantity']}';

      var productNameList = controller.productDropdown
          .where((element) => '${element.id}' == '${item['product_id']}')
          .toList();
      if (productNameList.isNotEmpty) {
        productNameController.value = productNameList.first;
        productController.text= '${productNameList.first.productName}';
      }
    }

  }
}
