import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/purchase_return/product_purchase_return/product_purchase_return_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../../model/ProductInfoModel.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyDropdownButtonFormField.dart';
import '../../../../widgets/MyElevatedButton.dart';
import '../../../../widgets/MyTextField.dart';

class ProductPurchaseReturnBottomSheet extends StatefulWidget {
  const ProductPurchaseReturnBottomSheet({super.key});

  @override
  State<ProductPurchaseReturnBottomSheet> createState() => _State();
}

class _State extends State<ProductPurchaseReturnBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workController = TextEditingController(text: 'No');

  // TextEditingController workDetailsController = TextEditingController();
  TextEditingController piecesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

//  TextEditingController stockController = TextEditingController();
  final RxString work = RxString('No');

  final _formKey = GlobalKey<FormState>();
  ProductPurchaseReturnController controller = Get.find();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductPurchaseReturnController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
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
          backgroundColor: const Color(0xFFF9F3FF),
          appBar: AppBar(title: const Text('Add Item (Product Purchase)')),
          body: SingleChildScrollView(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Row(
                                    children: [
                                      MyAutoComplete(
                                        label: 'Product Name',
                                        items: controller.productNameDropdown,
                                        selectedItem: productName.value,
                                        onChanged: (ProductInfoModel item) {
                                          productNameController.text =
                                              '${item.productName}';
                                          productName.value = item;
                                          designNoController.text =
                                              tryCast(item.designNo);
                                          //  _firmNameFocusNode.requestFocus();
                                        },
                                      ),
                                      /*MyDialogList(
                                        labelText: 'Product Name',
                                        controller: productNameController,
                                        list: controller.ProductName,
                                        showCreateNew: false,
                                        onItemSelected:
                                            (ProductInfoModel item) {
                                          productNameController.text =
                                              '${item.productName}';
                                          productName.value = item;
                                          designNoController.text =
                                              '${item.designNo}';
                                        },
                                        onCreateNew: (value) async {},
                                      ),*/
                                      MyTextField(
                                        controller: designNoController,
                                        hintText: 'Design No',
                                        readonly: true,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyDropdownButtonFormField(
                                        controller: workController,
                                        hintText: "Work",
                                        items: const ['No', 'Yes'],
                                        onChanged: (value) {
                                          work.value = value;
                                        },
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible: work.value == "Yes",
                                          child: MyTextField(
                                            controller: piecesController,
                                            hintText: 'Pieces',
                                            validate: 'number',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyTextField(
                                        controller: quantityController,
                                        hintText: 'Quantity',
                                        validate: 'number',
                                        onChanged: (value) {
                                          _sumQuantityRate();
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      MyTextField(
                                        controller: rateController,
                                        hintText: 'Rate (Rs) / Saree',
                                        validate: 'double',
                                        // onChanged: (Value) {
                                        //   setState(() {
                                        //     rate = double.tryParse(Value) ??
                                        //         0.0;
                                        //     amountController.text =
                                        //         "${quantity * rate}";
                                        //   });
                                        // },
                                        onChanged: (value) {
                                          _sumQuantityRate();
                                        },
                                      ),
                                      MyTextField(
                                        controller: amountController,
                                        hintText: 'Amount (Rs)',
                                        validate: 'double',
                                      ),
                                    ],
                                  ),
                                  // MyTextField(
                                  //   controller: stockController,
                                  //   hintText: 'Stock',
                                  //   validate: 'number',
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: Get.arguments != null,
                                    child: MyElevatedButton(
                                      color: Colors.red,
                                      onPressed: () =>
                                          Get.back(result: {'item': 'delete'}),
                                      child: const Text('DELETE'),
                                    ),
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
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "product_id": productName.value?.id,
        "product_name": productName.value?.productName,
        "design_no": designNoController.text,
        "work_no": workController.text == 'No' ? 0 : 1,
        "pieces": int.tryParse(piecesController.text) ?? 0,
        "quantity": int.tryParse(quantityController.text) ?? 0,
        "rate": rateController.text,
        "amount": double.tryParse(amountController.text) ?? 0,
        // "stock": stockController.text,
        // "work_details": workDetailsController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      var item = Get.arguments['item'];

      // designNoController.text = '${item['design_no']}';
      designNoController.text = tryCast(item['design_no']);
      workController.text = item['work_no'] == 0 ? 'No' : 'Yes';
      piecesController.text = '${item['pieces']}';
      quantityController.text = '${item['quantity']}';
      rateController.text = '${item['rate']}';
      amountController.text = '${item['amount']}';
      //  stockController.text = '${item['stock']}';

      var productList = controller.productNameDropdown
          .where((element) => '${element.id}' == '${item['product_id']}')
          .toList();
      if (productList.isNotEmpty) {
        productName.value = productList.first;
        productNameController.text = '${productList.first.productName}';
      }
    }
  }

  void _sumQuantityRate() {
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    double amount = 0;

    amount = quantity * rate;
    amountController.text = '$amount';
  }
}
