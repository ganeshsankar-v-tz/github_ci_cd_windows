import 'package:abtxt/model/administrator/AdministratorModel.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/MyDateFilter.dart';
import 'app_history_controller.dart';

class AppHistoryFilter extends StatefulWidget {
  const AppHistoryFilter({super.key});

  @override
  State<AppHistoryFilter> createState() => _AppHistoryFilterState();
}

class _AppHistoryFilterState extends State<AppHistoryFilter> {
  RxBool dateC = RxBool(true);
  RxBool userNaneC = RxBool(false);

  Rxn<AdministratorModel> userNameController = Rxn<AdministratorModel>();

  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController userNaneTextController = TextEditingController();

  final FocusNode _userFocusNode = FocusNode();
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
    return GetX<AppHistoryController>(builder: (controller) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: 570,
            height: 200,
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
                        value: userNaneC.value,
                        onChanged: (value) => userNaneC.value = value!,
                      ),
                      subtitle: MySearchField(
                        label: 'User Name',
                        textController: userNaneTextController,
                        focusNode: _userFocusNode,
                        requestFocus: _submitFocusNode,
                        items: controller.userName,
                        enabled: userNaneC.value,
                        isValidate: userNaneC.value,
                        onChanged: (AdministratorModel item) {
                          userNameController.value = item;
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
              if (userNaneC.value == true) {
                request["user_id"] = userNameController.value?.id;
              }

              Get.back(result: controller.filterData = request);
            },
          ),
        ],
      );
    });
  }
}
