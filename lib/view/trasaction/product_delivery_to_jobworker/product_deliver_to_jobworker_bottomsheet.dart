import 'package:abtxt/model/ProductJobWork.dart';
import 'package:abtxt/view/basics/Product_Job_Work/addProduct_Job_Work.dart';
import 'package:abtxt/view/basics/productinfo/add_product_info.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker_controller.dart';
import 'package:abtxt/widgets/MyAddButton.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/searchfield/decoration.dart';
import '../../../widgets/searchfield/searchfield.dart';

class ProductDeliverToJobWorkerBottomSheet extends StatefulWidget {
  const ProductDeliverToJobWorkerBottomSheet({super.key});

  @override
  State<ProductDeliverToJobWorkerBottomSheet> createState() => _State();
}

class _State extends State<ProductDeliverToJobWorkerBottomSheet> {
  TextEditingController orderedWorkController = TextEditingController();
  Rxn<ProductJobWork> orderWork = Rxn<ProductJobWork>();
  TextEditingController productNameController = TextEditingController();
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController designNoController = TextEditingController();
  TextEditingController workNameController = TextEditingController(text: "No");
  TextEditingController workController = TextEditingController();
  TextEditingController piecesController = TextEditingController(text: "0");
  TextEditingController quantityController = TextEditingController(text: "0");
  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController agentNameController = TextEditingController(text: "");

  var selectedVal = "".obs;
  ProductDeliverToJobWorkerController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  RxBool isUpdate = RxBool(false);
  final FocusNode _workNameFocusNode = FocusNode();
  final FocusNode _orderWorkFocusNode = FocusNode();
  final FocusNode _productNameFocusNode = FocusNode();
  var shortCut = RxString("");

