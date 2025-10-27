import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarpTrackingHistoryController extends GetxController with StateMixin {
  late TabController tabController;

  @override
  void onInit() async {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  moveNext() {
    tabController.animateTo((tabController.index + 1));
  }
}
