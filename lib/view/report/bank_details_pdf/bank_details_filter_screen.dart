import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MyMultiSelectDropdown.dart';
import 'package:abtxt/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../model/LedgerModel.dart';
import '../../../widgets/my_dropdowns/MyMultiSelectDropdown.dart';
import '../../../widgets/my_search_field/my_search_field.dart';
import 'bank_details_controller.dart';

class BankDetailsPDFFilter extends StatefulWidget {
  const BankDetailsPDFFilter({super.key});

  @override
  State<BankDetailsPDFFilter> createState() => _BankDetailsPDFFilterState();
}

class _BankDetailsPDFFilterState extends State<BankDetailsPDFFilter> {
  RxBool ledgerRoleC = RxBool(true);
  RxBool ledgerNameC = RxBool(false);
  RxBool bankNameC = RxBool(false);
  RxBool branchNameC = RxBool(false);
  RxBool ifscCodeC = RxBool(false);

  final FocusNode ledgerRoleFocusNode = FocusNode();
  final FocusNode ledgerNameFocusNode = FocusNode();
  final FocusNode bankNameFocusNode = FocusNode();

  RxList<LedgerModel> ledgerItems = <LedgerModel>[].obs;

  TextEditingController ledgerRoleController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController reportFormatController =
      TextEditingController(text: "Pdf");

  final formKey = GlobalKey<FormState>();
  BankDetailsController controller = Get.find<BankDetailsController>();

  @override
  void initState() {
    super.initState();
    // controller.ledgerDropdown.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankDetailsController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return SizedBox(
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
                        onChanged: (item) async {
                          ledgerRoleC.value = true;
                          var role = item.toString().toLowerCase();
                          controller.ledgerDropdown.clear();
                          controller.ledgerDropdown
                              .assignAll(await controller.ledgerInfo(role));

                          controller.update();
                        },
                      ),
                    ),
                  );
                }),
                Obx(() {
                  return SizedBox(
                    width: 325,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 15),
                        Checkbox(
                          focusNode: ledgerNameFocusNode,
                          value: ledgerNameC.value,
                          onChanged: (value) => ledgerNameC.value = value!,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: MyMultiSelectDropdown(
                            items: controller.ledgerDropdown.toList(),
                            label: "Ledger Name",
                            isValidate: ledgerNameC.value,
                            onConfirm: (item) {
                              var res = item.cast<LedgerModel>();
                              ledgerNameC.value = true;
                              ledgerItems.value = res.toList();
                              controller.update();
                            },
                          ),
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: bankNameC.value,
                        onChanged: (value) => bankNameC.value = value!,
                      ),
                      subtitle: MyTextField(
                        focusNode: bankNameFocusNode,
                        controller: bankController,
                        hintText: 'Bank Name',
                      ),
                    ),
                  );
                }),
                Obx(() {
                  return SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: branchNameC.value,
                        onChanged: (value) => branchNameC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: branchController,
                        hintText: 'Branch',
                      ),
                    ),
                  );
                }),
                Obx(() {
                  return SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: ifscCodeC.value,
                        onChanged: (value) => ifscCodeC.value = value!,
                      ),
                      subtitle: MyTextField(
                        controller: ifscCodeController,
                        hintText: 'IFSC Code',
                      ),
                    ),
                  );
                }),
                Row(
                  children: [
                    const SizedBox(width: 60),
                    MyDropdownButtonFormField(
                      items: const ["Pdf", "Excel"],
                      controller: reportFormatController,
                      hintText: 'Report Format',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('APPLY'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              var request = <String, dynamic>{};

              List selectedLedgerId =
                  ledgerItems.map((element) => element.id).toList();

              if (ledgerNameC.value == true) {
                for (int i = 0; i < selectedLedgerId.length; i++) {
                  request["ledger_ids[$i]"] = selectedLedgerId[i];
                }
              }
              if (bankNameC.value == true) {
                request['bank_name'] = bankController.text;
              }
              if (ledgerRoleC.value == true) {
                request['ledger_role'] = ledgerRoleController.text;
              }
              if (branchNameC.value == true) {
                request['branch'] = branchController.text;
              }

              request['report_format'] =
                  reportFormatController.text.toLowerCase();

              Get.back(result: request);
            },
          ),
        ],
      );
    });
  }
}
