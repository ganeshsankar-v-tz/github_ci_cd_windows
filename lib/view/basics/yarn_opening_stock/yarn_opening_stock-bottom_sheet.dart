import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/basics/job_work_product_opening_balance/job_work_product_opening_balance_controller.dart';
import 'package:abtxt/view/basics/yarn_opening_stock/yarn_opening_stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class YarnOpeningStockBottomSheet extends StatefulWidget {
  const YarnOpeningStockBottomSheet({Key? key}) : super(key: key);

  @override
  State<YarnOpeningStockBottomSheet> createState() => _State();
}

class _State extends State<YarnOpeningStockBottomSheet> {
  TextEditingController stockinController = TextEditingController();
  TextEditingController bagboxController = TextEditingController();
  TextEditingController quantityController = TextEditingController();



  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnOpeningStockController>(
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
              appBar: AppBar(title: const Text('Add item to Yarn Opening Stock')),
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
                                  mainAxisAlignment: MainAxisAlignment.start,                                  children: [
                                    Container(
                                      child: Wrap(
                                        children: [
                                          Row(
                                            children: [
                                              MyDropdownButtonFormField(
                                                controller: stockinController,
                                                hintText: "Stock In",
                                                items: Constants.Stock,
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              MyTextField(
                                                controller: bagboxController,
                                                hintText: 'Bag / Box No',
                                                validate: 'string',
                                              ),
                                            ],
                                          ),
                                          MyTextField(
                                            controller: quantityController,
                                            hintText: 'Quantity',
                                            validate: 'double',
                                            suffix: const Text('Kg',style: TextStyle(color: Color(0xFF5700BC))),
                                          ),
                                        ],
                                      )
                                    ),
                                    SizedBox(
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
        "stock_in": stockinController.text,
        "box_number": bagboxController.text,
        "quantity": int.tryParse(quantityController.text) ?? 0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    YarnOpeningStockController controller = Get.find();
    stockinController.text=Constants.Stock[0];


    if (Get.arguments != null){
      var item = Get.arguments['item'];

      stockinController.text = '${item['stock_in']}';
      bagboxController.text = '${item['box_number']}';
      quantityController
          .text = '${item['quantity']}';
    }
  }
}
