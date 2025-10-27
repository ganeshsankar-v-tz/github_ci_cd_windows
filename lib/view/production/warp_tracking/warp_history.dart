import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/production/warp_tracking/warp_tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarpHistory extends StatefulWidget {
  const WarpHistory({super.key});

  static const String routeName = '/warp_history';

  @override
  State<WarpHistory> createState() => _WarpHistoryState();
}

class _WarpHistoryState extends State<WarpHistory> {
  final WarpTrackingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpTrackingController>(
      builder: (controller) {
        return CoreWidget(
            appBar: AppBar(
              title: const Text("Warp History"),
            ),
            loadingStatus: controller.status.isLoading,
            child: FocusScope(
              autofocus: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
                child: Column(
                  children: [],
                ),
              ),
            ));
      },
    );
  }
}
