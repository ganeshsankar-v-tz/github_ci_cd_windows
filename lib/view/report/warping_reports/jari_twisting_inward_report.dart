import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/report/warping_reports/warping_reports_controller.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/JariTwistingModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../widgets/MyDateFilter.dart';

class JariTwistingInwardReport extends StatefulWidget {
  const JariTwistingInwardReport({super.key});

  @override
  State<JariTwistingInwardReport> createState() =>
      _JariTwistingInwardReportState();
}

class _JariTwistingInwardReportState extends State<JariTwistingInwardReport> {
  RxBool dateC = RxBool(true);
  RxBool yarnC = RxBool(false);
  RxBool warperC = RxBool(false);

  Rxn<LedgerModel> warper = Rxn<LedgerModel>();
  Rxn<JariTwistingModel> yarnName = Rxn<JariTwistingModel>();

  WarpingReportsController controller = Get.put(WarpingReportsController());

  var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController yarnNameController = TextEditingController();
  TextEditingController warperNameController = TextEditingController();

  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _warperNameFocusNode = FocusNode();
  final FocusNode _warperCheckBoxFocusNode = FocusNode();
  final FocusNode _submitButtonFocusNode = FocusNode();

  int? yarnId;
  int? warperId;

  @override
  void initState() {
    toDateController.text = today;
    fromDateController.text = today;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return GetBuilder<WarpingReportsController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Jari Twisting Inward Report'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 570,
              height: 270,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListTile(
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
                    ),
                    Obx(
                      () => SizedBox(
                        width: 325,
                        child: ListTile(
                          leading: Checkbox(
                            value: yarnC.value,
                            onChanged: (value) => yarnC.value = value!,
                          ),
                          subtitle: MySearchField(
                            label: 'Yarn',
                            items: controller.twistingYarns,
                            isValidate: yarnC.value,
                            textController: yarnNameController,
                            focusNode: _yarnNameFocusNode,
                            requestFocus: _warperCheckBoxFocusNode,
                            onChanged: (JariTwistingModel item) {
                              yarnId = item.yarnId;
                              yarnName.value = item;
                              yarnC.value = true;
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
                            focusNode: _warperCheckBoxFocusNode,
                            value: warperC.value,
                            onChanged: (value) => warperC.value = value!,
                          ),
                          subtitle: MySearchField(
                            label: 'Warper',
                            items: controller.warperName,
                            textController: warperNameController,
                            focusNode: _warperNameFocusNode,
                            requestFocus: _submitButtonFocusNode,
                            isValidate: warperC.value,
                            onChanged: (LedgerModel item) {
                              warperId = item.id;
                              warper.value = item;
                              warperC.value = true;
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
                onPressed: () => Get.back(), child: const Text('CANCEL')),
            TextButton(
              focusNode: _submitButtonFocusNode,
              child: const Text('SUBMIT'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                var request = {};
                if (dateC.value == true) {
                  request['from_date'] = fromDateController.text;
                  request['to_date'] = toDateController.text;
                }
                if (yarnC.value == true) {
                  request['yarn_id'] = yarnId;
                }
                if (warperC.value == true) {
                  request['warper_id'] = warperId;
                }

                String? response =
                    await controller.jariTwistingInwardReport(request: request);
                if (response != null) {
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
