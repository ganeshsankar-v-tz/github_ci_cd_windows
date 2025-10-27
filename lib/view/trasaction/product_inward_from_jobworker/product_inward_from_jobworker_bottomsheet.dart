import 'package:abtxt/model/job_work_inward_models/JobWorkInwardOrderedWork.dart';
import 'package:abtxt/model/job_work_inward_models/JobWorkInwardProductDetailsModel.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/app_utils.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class ProductInwardFromJobWorkerBottomSheet extends StatefulWidget {
  const ProductInwardFromJobWorkerBottomSheet({super.key});

  @override
  State<ProductInwardFromJobWorkerBottomSheet> createState() => _State();
}

class _State extends State<ProductInwardFromJobWorkerBottomSheet> {
  Rxn<JobWorkInwardOrderedWork> orderedWorkController =
      Rxn<JobWorkInwardOrderedWork>();
  Rxn<JobWorkInwardProductDetailsModel> productNameController =
      Rxn<JobWorkInwardProductDetailsModel>();
  TextEditingController workController = TextEditingController();
  TextEditingController piecesController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: "0");
  TextEditingController wagesController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController inwardTypeController =
      TextEditingController(text: "Worked");
  TextEditingController lotController = TextEditingController();
  TextEditingController deliveredController = TextEditingController();
  ProductInwardFromJobWorkerController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);

  RxInt selectedTotalQty = RxInt(0);

  @override
  void initState() {
    controller.productNameDetails.clear();
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductInwardFromJobWorkerController>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
            title: const Text('Add Item to Product Inward From JobWorker')),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
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
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          MyAutoComplete(
                            textInputAction: TextInputAction.none,
                            label: 'Ordered Work',
                            enabled: !isUpdate.value,
                            items: controller.orderedWork,
                            selectedItem: orderedWorkController.value,
                            onChanged: (JobWorkInwardOrderedWork item) {
                              orderedWorkController.value = item;
                              productNameController.value = null;

                              if (controller.dcRecNo != null) {
                                controller.productDetails(
                                    controller.dcRecNo, item.orderWorkId);
                              }
                            },
                          ),
                          MyAutoComplete(
                            label: 'Product Name',
                            enabled: !isUpdate.value,
                            items: controller.productNameDetails,
                            selectedItem: productNameController.value,
                            onChanged: (JobWorkInwardProductDetailsModel item) {
                              productNameController.value = item;
                              productDetailsDisplay(item);
                            },
                            autofocus: false,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyTextField(
                                controller: workController,
                                hintText: "Work Name",
                                readonly: true,
                                enabled: !isUpdate.value,
                              ),
                              MyTextField(
                                controller: piecesController,
                                hintText: "Pieces",
                                validate: "number",
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyTextField(
                                controller: quantityController,
                                hintText: "Quantity",
                                validate: "number",
                                onChanged: (value) {
                                  amountCalculation();
                                },
                              ),
                              MyTextField(
                                controller: deliveredController,
                                hintText: "Delivered",
                                readonly: true,
                                enabled: false,
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
                                    controller: wagesController,
                                    hintText: "Wages (Rs)",
                                    validate: "double",
                                    onChanged: (value) {
                                      amountCalculation();
                                    },
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(wagesController,
                                        fractionDigits: 2);
                                  }),
                              Focus(
                                  skipTraversal: true,
                                  child: MyTextField(
                                    controller: amountController,
                                    hintText: "Amount (Rs)",
                                    validate: "double",
                                  ),
                                  onFocusChange: (hasFocus) {
                                    AppUtils.fractionDigitsText(
                                        amountController,
                                        fractionDigits: 2);
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                controller: inwardTypeController,
                                hintText: "Inward Type",
                                items: const ["Worked", "Return"],
                              ),
                              MyTextField(
                                controller: lotController,
                                hintText: "Lot",
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: MyAddButton(onPressed: () => submit()),
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

  submit() {
    int deliverQty = int.tryParse(deliveredController.text) ?? 0;
    int inwardQty = int.tryParse(quantityController.text) ?? 0;

    if (_formKey.currentState!.validate()) {
      int addedQty = 0;

      if (Get.arguments == null) {
        for (var e in controller.itemList) {
          if (e["product_id"] == productNameController.value?.productId &&
              e["order_work_id"] == orderedWorkController.value?.orderWorkId) {
            addedQty += int.tryParse("${e["qty"]}") ?? 0;
          }
        }
        addedQty = addedQty + inwardQty;
      }

      if (addedQty > selectedTotalQty.value) {
        AppUtils.infoAlert(
          message: "Quantity is greater than delivered quantity",
        );
        return;
      }

      if (inwardQty == 0) {
        var message = "Enter the valid quantity";
        AppUtils.infoAlert(message: message);
      } else if (inwardQty <= deliverQty) {
        var request = {
          "work_name": orderedWorkController.value?.orderWorkName,
          "product_name": productNameController.value?.productName,
          "work_no": int.tryParse(workController.text) ?? 0,
          "pieces": int.tryParse(piecesController.text) ?? 0,
          "qty": int.tryParse(quantityController.text) ?? 0,
          "wages": double.tryParse(wagesController.text) ?? 0.0,
          "amount": double.tryParse(amountController.text) ?? 0.0,
          "lot_no": lotController.text,
          "inw_typ": inwardTypeController.text,
          "order_work_id": orderedWorkController.value?.orderWorkId,
          "product_id": productNameController.value?.productId,
          "sync": 0
        };
        Get.back(result: request);
      } else {
        AppUtils.infoAlert(
          message: "Quantity is greater than delivered quantity",
        );
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      orderedWorkController.value = JobWorkInwardOrderedWork(
          orderWorkId: item["order_work_id"], orderWorkName: item['work_name']);
      productNameController.value = JobWorkInwardProductDetailsModel(
          productName: item['product_name'], productId: item["product_id"]);
      workController.text = "${item['work_no']}";
      piecesController.text = '${item['pieces']}';
      deliveredController.text = '${item['qty']}';
      quantityController.text = '${item['qty']}';
      wagesController.text = '${item['wages']}';
      amountController.text = '${item['amount']}';
      lotController.text = item['lot_no'] ?? '';
    }
  }

  void productDetailsDisplay(JobWorkInwardProductDetailsModel item) {
    workController.text = "";
    piecesController.text = '${item.pieces}';
    wagesController.text = item.rate!.toStringAsFixed(2);
    amountController.text = item.amount!.toStringAsFixed(2);
    selectedTotalQty.value = item.qty ?? 0;

    int deliveredQty = item.qty ?? 0;
    int addedQty = 0;
    for (var e in controller.itemList) {
      if (e["product_id"] == productNameController.value?.productId &&
          e["order_work_id"] == orderedWorkController.value?.orderWorkId &&
          e["sync"] == 0) {
        addedQty += int.tryParse("${e["qty"]}") ?? 0;
      }
    }
    deliveredController.text = "${deliveredQty - addedQty}";
  }

  amountCalculation() {
    int qty = int.tryParse(quantityController.text) ?? 0;
    double wages = double.tryParse(wagesController.text) ?? 0.0;
    double amount = qty * wages;
    amountController.text = amount.toStringAsFixed(2);
  }
}
