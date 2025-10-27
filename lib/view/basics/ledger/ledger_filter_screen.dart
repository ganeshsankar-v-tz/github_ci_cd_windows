import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/AccountTypeModel.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyFilterTextField.dart';
import 'ledger_controller.dart';

class LedgerFilter extends StatelessWidget {
  const LedgerFilter({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool agentC = RxBool(false);
    RxBool ledgerC = RxBool(false);
    RxBool ledgerRoleC = RxBool(false);
    RxBool accountC = RxBool(false);
    RxBool areaC = RxBool(false);
    RxBool cityC = RxBool(false);
    RxBool stateC = RxBool(false);
    RxBool activeC = RxBool(false);
    RxBool phoneNoC = RxBool(false);

    Rxn<AccountTypeModel> accountName = Rxn<AccountTypeModel>();

    TextEditingController ledgerNameController = TextEditingController();
    TextEditingController agentController = TextEditingController();
    TextEditingController areaController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController ledgerroleController =
        TextEditingController(text: 'supplier');
    TextEditingController activeStatusController =
        TextEditingController(text: 'Yes');
    TextEditingController phoneNoController = TextEditingController();

    String? accountId;
    final formKey = GlobalKey<FormState>();
    return GetX<LedgerController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 400,
            height: 800,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: ledgerC.value,
                        onChanged: (value) => ledgerC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        autofocus: true,
                        controller: ledgerNameController,
                        hintText: 'Ledger Name',
                        validate: ledgerC.value ? 'string' : '',
                        onChanged: (value) {
                          ledgerC.value = ledgerNameController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: agentC.value,
                        onChanged: (value) => agentC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: agentController,
                        hintText: 'Agent Name',
                        validate: agentC.value ? 'string' : '',
                        onChanged: (value) {
                          agentC.value = agentController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: ledgerRoleC.value,
                        onChanged: (value) => ledgerRoleC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        hintText: 'Ledger Role',
                        controller: ledgerroleController,
                        items: const [
                          'supplier',
                          'customer',
                          'warper',
                          'weaver',
                          'dyer',
                          'employee',
                          'roller',
                          'processor',
                          'job_worker',
                          'winder'
                        ],
                        onChanged: (items) {
                          ledgerroleController.text = items;
                          ledgerRoleC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: accountC.value,
                        onChanged: (value) => accountC.value = value!,
                      ),
                      subtitle: MyAutoComplete(
                        autofocus: false,
                        label: 'Account Type',
                        items: controller.accountGroup,
                        isValidate: accountC.value,
                        selectedItem: accountName.value,
                        onChanged: (AccountTypeModel item) {
                          accountName.value = item;
                          accountId = item.name;
                          accountC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: areaC.value,
                        onChanged: (value) => areaC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: areaController,
                        hintText: 'Area',
                        validate: areaC.value ? 'string' : '',
                        onChanged: (value) {
                          areaC.value = areaController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: cityC.value,
                        onChanged: (value) => cityC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: cityController,
                        hintText: 'City',
                        validate: cityC.value ? 'string' : '',
                        onChanged: (value) {
                          cityC.value = cityController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: stateC.value,
                        onChanged: (value) => stateC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: stateController,
                        hintText: 'State',
                        validate: stateC.value ? 'string' : '',
                        onChanged: (value) {
                          stateC.value = stateController.text.isNotEmpty;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: activeC.value,
                        onChanged: (value) => activeC.value = value!,
                      ),
                      subtitle: MyDropdownButtonFormField(
                        controller: activeStatusController,
                        hintText: 'Is Active',
                        items: const ['Yes', 'No'],
                        onChanged: (items) {
                          activeStatusController.text = items;
                          activeC.value = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 325,
                    child: ListTile(
                      leading: Checkbox(
                        value: phoneNoC.value,
                        onChanged: (value) => phoneNoC.value = value!,
                      ),
                      subtitle: MyFilterTextField(
                        controller: phoneNoController,
                        hintText: 'Phone No',
                        validate: phoneNoC.value ? 'number' : '',
                        onChanged: (value) {
                          phoneNoC.value = phoneNoController.text.isNotEmpty;
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
              if (!formKey.currentState!.validate()) {
                return;
              }
              controller.filterData = {};
              var request = {};

              if (ledgerC.value == true) {
                request['ledger_name'] = ledgerNameController.text;
              }
              if (agentC.value == true) {
                request['agent_name'] = agentController.text;
              }
              if (ledgerRoleC.value == true) {
                request['ledger_role'] = ledgerroleController.text;
              }
              if (accountC.value == true) {
                request['accout_type'] = accountId;
              }
              if (areaC.value == true) {
                request['area'] = areaController.text;
              }
              if (cityC.value == true) {
                request['city'] = cityController.text;
              }
              if (stateC.value == true) {
                request['state'] = stateController.text;
              }
              if (activeC.value == true) {
                request['is_active'] = activeStatusController.text;
              }
              if (phoneNoC.value == true) {
                request['mobile_no'] = phoneNoController.text;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
