import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/MachineDetailsModel.dart';
import '../../../widgets/MyDateFilter.dart';
import '../../../widgets/my_search_field/my_search_field.dart';
import 'jari_twisting_yarn_inward_controller_v2.dart';

class JariTwistingYarnInwardV2Filter extends StatefulWidget {
  const JariTwistingYarnInwardV2Filter({super.key});

  @override
  State<JariTwistingYarnInwardV2Filter> createState() =>
      _JariTwistingYarnInwardV2FilterState();
}

class _JariTwistingYarnInwardV2FilterState
    extends State<JariTwistingYarnInwardV2Filter> {
  Rxn<MachineDetailsModel> machineNameController = Rxn<MachineDetailsModel>();
  TextEditingController machineNameTextController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  RxBool dateC = RxBool(true);
  RxBool machineC = RxBool(false);

  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final FocusNode _machineFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();

  @override
  void initState() {
    fromDateController.text = today;
    toDateController.text = today;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return GetX<JariTwistingYarnInwardControllerV2>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 240,
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
                              autofocus: true,
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
                        value: machineC.value,
                        onChanged: (value) => machineC.value = value!,
                      ),
                      subtitle: MySearchField(
                        label: "Machine Name",
                        items: controller.machineDetails,
                        textController: machineNameTextController,
                        isValidate: machineC.value,
                        focusNode: _machineFocusNode,
                        requestFocus: _submitFocusNode,
                        onChanged: (MachineDetailsModel item) {
                          machineNameController.value = item;
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
            focusNode: _submitFocusNode,
            child: const Text('APPLY'),
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                return;
              }
              var request = {};
              if (dateC.value == true) {
                request['from_date'] = fromDateController.text;
                request['to_date'] = toDateController.text;
              }

              if (machineC.value == true) {
                request['machine_id'] = machineNameController.value?.id;
              }
              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
