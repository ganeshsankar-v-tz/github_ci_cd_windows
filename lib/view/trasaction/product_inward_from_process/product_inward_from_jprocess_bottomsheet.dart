import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_process_controller.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/process_inward/ProcessInwardProcessTypeModel.dart';
import '../../../model/process_inward/ProcessInwardProductNameModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import 'add_product_inward_from_process.dart';

class ProductInwardFromProcessBottomSheet extends StatefulWidget {
  final ProcessInwardItemDataSource dataSource;

  const ProductInwardFromProcessBottomSheet({
    super.key,
    required this.dataSource,
  });

  @override
  State<ProductInwardFromProcessBottomSheet> createState() => _State();
}

class _State extends State<ProductInwardFromProcessBottomSheet> {
  Rxn<ProcessInwardProcessTypeModel> processTypeController =
      Rxn<ProcessInwardProcessTypeModel>();
  TextEditingController processTypeTextController = TextEditingController();
  Rxn<ProcessInwardProductNameModel> productNameController =
      Rxn<ProcessInwardProductNameModel>();
  TextEditingController productNameTextController = TextEditingController();
  TextEditingController designNoController = TextEditingController();
  TextEditingController piecesController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: "0");
  TextEditingController wagesController = TextEditingController(text: "0.00");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController inwardTypeController =
      TextEditingController(text: "Worked");
  TextEditingController lotController = TextEditingController();
  TextEditingController deliveredController = TextEditingController();
  ProductInwardFromProcessController controller = Get.find();

  final _productNameFocus = FocusNode();
  final _processTypeFocs = FocusNode();
  final _piecesTypeFocs = FocusNode();

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInwardFromProcessController>(
        builder: (controller) {
      return ShortCutWidget(
        autofocus: false,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        appBar: AppBar(
            title: const Text('Add Item to Product Inward From Process')),
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
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
                              MySearchField(
                                label: "Process Type",
                                textController: processTypeTextController,
                                items: controller.processType,
                                focusNode: _processTypeFocs,
                                requestFocus: _productNameFocus,
                                onChanged:
                                    (ProcessInwardProcessTypeModel item) {
                                  processTypeController.value = item;
                                  productNameTextController.text = "";
                                  if (controller.dcRecNo != null) {
                                    controller.productNameDetails(
                                        controller.dcRecNo, item.processType);
                                  }
                                },
                              ),
                              MySearchField(
                                width: 350,
                                label: 'Product Name',
                                textController: productNameTextController,
                                items: controller.productName,
                                focusNode: _productNameFocus,
                                requestFocus: _piecesTypeFocs,
                                onChanged:
                                    (ProcessInwardProductNameModel item) {
                                  productNameController.value = item;
                                  productDetailsDisplay(item);
                                },
                              ),
                              MyTextField(
                                controller: designNoController,
                                hintText: 'Design No',
                                enabled: false,
                              ),
                              MyTextField(
                                focusNode: _piecesTypeFocs,
                                controller: piecesController,
                                hintText: "Pieces",
                                validate: "number",
                              ),
                              MyTextField(
                                controller: quantityController,
                                hintText: "Quantity",
                                validate: "number",
                              ),
                              MyTextField(
                                controller: deliveredController,
                                hintText: "Delivered",
                                readonly: true,
                                enabled: false,
                              ),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    validate: 'double',
                                    controller: wagesController,
                                    hintText: "Wages (Rs)",
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(wagesController,
                                        fractionDigits: 2);
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    validate: 'double',
                                    controller: amountController,
                                    hintText: "Amount (Rs)",
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        amountController,
                                        fractionDigits: 2);
                                  }),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyAddButton(
                                onPressed: () => submit(),
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
          ),
        ),
      );
    });
  }

  submit() {
    var deliverQty = int.tryParse(deliveredController.text) ?? 0;
    var inwardQty = int.tryParse(quantityController.text) ?? 0;
    if (_formKey.currentState!.validate()) {
      if (inwardQty == 0) {
        var message = "Enter the valid quantity";
        _alertDialog(message);
      } else if (inwardQty <= deliverQty) {
        var request = {
          "product_name": productNameController.value?.productName,
          "process_type": processTypeController.value?.processType,
          "design_no": designNoController.text,
          "pieces": int.tryParse(piecesController.text) ?? 0,
          "quantity": int.tryParse(quantityController.text) ?? 0,
          "wages": double.tryParse(wagesController.text) ?? 0,
          "amount": double.tryParse(amountController.text) ?? 0.00,
          "lot_no": lotController.text,
          "product_id": productNameController.value?.productId,
          "sync": 0
        };

        controller.itemList.add(request);
        widget.dataSource.updateDataGridRows();
        widget.dataSource.updateDataGridSource();
        controllersClear();
      } else {
        var message = "Inward Quantity is greater than delivered quantity";
        _alertDialog(message);
      }
    }
  }

  _alertDialog(var message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 2,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Alert!',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text('$message'),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              autofocus: true,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void productDetailsDisplay(ProcessInwardProductNameModel item) {
    designNoController.text = item.designNo ?? "";
    piecesController.text = "${item.pieces}";
    wagesController.text = "${item.rate}";
    amountController.text = "${item.amount}";

    int deliveredQty = item.quantity ?? 0;
    int addedQty = 0;
    for (var e in controller.itemList) {
      if (e["product_id"] == productNameController.value?.productId &&
          e["sync"] == 0) {
        addedQty += int.tryParse("${e["quantity"]}") ?? 0;
      }
    }
    deliveredController.text = "${deliveredQty - addedQty}";
  }

  controllersClear() {
    processTypeController.value = null;
    processTypeTextController.text = "";
    productNameController.value = null;
    productNameTextController.text = "";
    designNoController.text = "";
    piecesController.text = "0";
    quantityController.text = "0";
    deliveredController.text = "0";
    wagesController.text = "0.00";
    amountController.text = "0.00";

    FocusScope.of(context).requestFocus(_processTypeFocs);
  }
}
