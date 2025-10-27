import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/view/production/warp_tracking_history/warp_tracking_history_controller.dart';
import 'package:abtxt/widgets/time_line_view/time_line_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/report_models/WarpSearchModel.dart';

class WarpHistory extends StatefulWidget {
  const WarpHistory({super.key});

  static const String routeName = '/warp_history';

  @override
  State<WarpHistory> createState() => _WarpHistoryState();
}

class _WarpHistoryState extends State<WarpHistory>
    with SingleTickerProviderStateMixin {
  final WarpTrackingHistoryController controller =
      Get.put(WarpTrackingHistoryController());
  List<WarpTracking> list = [];
  double radius = 24;

  @override
  void initState() {
    super.initState();
    controller.tabController = TabController(vsync: this, length: 5);
    initValue();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpTrackingHistoryController>(
      builder: (controller) {
        return DefaultTabController(
          length: 5,
          child: CoreWidget(
            appBar: AppBar(
              title: const Text("Warp History"),
            ),
            loadingStatus: controller.status.isLoading,
            child: TimeLineView(jsonData: list),
          ),
        );
      },
    );
  }

  initValue() {
    var json = [
      {
        "entry_type": "Warp Inward",
        "e_date": "2024-10-26",
        "new_warp_id": "ABT1W2410-64",
        "ledger_id": 2723,
        "ledger_name": "TFO WRP   NO 1",
        "warp_design_id": 524,
        "warp_name": "5500+2200 TANA",
        "warp_condition": "UnDyed",
        "old_warp_id": null
      },
      {
        "entry_type": "Dyeing",
        "e_date": "2024-11-09",
        "new_warp_id": "ABDSD2411-28",
        "ledger_id": 2291,
        "ledger_name": "DHANUSHREE DYEING",
        "warp_design_id": 524,
        "warp_name": "5500+2200 TANA",
        "old_warp_id": "ABT1W2410-64"
      },
      {
        "entry_type": "Rolling",
        "e_date": "2024-11-18",
        "new_warp_id": "ABSSMR2411-24",
        "ledger_id": 1465,
        "ledger_name": "Somasundharam Roll",
        "warp_design_id": 524,
        "warp_name": "5500+2200 TANA",
        "old_warp_id": "ABDSD2411-28"
      },
      {
        "entry_type": "Weaving",
        "e_date": "2024-12-24",
        "new_warp_id": null,
        "ledger_id": 1268,
        "ledger_name": "A.Chidhuraj Kottamedu",
        "warp_design_id": 524,
        "warp_name": "5500+2200 TANA",
        "old_warp_id": "ABSSMR2411-24",
        "loom": "2",
        "current_status": "Completed",
        "product_name": "JACKAT KOTTANCHU MS UP 800",
        "roller_name": "Somasundharam Roll"
      }
    ];

    list = json.map((e) => WarpTracking.fromJson(e)).toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