  @override
  void initState() {
    _initValue();
    _orderWorkFocusNode.addListener(() => shortCutKeys());
    _productNameFocusNode.addListener(() => shortCutKeys());
    super.initState();
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_workNameFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDeliverToJobWorkerController>(
        builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
            title: const Text('Add Item to Product Deliver To JobWorker')),
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Focus(
                            focusNode: _orderWorkFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Ordered Work',
                              items: controller.orderedWork,
                              selectedItem: orderWork.value,
                              enabled: !isUpdate.value,
                              onChanged: (ProductJobWork item) {
                                orderWork.value = item;
                              },
                            ),
                          ),
                          MySearchField(
                              label: 'Product Name',
                              width: 340,
                              items: controller.productNameList,
                              textController: productNameController,
                              focusNode: _productNameFocusNode,
                              requestFocus: _workNameFocusNode,
                              enabled: !isUpdate.value,
                              onChanged: (ProductInfoModel item) {
                                productName.value = item;
                                designNoController.text = item.designNo ?? '';
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyDropdownButtonFormField(
                                controller: workNameController,
                                hintText: "Work Name",
                                items: const ["No", "Yes"],
                                onChanged: (val) {
                                  selectedVal.value = val;
                                },
                                focusNode: _workNameFocusNode,
                              ),
                              Obx(
                                () => Visibility(
                                  visible: selectedVal.value == "Yes",
                                  child: MyAutoComplete(
                                    label: '',
                                    items: controller.orderedWork,
                                    selectedItem: productName.value,
                                    onChanged: (ProductJobWork item) {
                                      workController.text = '${item.workName}';
                                      orderWork.value = item;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: [
                              MyTextField(
                                controller: piecesController,
                                hintText: "Pieces",
                                validate: "number",
                              ),
                              MyTextField(
                                controller: quantityController,
                                hintText: "Quantity",
                                validate: "number",
                                onChanged: (value) => calculation(),
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
                                controller: detailsController,
                                hintText: "Details",
                              ),
                              MyTextField(
                                controller: lotController,
                                hintText: "Lot",
                              ),
                            ],
                          ),
                        ],
                      ),
                      MyTextField(
                        controller: agentNameController,
                        hintText: "Agent Name",
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

  submit() async {
    if (_formKey.currentState!.validate()) {
      var result = await controller.rowUpdateCheckApi(
          controller.slipId, productName.value?.id, orderWork.value?.id);

      if (result != "Sucess") {
        return;
      }

      int workNo = 0;
      if (workNameController.text == "Yes") {
        workNo = 1;
      }

      if (isUpdate.value == false) {
        for (var e in controller.itemList) {
          if (e["order_work_id"] == orderWork.value?.id &&
              e["product_id"] == productName.value?.id) {
            return AppUtils.infoAlert(
                message: "This order work and product already added");
          }
        }
      }

      var request = {
        "order_work_id": orderWork.value?.id,
        "work_name": orderWork.value?.workName,
        "product_id": productName.value?.id,
        "product_name": productName.value?.productName,
        "design_no": designNoController.text,
        "work_no": workNo,
        "pieces": int.tryParse(piecesController.text) ?? 0,
        "qty": int.tryParse(quantityController.text) ?? 0,
        "rate": int.tryParse(rateController.text) ?? 0,
        "amount": double.tryParse(amountController.text) ?? 0.00,
        "ch_details": detailsController.text,
        "lot_no": lotController.text,
        "sync": 0,
        "agent_name": agentNameController.text
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = Get.arguments['item'];
      designNoController.text = item['design_no'] ?? '';
      workNameController.text = item['work_no'] == '0' ? "Yes" : "No";
      piecesController.text = '${item['pieces']}';
      quantityController.text = '${item['qty']}';
      rateController.text = '${item['rate']}';
      amountController.text = '${item['amount']}';
      detailsController.text = '${item['ch_details'] ?? ""}';
      lotController.text = '${item['lot_no'] ?? ""}';
      agentNameController.text = '${item['agent_name'] ?? ""}';

      var orderWorkList = controller.orderedWork
          .where((element) => '${element.id}' == '${item['order_work_id']}')
          .toList();
      if (orderWorkList.isNotEmpty) {
        orderWork.value = orderWorkList.first;
        orderedWorkController.text = "${orderWorkList.first.workName}";
      }

      var productNameList = controller.productNameList
          .where((element) => '${element.id}' == '${item['product_id']}')
          .toList();
      if (productNameList.isNotEmpty) {
        productName.value = productNameList.first;
        productNameController.text = "${productNameList.first.productName}";
      }
    }
  }

  void calculation() {
    int rate = int.tryParse(rateController.text) ?? 0;
    int qty = int.tryParse(quantityController.text) ?? 0;
    double amount = double.tryParse("${qty * rate}") ?? 0.00;

    amountController.text = amount.toStringAsFixed(2);
  }

  shortCutKeys() {
    if (_orderWorkFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Order Work',Press Alt+C ";
    } else if (_productNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'Product',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_orderWorkFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddProductJobWork.routeName);

      if (result == "success") {
        controller.orderedWorkName();
      }
    } else if (_productNameFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddProductInfo.routeName);

      if (result == "success") {
        controller.productInfo();
      }
    }
  }

  orderWorkDropDownWidget() {
    var list = controller.orderedWork;
    var suggestions = list.map((e) {
      return SearchFieldListItem<ProductJobWork>('${e.workName}', item: e);
    }).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<ProductJobWork>(
        suggestions: suggestions,
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: orderedWorkController,
        searchInputDecoration: const InputDecoration(
            label: Text('Ordered Work'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        focusNode: _orderWorkFocusNode,
        autofocus: true,
        enabled: !isUpdate.value,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_productNameFocusNode);
          var item = value.item!;
          orderWork.value = item;
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (orderedWorkController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }

  productNameDropDownWidget() {
    var list = controller.productNameList;
    var suggestions = list.map((e) {
      return SearchFieldListItem<ProductInfoModel>('${e.productName}', item: e);
    }).toList();
    return Container(
      width: 240,
      padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
      child: SearchField<ProductInfoModel>(
        suggestions: suggestions,
        suggestionsDecoration:
            SuggestionDecoration(selectionColor: const Color(0xffA3D8FF)),
        maxSuggestionsInViewPort: 7,
        itemHeight: 50,
        controller: productNameController,
        searchInputDecoration: const InputDecoration(
            label: Text('Product Name'),
            labelStyle: TextStyle(fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF939393), width: 0.4),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down)),
        focusNode: _productNameFocusNode,
        autofocus: true,
        enabled: !isUpdate.value,
        onScroll: (a, b) {},
        onSuggestionTap: (value) {
          FocusScope.of(context).requestFocus(_workNameFocusNode);
          var item = value.item!;
          productName.value = item;
          designNoController.text = item.designNo ?? '';
        },
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (productNameController.text.isEmpty) {
            return "Required";
          } else {
            return null;
          }
        },
      ),
    );
  }
}
