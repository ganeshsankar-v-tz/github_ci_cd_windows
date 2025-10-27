import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/WarpDesignModel.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/MyAutoComplete.dart';
import '../../../../widgets/MyDateFilter.dart';
import 'empty_inout_controller.dart';

class EmptyInOutReport extends StatefulWidget {
  const EmptyInOutReport({super.key});

  @override
  State<EmptyInOutReport> createState() => _EmptyInOutReportState();
}

class _EmptyInOutReportState extends State<EmptyInOutReport> {
  EmptyInOutReportController controller = Get.put(EmptyInOutReportController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    RxBool dateC = RxBool(true);
    RxBool warpDesignC = RxBool(false);
    Rxn<WarpDesignModel> warpDesign = Rxn<WarpDesignModel>();

    int? warpDesignId;
    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);
    TextEditingController warpTypeController =
        TextEditingController(text: "Main Warp");
    TextEditingController formatController =
        TextEditingController(text: "Excel");

    return GetBuilder<EmptyInOutReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaver Empty in/out Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 580,
              height: 340,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        MyDateFilter(
                          enabled: dateC.value,
                          controller: fromDateController,
                          labelText: "From Date",
                          required: dateC.value,
                        ),
                        MyDateFilter(
                          enabled: dateC.value,
                          controller: toDateController,
                          labelText: "To Date",
                          required: dateC.value,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 60),
                        MyDropdownButtonFormField(
                          controller: warpTypeController,
                          hintText: "Warp Type",
                          items: const ["Main Warp", "Other"],
                        ),
                      ],
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: warpDesignC.value,
                            onChanged: (value) => warpDesignC.value = value!,
                          ),
                          subtitle: MyAutoComplete(
                            forceNextFocus: true,
                            textInputAction: TextInputAction.next,
                            label: 'Warp Design',
                            items: controller.warpDesignDropdown,
                            selectedItem: warpDesign.value,
                            isValidate: warpDesignC.value,
                            onChanged: (WarpDesignModel item) {
                              warpDesign.value = item;
                              warpDesignId = item.warpDesignId;
                              warpDesignC.value = true;
                            },
                          ),
                        ),
                      ),
                    ),
                    Row(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  var request = {};

                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;

                  if (warpDesignC.value == true) {
                    request['warp_design_id'] = warpDesignId;
                  }

                  request["warp_type"] = warpTypeController.text;

                  request["report_type"] = formatController.text;

                  String? response =
                      await controller.emptyInoutReport(request: request);
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
