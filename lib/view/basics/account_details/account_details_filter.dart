import 'package:abtxt/model/LedgerModel.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'account_details_controller.dart';

class AccountDetailsFilter extends StatelessWidget {
  const AccountDetailsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool ledgerRoleC = RxBool(false);
    RxBool ledgerNameC = RxBool(false);

    final FocusNode ledgerRoleFocusNode = FocusNode();
    final FocusNode ledgerNameFocusNode = FocusNode();
    final FocusNode submitFocusNode = FocusNode();

    TextEditingController ledgerRoleController = TextEditingController();
    TextEditingController ledgerNameTextController = TextEditingController();
    int? ledgerId;
    final formKey = GlobalKey<FormState>();

    return GetBuilder<AccountDetailsController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 450,
            height: 150,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: ledgerRoleC.value,
                          onChanged: (value) => ledgerRoleC.value = value!,
                        ),
                        subtitle: MySearchField(
                          label: "Ledger Role",
                          items: const ["Weaver", "Dyer", "Roller"],
                          textController: ledgerRoleController,
                          focusNode: ledgerRoleFocusNode,
                          requestFocus: ledgerNameFocusNode,
                          onChanged: (item) {
                            if (item == "Weaver") {
                              controller.isVisible.value = true;
                            } else {
                              controller.isVisible.value = false;
                            }

                            controller.ledgerRole = item;
                            ledgerRoleC.value = true;
                            var role = item.toString().toLowerCase();
                            controller.ledgerInfo(role);
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: ledgerNameC.value,
                          onChanged: (value) => ledgerNameC.value = value!,
                        ),
                        subtitle: MySearchField(
                          label: "Ledger Name",
                          items: controller.ledgerDropdown,
                          textController: ledgerNameTextController,
                          focusNode: ledgerNameFocusNode,
                          requestFocus: submitFocusNode,
                          isValidate: ledgerNameC.value,
                          onChanged: (LedgerModel item) {
                            ledgerId = item.id;
                            ledgerNameC.value = true;
                          },
                        ),
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
            focusNode: submitFocusNode,
            child: const Text('APPLY'),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              request["ledger_role"] = ledgerRoleController.text.toLowerCase();

              if (ledgerNameC.value == true) {
                request['ledger_id'] = ledgerId;
              }

              controller.filterData = request;
              Get.back(result: controller.filterData);
            },
          ),
        ],
      );
    });
  }
}
