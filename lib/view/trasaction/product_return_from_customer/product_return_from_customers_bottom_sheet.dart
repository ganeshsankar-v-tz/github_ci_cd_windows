import 'package:abtxt/view/trasaction/product_return_from_customer/product_return_from_customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MyTextField.dart';

class ProductReturnFromCustomerBottomSheet extends StatefulWidget {
  const ProductReturnFromCustomerBottomSheet({Key? key}) : super(key: key);

  @override
  State<ProductReturnFromCustomerBottomSheet> createState() => _State();
}

class _State extends State<ProductReturnFromCustomerBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController workDetailsController = TextEditingController();
  TextEditingController piecesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController deliveredController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  final RxString _isIntegrated = RxString(Constants.ISACTIVE[0]);


  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductReturnFromCustomerController>(
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
              appBar: AppBar(title: const Text(
                  'Add item to Product Return From Customer')),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Wrap(
                                        children: [
                                          Row(
                                            children: [
                                              MyDialogList(
                                                labelText: 'Product Name',
                                                controller: productNameController,
                                                list: controller.products,
                                                showCreateNew: false,
                                                onItemSelected: (
                                                    ProductInfoModel item) {
                                                  productNameController.text =
                                                  '${item.productName}';
                                                  productName.value = item;
                                                  designNoController.text='${item.designNo}';
                                                },
                                                onCreateNew: (value) async {

                                                },
                                              ),
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
                                                controller: workController,
                                                hintText: "Work",
                                                items: Constants.ISACTIVE,
                                                onChanged: (value){
                                                  _isIntegrated.value=value;
                                                },
                                              ),
                                              Obx(()=>
                                                 Visibility(
                                                   visible: _isIntegrated.value=="Yes",
                                                  child: MyTextField(
                                                    controller: workDetailsController,
                                                    hintText: 'Work Details',
                                                    validate: 'String',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              MyTextField(
                                                controller: piecesController,
                                                hintText: 'Pieces',
                                                validate: 'number',
                                              ),
                                              MyTextField(
                                                controller: quantityController,
                                                hintText: 'Quantity',
                                                validate: 'number',
                                                suffix: const Text('Saree',
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xFF5700BC))),
                                              ),
                                            ],
                                          ),

                                          MyTextField(
                                            controller: rateController,
                                            hintText: 'Rate (Rs)',
                                            validate: 'double',
                                          ),
                                          MyTextField(
                                            controller: deliveredController,
                                            hintText: 'Delivered',
                                            validate: 'number',
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
        "product_id": productName.value?.id,
        "product_name": productName.value?.productName,
        "desgin_no": designNoController.text,
        "work": workController.text,
        "pieces": int.tryParse(piecesController.text) ?? 0,
        "quantity": int.tryParse(quantityController.text) ?? 0,
        "rate": rateController.text,
        "delivered": deliveredController.text,
        "work_details": workDetailsController.text,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    ProductReturnFromCustomerController controller = Get.find();
    workController.text = Constants.ISACTIVE[0];

    if (Get.arguments != null) {
      var item = Get.arguments['item'];


      designNoController.text = '${item['desgin_no']}';
      workController.text = '${item['work']}';
      workDetailsController.text = '${item['work_details']}';
      piecesController.text = '${item['pieces']}';
      quantityController.text = '${item['quantity']}';
      rateController.text = '${item['rate']}';
      deliveredController.text = '${item['delivered']}';

      var productNameList = controller.products
          .where((element) => '${element.id}' == '${item['product_id']}')
          .toList();
      if (productNameList.isNotEmpty) {
        productName.value = productNameList.first;
        productNameController.text = '${productNameList.first.productName}';
      }
    }
  }
}
