import 'package:abtxt/model/ProcessTypeModel.dart';
import 'package:abtxt/view/basics/productinfo/add_product_info.dart';
import 'package:abtxt/view/trasaction/product_deliver_to_process/product_deliver_to_process_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'add_product_deliver_to_process.dart';

class ProductDeliverToProcessBottomSheet extends StatefulWidget {
  final ProcessDeliveryItemDataSource dataGridSource;
  final List<dynamic> itemDetails;
  final Function balesCalculation;

  const ProductDeliverToProcessBottomSheet({
    super.key,
    required this.dataGridSource,
    required this.itemDetails,
    required this.balesCalculation,
  });

  @override
  State<ProductDeliverToProcessBottomSheet> createState() => _State();
}

class _State extends State<ProductDeliverToProcessBottomSheet> {
  Rxn<ProcessTypeModel> processType = Rxn<ProcessTypeModel>();
  TextEditingController processTypeController = TextEditingController();
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workNameController = TextEditingController(text: "No");
  TextEditingController workController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: "0");
  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController(text: "");
  TextEditingController bagsController = TextEditingController(text: "0");
  TextEditingController agentNameController = TextEditingController(text: "");
  ProductDeliverToProcessController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  final FocusNode _processTypeFocusNode = FocusNode();
  final FocusNode _productNameFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _productNameFocusNode.addListener(() => shortCutKeys());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDeliverToProcessController>(builder: (controller) {
      return ShortCutWidget(
        appBar:
            AppBar(title: const Text('Add Item to Product Deliver To Process')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        MySearchField(
                          setInitialValue: false,
                          label: 'Process Type',
                          items: controller.processType,
                          textController: processTypeController,
                          focusNode: _processTypeFocusNode,
                          requestFocus: _productNameFocusNode,
                          onChanged: (ProcessTypeModel item) async {
                            processType.value = item;
                          },
                        ),
                        MySearchField(
                          width: 340,
                          label: 'Product Name',
                          items: controller.productName,
                          enabled: !isUpdate.value,
                          textController: productNameController,
                          focusNode: _productNameFocusNode,
                          requestFocus: _quantityFocusNode,
                          onChanged: (ProductInfoModel item) async {
                            productName.value = item;
                            designNoController.text = item.designNo ?? '';
                          },
                        ),
                      ],
                    ),
                    MyTextField(
                      controller: quantityController,
                      hintText: "Quantity",
                      validate: "number",
                      onChanged: (value) => calculation(),
                      focusNode: _quantityFocusNode,
                    ),
                    MyTextField(
                      controller: bagsController,
                      hintText: "Bags",
                      validate: "number",
                    ),
                    MyTextField(
                      controller: detailsController,
                      hintText: "Details",
                    ),
                    MyTextField(
                      controller: agentNameController,
                      hintText: "Agent Name",
                    ),
                    Visibility(
                      visible: false,
                      child: Row(
                        children: [
                          Wrap(
                            children: [
                              MyTextField(
                                controller: rateController,
                                hintText: "Rate (Rs)",
                                validate: "number",
                                onChanged: (value) => calculation(),
                              ),
                              MyTextField(
                                controller: amountController,
                                hintText: "Amount (Rs)",
                                validate: "double",
                                readonly: true,
                                enabled: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(shortCut.value,
                              style: AppUtils.shortCutTextStyle()),
                        ),
                        const SizedBox(width: 12),
                        MyAddButton(
                          onPressed: () => submit(),
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
    int workNo = 0;
    if (workNameController.text == "yes") {
      workNo = 1;
    }
    if (_formKey.currentState!.validate()) {
      if (processType.value == null) {
        return AppUtils.infoAlert(message: "Select the process type");
      }

      for (var e in widget.itemDetails) {
        if (e["product_id"] == productName.value?.id &&
            e["process_type"] == processType.value?.processType) {
          return AppUtils.infoAlert(
              message: "This Product and Process type already added");
        }
      }

      var request = {
        "process_type": processType.value?.processType,
        "product_id": productName.value?.id,
        "product_name": productName.value?.productName,
        "design_no": designNoController.text,
        "work_no": workNo,
        "pieces": 0,
        "quantity": int.tryParse(quantityController.text) ?? 0,
        "rate": int.tryParse(rateController.text) ?? 0,
        "amount": double.tryParse(amountController.text) ?? 0.00,
        "bags": int.tryParse(bagsController.text) ?? 0,
        "details": detailsController.text,
        "agent_name": agentNameController.text
      };

      widget.itemDetails.add(request);
      widget.dataGridSource.updateDataGridRows();
      widget.dataGridSource.updateDataGridSource();
      widget.balesCalculation();
      controllerClear();
    }
  }

  void calculation() {
    int rate = int.tryParse(rateController.text) ?? 0;
    int qty = int.tryParse(quantityController.text) ?? 0;
    double amount = double.tryParse("${qty * rate}") ?? 0.00;

    amountController.text = amount.toStringAsFixed(2);
  }

  shortCutKeys() {
    if (_productNameFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Product',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_productNameFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddProductInfo.routeName);

      if (result == "success") {
        debugPrint("True");
        controller.productInfo();
      }
    }
  }

  controllerClear() {
    processTypeController.text = "";
    processType.value = null;
    productNameController.text = "";
    productName.value = null;
    quantityController.text = "0";
    bagsController.text = "0";
    detailsController.text = "";
    agentNameController.text = "";

    FocusScope.of(context).requestFocus(_processTypeFocusNode);
  }
}
