import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/production/warp_notification/warp_notification_controller.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/LedgerModel.dart';
import '../../../model/NewWarpModel.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MyDateFilter.dart';

class WarpNotificationFilter extends StatelessWidget {
  const WarpNotificationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool warpDesignC = RxBool(false);
    RxBool weaverNameC = RxBool(false);
    RxBool loomC = RxBool(false);
    RxBool productNameC = RxBool(false);
    RxBool statusC = RxBool(false);
    RxBool warpTypeC = RxBool(false);

    Rxn<LedgerModel> weaver = Rxn<LedgerModel>();
    Rxn<NewWarpModel> warpDesign = Rxn<NewWarpModel>();
    Rxn<ProductInfoModel> product = Rxn<ProductInfoModel>();

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController loomController = TextEditingController();
    TextEditingController statusController =
        TextEditingController(text: "Pending");
    TextEditingController warpTypeController =
        TextEditingController(text: "Main Warp");

    var weaverId;
    var warpDesignId;
    var productId;
    final _formKey = GlobalKey<FormState>();
    return GetX<WarpNotificationController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: 580,
            height: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Checkbox(
                      value: dateC.value,
                      onChanged: (value) => dateC.value = value!,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            MyDateFilter(
                              controller: fromDateController,
                              labelText: "From Date",
                              required: dateC.value,
                            ),
                            MyDateFilter(
                              controller: toDateController,
                              labelText: "To Date",
                              required: dateC.value,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: warpDesignC.value,
                        onChanged: (value) => warpDesignC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Warp Design',
                        items: controller.warpName,
                        selectedItem: warpDesign.value,
                        isValidate: warpDesignC.value,
                        onChanged: (NewWarpModel item) {
                          warpDesign.value = item;
                          warpDesignId = item.id;
                          warpDesignC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: weaverNameC.value,
                        onChanged: (value) => weaverNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Weaver',
                        items: controller.weaverName,
                        isValidate: weaverNameC.value,
                        selectedItem: weaver.value,
                        onChanged: (LedgerModel item) {
                          weaver.value = item;
                          weaverId = item.id;
                          weaverNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: loomC.value,
                        onChanged: (value) => loomC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: loomController,
                        hintText: "Loom",
                        validate: loomC.value ? 'number' : '',
                        onChanged: (value) {
                          loomC.value = loomController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: productNameC.value,
                        onChanged: (value) => productNameC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        label: 'Product Name',
                        items: controller.productName,
                        isValidate: productNameC.value,
                        selectedItem: product.value,
                        onChanged: (ProductInfoModel item) {
                          product.value = item;
                          productId = item.id;
                          productNameC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: statusC.value,
                        onChanged: (value) => statusC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: statusController,
                        hintText: "Status",
                        items: const ["Pending", "Completed", "Accepted"],
                        onChanged: (value) {
                          statusC.value = statusController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: warpTypeC.value,
                        onChanged: (value) => warpTypeC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: warpTypeController,
                        hintText: "Warp Type",
                        items: const ["Main Warp", "Other"],
                        onChanged: (value) {
                          warpTypeC.value = true;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('APPLY'),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }
              if (weaverNameC.value == true) {
                request['weaver_id'] = weaverId;
              }
              if (warpDesignC.value == true) {
                request['warp_design_id'] = warpDesignId;
              }
              if (loomC.value == true) {
                request['loom'] = loomController.text;
              }
              if (productNameC.value == true) {
                request['product_id'] = productId;
              }

              if (statusC.value == true) {
                request['warp_status'] = statusController.text;
              }
              if (warpTypeC.value == true) {
                request['warp_type'] = warpTypeController.text;
              }
              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
