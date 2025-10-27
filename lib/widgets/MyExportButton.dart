import 'package:abtxt/view/report/report_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyExportButton extends StatelessWidget {
  final Function(String)? onSelected;

  const MyExportButton({
    Key? key,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        Get.toNamed(ReportDownload.routeName, arguments: {"item": 'account'});
        //onSelected(value);
      },
      itemBuilder: (BuildContext bc) {
        return const [
          PopupMenuItem(
            child: Text("Excel"),
            value: 'excel',
          ),
        ];
      },
    );
  }
}
