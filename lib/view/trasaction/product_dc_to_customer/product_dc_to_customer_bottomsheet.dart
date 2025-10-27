import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/productinfo/add_product_info.dart';
import 'package:abtxt/view/trasaction/product_dc_to_customer/product_dc_to_customer_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class ProductDCtoCustomerBottomSheet extends StatefulWidget {
  const ProductDCtoCustomerBottomSheet({super.key});

  @override
  State<ProductDCtoCustomerBottomSheet> createState() => _State();
}

class _State extends State<ProductDCtoCustomerBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workController = TextEditingController(text: "No");
  TextEditingController piecesController = TextEditingController(text: "0");
  TextEditingController quantityController = TextEditingController(text: "0");
  TextEditingController rateController = TextEditingController(text: "0.00");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController();
  ProductDcToCustomerController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _productNameFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _productNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDcToCustomerController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Product D.C To Customer')),
        loadingStatus: controller.status.isLoading,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFFF9F3FF), width: 16),
                    color: Colors.white),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Wrap(
                            children: [
                              Focus(
                                focusNode: _productNameFocusNode,
                                skipTraversal: true,
                                child: MyAutoComplete(
                                  label: 'Product Name',
                                  items: controller.ProductName,
                                  selectedItem: productName.value,
                                  onChanged: (ProductInfoModel item) {
                                    productName.value = item;
                                    designNoController.text =
                                        tryCast(item.designNo);
                                    //  _firmNameFocusNode.requestFocus();
                                  },
                                ),
                              ),
                              MyTextField(
                                controller: designNoController,
                                hintText: 'Design No',
                                readonly: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyDropdownButtonFormField(
                            controller: workController,
                            hintText: "Work No",
                            items: const ["No"],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
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
                                onChanged: (value) {
                                  calculation();
                                },
                                suffix: const Text(
                                  "Saree",
                                  style: TextStyle(color: Color(0xFF5700BC)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: rateController,
                                    hintText: 'Rate (Rs)',
                                    validate: 'double',
                                    onChanged: (value) {
                                      calculation();
                                    },
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                      rateController,
                                      fractionDigits: 2,
                                    );
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: amountController,
                                    hintText: 'Amount (Rs)',
                                    validate: 'double',
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                      amountController,
                                      fractionDigits: 2,
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyTextField(
                            controller: detailsController,
                            hintText: 'Details',
                            // validate: 'String',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
                          MyAddButton(onPressed: () => submit()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  calculation() {
    double quantity = double.tryParse(quantityController.text) ?? 0.0;
    double rate = double.tryParse(rateController.text) ?? 0.0;
    var netAmount = quantity * rate;
    amountController.text = netAmount.toStringAsFixed(2);
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "product_id": productName.value?.id,
        "product_name": productName.value?.productName,
        "design_no": designNoController.text,
        "work_no": workController.text == 'No' ? 0 : 1,
        "deli_pieces": int.tryParse(piecesController.text) ?? 0,
        "deli_qty": int.tryParse(quantityController.text) ?? 0,
        "rate": int.tryParse(rateController.text) ?? 0,
        "amount": double.tryParse(amountController.text) ?? 0.0,
        "details": detailsController.text,
      };
      Get.back(result: request);
    }
  }

  shortCutKeys() {
    if (_productNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Product',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_productNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddProductInfo.routeName);

      if (result == "success") {
        controller.productInfo();
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      ProductDcToCustomerController controller = Get.find();

      var item = Get.arguments['item'];
      designNoController.text = item['design_no'] ?? '';
      workController.text = item['work_no'] == 0 ? 'No' : 'Yes';
      piecesController.text = '${item['deli_pieces']}';
      quantityController.text = '${item['deli_qty']}';
      rateController.text = '${item['rate']}';
      amountController.text = tryCast(item['amount']);
      detailsController.text = item['details'] ?? '';

      var productNameList = controller.ProductName.where(
          (element) => '${element.id}' == '${item['product_id']}').toList();
      if (productNameList.isNotEmpty) {
        productName.value = productNameList.first;
        productNameController.text = '${productNameList.first.productName}';
      }
    }
  }
}
