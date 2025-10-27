import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/adjustments/product_integration/product_integration_controller.dart';
import 'package:abtxt/view/adjustments/product_stock_adjustment/product_stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class ProductIntegrationBottomSheet extends StatefulWidget {
  const ProductIntegrationBottomSheet({Key? key}) : super(key: key);

  @override
  State<ProductIntegrationBottomSheet> createState() => _State();
}

class _State extends State<ProductIntegrationBottomSheet> {
  Rxn<ProductInfoModel> productNameController = Rxn<ProductInfoModel>();
  TextEditingController productController = TextEditingController();
  TextEditingController designController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController wastageController = TextEditingController();
  TextEditingController totalConsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductIntegrationController controller;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductIntegrationController>(builder: (controller) {
      // this.controller=controller;
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
          appBar: AppBar(title: const Text('Add Item (Product Integration - Adjustment)')),
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Wrap(
                                children: [
                                  Row(
                                    children: [
                                      MyDialogList(
                                        labelText: 'Product Name',
                                        controller: productController,
                                        list: controller.products,
                                        showCreateNew: false,
                                        onItemSelected: (ProductInfoModel item) {
                                          productController.text = '${item.productName}';
                                          productNameController.value = item;
                                        },
                                        onCreateNew: (value) async {
                                        },
                                      ),
                                      MyTextField(
                                        controller: designController,
                                        hintText: 'Design No',
                                        validate: 'String',
                                      ),
                                    ],
                                  ),


                                Row(
                                  children: [
                                    MyTextField(
                                      controller: workController,
                                      hintText: 'Work',
                                      validate: 'String',
                                    ),
                                    MyTextField(
                                      controller: quantityController,
                                      hintText: 'Quantity ',
                                      validate: 'number',
                                      suffix: const Text('Pieces',
                                          style: TextStyle(color: Color(0xFF5700BC))),
                                    ),
                                  ],
                                ),

                                MyTextField(
                                  controller: wastageController,
                                  hintText: 'Wastage',
                                  validate: 'number',
                                ),
                                MyTextField(
                                  controller: totalConsController,
                                  hintText: 'Total Consumption',
                                  validate: 'number',
                                  suffix: const Text('Pieces', style: TextStyle(color: Color(0xFF5700BC))),
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
        "product_id":productNameController.value?.id,
        "product_name":productNameController.value?.productName,
        "design_no":designController.text,
        "work_name":workController.text,
        "wastage":wastageController.text,
        "quantity":quantityController.text,
        "totel_consumption":totalConsController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    ProductIntegrationController controller = Get.find();

    workController.text = Constants.ISACTIVE[0];

  }
}
