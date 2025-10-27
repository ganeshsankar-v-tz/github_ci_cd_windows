import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/utils/constant.dart';
import 'package:abtxt/view/trasaction/retail_sale/retail_sale_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class RetailSaleBottomSheet extends StatefulWidget {
  const RetailSaleBottomSheet({Key? key}) : super(key: key);

  @override
  State<RetailSaleBottomSheet> createState() => _State();
}

class _State extends State<RetailSaleBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productController = TextEditingController();
  TextEditingController designNo = TextEditingController();
  TextEditingController work = TextEditingController();
  TextEditingController workDetails = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController rateRs = TextEditingController();
  TextEditingController amountRs = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailSaleController>(builder: (controller) {
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
          appBar: AppBar(title: Text('Add item to Retail Sale')),
          body: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.90,
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 50),
                        child: Wrap(
                          children: [
                            Row(
                              children: [
                                MyDialogList(
                                  labelText: 'Product Name',
                                  controller: productController,
                                  list: controller.productDropdown,
                                  onItemSelected: (ProductInfoModel item) {
                                    productController.text = '${item.productName}';
                                    productName.value = item;
                                  },
                                  onCreateNew: (value) async {},
                                ),
                                MyTextField(
                                  controller: designNo,
                                  hintText: 'Design No',
                                  validate: 'string',
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                MyDropdownButtonFormField(
                                    controller: work,
                                    hintText: "Work",
                                    items: Constants.ISACTIVE),
                                MyTextField(
                                  controller: workDetails,
                                  hintText: 'Work Details',
                                  validate: 'string',
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                MyTextField(
                                  controller: quantity,
                                  hintText: 'Quantity',
                                  validate: 'number',
                                  suffix: const Text('Saree',
                                      style: TextStyle(color: Color(0xFF5700BC))),
                                ),
                                MyTextField(
                                  controller: rateRs,
                                  hintText: 'Rate (Rs)',
                                  validate: 'double',
                                ),
                              ],
                            ),

                            MyTextField(
                              controller: amountRs,
                              hintText: 'Amount (Rs)',
                              validate: 'double',
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
        "design_no": designNo.text,
        "work_details": workDetails.text,
        "work": work.text,
        "qty": int.tryParse(quantity.text) ?? 0,
        "rate": double.tryParse(rateRs.text) ?? 0,
        "amount": double.tryParse(amountRs.text) ?? 0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    RetailSaleController controller = Get.find();
    work.text = Constants.ISACTIVE[0];
    if(Get.arguments != null) {
      var item = Get.arguments['item'];

      designNo.text='${item['design_no']}';
      workDetails.text='${item['work_details']}';
      quantity.text='${item['rate']}';
      rateRs.text='${item['qty']}';
      amountRs.text='${item['amount']}';

      var productNameList= controller.productDropdown
          .where((element) => '${element.id}' == '${item['product_id']}')
          .toList();
      if (productNameList.isNotEmpty) {
        productName.value = productNameList.first;
        productController.text = '${productNameList.first.productName}';
      }

    }
    }
}
