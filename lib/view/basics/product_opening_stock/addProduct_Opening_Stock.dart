import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/basics/product_opening_stock/productopeningstock_controller.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/productopeningstockModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class AddProductOpeningStock extends StatefulWidget {
  const AddProductOpeningStock({super.key});

  static const String routeName = '/AddProductOpeningStock';

  @override
  State<AddProductOpeningStock> createState() => _State();
}

class _State extends State<AddProductOpeningStock> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<ProductInfoModel> productNameController = Rxn<ProductInfoModel>();
  TextEditingController productNameTextController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProductOpeningStockController controller;

  final FocusNode _productFocusNode = FocusNode();
  final FocusNode _qtyFocusNode = FocusNode();

  RxBool isUpdate = RxBool(false);

  @override
  void initState() {
    _initValue();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        FocusScope.of(context).requestFocus(_qtyFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOpeningStockController>(builder: (controller) {
      this.controller = controller;
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Product Opening Balance"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  controller.delete(idController.text, password);
                },
              ),
            ),
          ],
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
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Visibility(
                          visible: false,
                          child: MyTextField(
                            controller: idController,
                            hintText: "ID",
                            enabled: false,
                          ),
                        ),
                        MyDateFilter(
                          autofocus: false,
                          controller: dateController,
                          labelText: "Date",
                          enabled: !isUpdate.value,
                        ),
                        MySearchField(
                          width: 350,
                          label: "Product Name",
                          enabled: !isUpdate.value,
                          items: controller.productName,
                          textController: productNameTextController,
                          focusNode: _productFocusNode,
                          requestFocus: _qtyFocusNode,
                          onChanged: (ProductInfoModel item) {
                            productNameController.value = item;
                          },
                        ),
                        MyTextField(
                          focusNode: _qtyFocusNode,
                          controller: quantityController,
                          hintText: "Quantity",
                          validate: "number",
                        ),
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MySubmitButton(
                        onPressed: controller.status.isLoading ? null : submit,
                      ),
                    )
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
      Map<String, dynamic> request = {
        "product_id": productNameController.value?.id,
        "e_date": dateController.text,
        "quantity": int.tryParse(quantityController.text) ?? 0,
        "details": detailsController.text,
      };
      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");

    if (Get.arguments != null) {
      ProductOpeningStockModel item = Get.arguments["item"];
      isUpdate.value = true;

      idController.text = '${item.id}';
      dateController.text = "${item.eDate}";
      quantityController.text = "${item.quantity}";
      detailsController.text = tryCast(item.details);
      productNameTextController.text = "${item.productName}";
      productNameController.value =
          ProductInfoModel(id: item.productId, productName: item.productName);
    }
  }
}
