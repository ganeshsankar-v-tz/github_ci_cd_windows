import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/saree_checker/SareeCheckerModel.dart';
import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyDateFilter.dart';
import 'saree_checker_report_controller.dart';

class SareeCheckerReport extends StatefulWidget {
  const SareeCheckerReport({super.key});

  @override
  State<SareeCheckerReport> createState() => _SareeCheckerReportState();
}

class _SareeCheckerReportState extends State<SareeCheckerReport> {
  SareeCheckerReportController controller =
      Get.put(SareeCheckerReportController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool sareeCheckerCC = RxBool(false);
    Rxn<SareeCheckerModel> sareeCheckerC = Rxn<SareeCheckerModel>();

    int? sareeCheckerCId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController sareeCheckerController = TextEditingController();
    TextEditingController formatController =
        TextEditingController(text: "Excel");

    FocusNode sareeCheckerFocusNode = FocusNode();
    FocusNode submitFocusNode = FocusNode();

    return GetBuilder<SareeCheckerReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Saree Checker Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return SizedBox(
                      child: ListTile(
                        leading: Checkbox(
                          value: dateC.value,
                          onChanged: (value) => dateC.value = value!,
                        ),
                        subtitle: Row(
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
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  Obx(
                    () => SizedBox(
                      width: 325,
                      child: ListTile(
                        leading: Checkbox(
                          value: sareeCheckerCC.value,
                          onChanged: (value) => sareeCheckerCC.value = value!,
                        ),
                        subtitle: MySearchField(
                          focusNode: sareeCheckerFocusNode,
                          requestFocus: submitFocusNode,
                          textController: sareeCheckerController,
                          label: 'Saree Checker',
                          items: controller.sareeCheckerDetails,
                          isValidate: sareeCheckerCC.value,
                          onChanged: (SareeCheckerModel item) {
                            sareeCheckerC.value = item;
                            sareeCheckerCId = item.id;
                            sareeCheckerCC.value = true;
                          },
                        ),
                      ),
                    ),
                  ),
                  /*Row(
                    children: [
                      const SizedBox(width: 60),
                      MyDropdownButtonFormField(
                        controller: formatController,
                        hintText: 'Format',
                        items: const [
                          'Pdf',
                          'Excel',
                        ],
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
              focusNode: submitFocusNode,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  var request = {};

                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;

                  if (sareeCheckerCC.value == true) {
                    request['saree_checker_id'] = sareeCheckerCId;
                  }

                  request["report_type"] = formatController.text;

                  String? response =
                      await controller.sareeCheckerReport(request: request);
                  if (response != null) {
                    final Uri url = Uri.parse(response);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $response');
                    }
                  }
                },
                child: const Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
