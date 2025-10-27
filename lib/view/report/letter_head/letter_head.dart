import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyLetterPadeTextField.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/FirmModel.dart';
import '../../../utils/app_utils.dart';
import 'letter_head_controller.dart';

class LetterHead extends StatefulWidget {
  const LetterHead({super.key});

  static const String routeName = '/letter_head';

  @override
  State<LetterHead> createState() => _LetterHeadState();
}

class _LetterHeadState extends State<LetterHead> {
  LetterHeadController controller = Get.put(LetterHeadController());
  TextEditingController dateController = TextEditingController();
  TextEditingController firmTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();

  final firmFocusNode = FocusNode();
  final contentFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  Rxn<FirmModel> firmName = Rxn<FirmModel>();

  @override
  void initState() {
    super.initState();
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LetterHeadController>(builder: (controller) {
      return CoreWidget(
        loadingStatus: controller.status.isLoading,
        backgroundColor: Colors.transparent,
        child: AlertDialog(
          title: const Text('Letter Pade'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 480,
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyDateFilter(
                          controller: dateController,
                          labelText: "Date",
                        ),
                        MySearchField(
                          label: 'Firm Name',
                          focusNode: firmFocusNode,
                          requestFocus: contentFocusNode,
                          textController: firmTextController,
                          items: controller.firmName,
                          onChanged: (FirmModel item) {
                            firmName.value = item;
                          },
                        ),
                      ],
                    ),
                    MyLetterPadeTextField(
                      focusNode: contentFocusNode,
                      controller: contentTextController,
                      hintText: "Content",
                      width: double.infinity,
                      validate: "string",
                      macLines: 9,
                    )
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

                  var request = {
                    "date": dateController.text,
                    "firm_id": firmName.value?.id,
                    "context": contentTextController.text,
                  };

                  controller.letterPadeUpdate(request);
                },
                child: const Text('SUBMIT'))
          ],
        ),
      );
    });
  }
}
