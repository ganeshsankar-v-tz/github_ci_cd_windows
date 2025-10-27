import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/sale_return/product_sale_return/product_sale_return_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../model/ProductInfoModel.dart';
import '../../../../widgets/MyElevatedButton.dart';
import '../../../../widgets/MyTextField.dart';
import '../../../../widgets/flutter_shortcut_widget.dart';
import '../../../../widgets/my_search_field/my_search_field.dart';

class ProductSalesReturnBottomSheet extends StatefulWidget {
  const ProductSalesReturnBottomSheet({super.key});

  @override
  State<ProductSalesReturnBottomSheet> createState() =>
      _WeavingItemBottomSheetState();
}

class _WeavingItemBottomSheetState
    extends State<ProductSalesReturnBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController(text: "0.00");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController();

  final FocusNode _productFocusNode = FocusNode();
  final FocusNode _qtyFocusNode = FocusNode();

  var deliveryQty = RxString("0");

  final _formKey = GlobalKey<FormState>();
  ProductSalesReturnController controller = Get.find();
  var lasSalesDetails = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSalesReturnController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add Item Product Sales Return'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Get.back(),
          ),
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MySearchField(
                                width: 350,
                                label: "Product Name",
                                enabled: false,
                                items: controller.productName,
                                textController: productNameController,
                                focusNode: _productFocusNode,
                                requestFocus: _qtyFocusNode,
                                onChanged: (ProductInfoModel item) {
                                  productName.value = item;
                                },
                              ),
                              Obx(
                                () => Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Delivery Qty : ${deliveryQty.value}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyTextField(
                                controller: qtyController,
                                focusNode: _qtyFocusNode,
                                hintText: "Return Quantity",
                                validate: "number",
                                onChanged: (value) {
                                  amountCalculation();
                                },
                                suffix: const Text(
                                  "Saree",
                                  style: TextStyle(color: Color(0xFF5700BC)),
                                ),
                              ),
                              Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  controller: rateController,
                                  hintText: "Rate",
                                  enabled: false,
                                  validate: "double",
                                  onChanged: (value) {
                                    amountCalculation();
                                  },
                                ),
                                onFocusChange: (hasFocus) {
                                  AppUtils.fractionDigitsText(
                                    rateController,
                                    fractionDigits: 2,
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyTextField(
                                controller: amountController,
                                hintText: "Amount",
                                enabled: false,
                              ),
                              MyTextField(
                                controller: detailsController,
                                hintText: "Details",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.center,
                      child: MyElevatedButton(
                        message: "",
                        onPressed: () => submit(),
                        child: const Text('ADD'),
                      ),
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      int qty = int.tryParse(qtyController.text) ?? 0;
      double amount = double.tryParse(amountController.text) ?? 0.0;

      int dQty = int.tryParse(deliveryQty.value) ?? 0;

      if (qty == 0) {
        return AppUtils.infoAlert(message: "The entered quantity is '0'");
      }

      if (amount == 0) {
        return AppUtils.infoAlert(message: "The entered amount is '0'");
      }
      if (dQty < qty) {
        return AppUtils.infoAlert(
            message: "Return quantity should be less than net quantity");
      }

      var request = {
        "product_name": productName.value?.productName,
        "product_id": productName.value?.id,
        "design_no": "",
        "work_no": "",
        "pieces": 0,
        "qty": qty,
        "rate": double.tryParse(rateController.text) ?? 0.0,
        "amount": amount,
        "details": detailsController.text,
      };

      Get.back(result: request);
    }
  }

  amountCalculation() {
    int qty = int.tryParse(qtyController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0.0;
    double amount = 0.0;
    amount = qty * rate;
    amountController.text = amount.toStringAsFixed(2);
  }

  controllerClear() {
    deliveryQty.value = "0";
    productName.value = null;
    productNameController.text = "";
    qtyController.text = "0";
    rateController.text = "0.00";
    amountController.text = "0.00";
    detailsController.text = "";

    FocusScope.of(context).requestFocus(_productFocusNode);
  }

  void _initValue() {
    if (Get.arguments != null) {
      var item = Get.arguments["item"];

      productName.value = ProductInfoModel(
          id: item["product_id"], productName: item["product_name"]);
      productNameController.text = item["product_name"];
      qtyController.text = "${item["qty"]}";
      rateController.text = "${item["rate"]}";
      amountController.text = "${item["amount"]}";
      detailsController.text = item["details"] ?? "";
      deliveryQty.value = "${item["qty"]}";
    }
  }
}
