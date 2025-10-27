import 'dart:convert';

import 'package:abtxt/flutter_core_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:get/get.dart';

import '../../../model/app_history/AppHistoryModel.dart';

class AppHistoryFullDetails extends StatefulWidget {
  const AppHistoryFullDetails({super.key});

  static const String routeName = '/app_history_full_details';

  @override
  State<AppHistoryFullDetails> createState() => _AppHistoryFullDetailsState();
}

class _AppHistoryFullDetailsState extends State<AppHistoryFullDetails> {
  AppHistoryModel jsonData = AppHistoryModel();

  @override
  void initState() {
    jsonData = Get.arguments["item"] ?? AppHistoryModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CoreWidget(
      loadingStatus: false,
      appBar: AppBar(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
            child: JsonViewer(jsonDecode(jsonData.details ?? ""))),
      ),
    );
  }
}
