import 'package:abtxt/view/report/report_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_utils.dart';
import '../../widgets/MyDateField.dart';

class ReportDownload extends StatefulWidget {
  const ReportDownload({super.key});

  static const String routeName = '/report_downloader';

  @override
  State<ReportDownload> createState() => _ReportDownloadState();
}

class _ReportDownloadState extends State<ReportDownload> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var item = "".obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      item.value = Get.arguments['item'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        appBar: AppBar(title: Text('Download Report / $item')),
        body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(16),
            height: 200,
            width: Get.width / 2,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyDateField(
                      controller: fromDateController,
                      hintText: "From",
                      validate: "string",
                      lastDate: 0,
                    ),
                    MyDateField(
                      controller: toDateController,
                      hintText: "To",
                      validate: "string",
                      lastDate: 0,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                MyElevatedButton(
                  onPressed: () => submit(),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      var from = fromDateController.text;
      var to = toDateController.text;
      var url =
          'http://apiabtex.tamilzorous.com/api/export_user_data?from_date=$from&to_date=$to';
      _launchUrl(url);
    }
  }

  Future<void> _launchUrl(String _url) async {
    var url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      AppUtils.showErrorToast(message: 'Could not launch $url');
    }
  }
}
