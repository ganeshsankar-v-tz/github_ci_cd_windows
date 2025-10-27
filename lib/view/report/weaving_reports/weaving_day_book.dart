import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/FirmModel.dart';
import 'package:abtxt/view/report/weaving_reports/weaving_reports_controller.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/LedgerModel.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyFilterTextField.dart';

class WeavingDayBook extends StatefulWidget {
  const WeavingDayBook({super.key});

  @override
  State<WeavingDayBook> createState() => _WeavingDayBookState();
}

class _WeavingDayBookState extends State<WeavingDayBook> {
  WeavingReportController controller = Get.put(WeavingReportController());

  RxList entryTypes = <dynamic>[
    {'entry_type': "Warp Delivery", 'active': false},
    {'entry_type': "Yarn Delivery", 'active': false},
    {'entry_type': "Goods Inward", 'active': false},
    {'entry_type': "Payment", 'active': false},
    {'entry_type': "Empty - (In / Out)", 'active': false},
    {'entry_type': "Receipt", 'active': false},
    {'entry_type': "Rtrn-Yarn", 'active': false},
    {'entry_type': "Credit", 'active': false},
    {'entry_type': "Debit", 'active': false},
    {'entry_type': "Yarn Wastage", 'active': false},
    {'entry_type': "Warp Excess", 'active': false},
    {'entry_type': "Message", 'active': false},
    {'entry_type': "Warp Shortage", 'active': false},
    {'entry_type': "Trsfr - Amount", 'active': false},
    {'entry_type': "Trsfr - Cops,Reel", 'active': false},
    {'entry_type': "Trsfr - Empty", 'active': false},
    {'entry_type': "Trsfr - Warp", 'active': false},
    {'entry_type': "Trsfr - Yarn", 'active': false},
    {'entry_type': "Adjustment Wt", 'active': false},
    {'entry_type': "Warp-Dropout", 'active': false},
    {'entry_type': "O.Bal - Amount", 'active': false},
    {'entry_type': "O.Bal - Cops,Reel", 'active': false},
    {'entry_type': "O.Bal - Warp", 'active': false},
    {'entry_type': "O.Bal - Yarn", 'active': false},
    {'entry_type': "Inward - Cops, Reel", 'active': false},
    {'entry_type': "O.Bal - Empty", 'active': false},
  ].obs;

  @override
  Widget build(BuildContext context) {
    RxBool dateC = RxBool(true);
    RxBool weaverC = RxBool(false);
    RxBool firmC = RxBool(false);
    RxBool loomC = RxBool(false);

    Rxn<LedgerModel> weaverName = Rxn<LedgerModel>();
    Rxn<FirmModel> firmName = Rxn<FirmModel>();
    TextEditingController loomController = TextEditingController();
    TextEditingController formatController = TextEditingController(text: "PDF");
    var submitFocus = FocusNode();

    int? firmId;
    int? weaverId;

    var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TextEditingController fromDateController =
        TextEditingController(text: today);
    TextEditingController toDateController = TextEditingController(text: today);

    final formKey = GlobalKey<FormState>();
    return GetBuilder<WeavingReportController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Weaving...Day Book'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 800,
              height: 600,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: ExcludeFocusTraversal(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Entry Types',
                              style: TextStyle(color: Colors.red),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                              ),
                              height: 570,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: entryTypes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = entryTypes[index];
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(item['entry_type']),
                                    value: item['active'],
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (bool? value) {
                                      entryTypes[index]['active'] = value;
                                      controller.change(entryTypes);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => ListTile(
                              leading: Checkbox(
                                value: dateC.value,
                                onChanged: (value) {
                                  dateC.value = value!;
                                },
                              ),
                              subtitle: Wrap(
                                children: [
                                  Row(
                                    children: [
                                      MyDateFilter(
                                        controller: fromDateController,
                                        labelText: "From Date",
                                        required: dateC.value,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
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
                          ),
                          Obx(
                            () => SizedBox(
                              width: 325,
                              child: ListTile(
                                leading: Checkbox(
                                  value: weaverC.value,
                                  onChanged: (value) => weaverC.value = value!,
                                ),
                                subtitle: MyAutoComplete(
                                  label: 'Weaver Name',
                                  items: controller.ledgerlistweavers,
                                  selectedItem: weaverName.value,
                                  isValidate: weaverC.value,
                                  onChanged: (LedgerModel item) {
                                    weaverName.value = item;
                                    weaverId = item.id;
                                    weaverC.value = true;
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
                                  value: firmC.value,
                                  onChanged: (value) => firmC.value = value!,
                                ),
                                subtitle: MyAutoComplete(
                                  label: 'Firm',
                                  items: controller.firmDropdown,
                                  selectedItem: firmName.value,
                                  isValidate: firmC.value,
                                  onChanged: (FirmModel item) {
                                    firmName.value = item;
                                    firmId = item.id;
                                    firmC.value = true;
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
                                    value: loomC.value,
                                    onChanged: (value) => loomC.value = value!,
                                  ),
                                  subtitle: MyFilterTextField(
                                    controller: loomController,
                                    hintText: 'Loom',
                                    onChanged: (value) {
                                      loomC.value =
                                          loomController.text.isNotEmpty;
                                    },
                                  )),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 60),
                              MyDropdownButtonFormField(
                                controller: formatController,
                                hintText: 'Format',
                                items: const [
                                  'PDF',
                                  'Excel',
                                ],
                                onChanged: (value) {},
                              ),
                            ],
                          )
                        ],
                      ),
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
              focusNode: submitFocus,
              child: const Text('SUBMIT'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {}
                var request = {};
                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }
                if (weaverC.value == true) {
                  request['weaver_id'] = weaverId;
                }
                if (firmC.value == true) {
                  request['firm_id'] = firmId;
                }
                if (loomC.value == true) {
                  request['sub_weaver_no'] = loomController.text;
                }

                var selectedEntryTypes = entryTypes
                    .where((e) => e['active'] == true)
                    .map((e) => e["entry_type"])
                    .toList();

                if (selectedEntryTypes.isEmpty) {
                  return AppUtils.infoAlert(
                      message: "You should select minimum One Entry Type !");
                }

                for (int i = 0; i < selectedEntryTypes.length; i++) {
                  request['entry_type[$i]'] = "${selectedEntryTypes[i]}";
                }

                request["format"] = formatController.text.toLowerCase();

                String? response =
                    await controller.WeavingDayBookReport(request: request);
                if (response!.isNotEmpty) {
                  final Uri url = Uri.parse(response);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $response');
                  }
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
