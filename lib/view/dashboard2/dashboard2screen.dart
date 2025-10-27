import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/http/http_urls.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/ledger/ledgers.dart';
import 'package:abtxt/view/basics/productinfo/product_info.dart';
import 'package:abtxt/view/basics/yarn/yarns.dart';
import 'package:abtxt/view/production/empty_in_out/empty_in_out_list.dart';
import 'package:abtxt/view/production/goods_inward_slip/goods_inward_slip_screen.dart';
import 'package:abtxt/view/production/warp_tracking/warp_tracking.dart';
import 'package:abtxt/view/production/weaving/add_weaving.dart';
import 'package:abtxt/view/report/warp_reports/warp_search_report.dart';
import 'package:abtxt/view/trasaction/jari_twisting_yarn_inward/jari_twisting_yarn_inward_screen.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_list.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_list.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_list.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_warper_list/yarn_delivery_to_warper.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../production/warp_or_yarn_delivery/warp_or_yarn_delivery_screen.dart';
import 'dashboard2_controller.dart';

class DashBoard2 extends StatefulWidget {
  const DashBoard2({Key? key}) : super(key: key);

  @override
  State<DashBoard2> createState() => _State();
}

class _State extends State<DashBoard2> {
  DashBoard2Controller controller = Get.put(DashBoard2Controller());
  bool isVisible = false;
  var box = GetStorage();
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    var userType = box.read("user_type");
    if (userType == "A") {
      isVisible = true;
      controller.weavingProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoard2Controller>(builder: (controller) {
      return CoreWidget(
        backgroundColor: const Color(0xFFF9F3FF),
        loadingStatus: controller.status.isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.builder(
                          itemCount: controller.list.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            crossAxisCount:
                                (MediaQuery.of(context).size.width ~/ 110)
                                    .toInt(),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> map = controller.list[index];
                            var item = map['title'];
                            var icon = map['icon'];
                            var color = map['color'];
                            return InkWell(
                              onTap: () => itemClicked('$item'),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('$icon', height: 35),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$item',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: !isVisible
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isVisible,
                      child: Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Weaving Product Approval',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 80),
                                IconButton(
                                  tooltip: "Refresh",
                                  onPressed: () async {
                                    await controller.weavingProduct();
                                  },
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.purple),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            controller.weavingPendingProductApprovalList
                                    .isNotEmpty
                                ? Expanded(
                                    child: SizedBox(
                                      width: 600,
                                      child: ListView.builder(
                                        itemCount: controller
                                            .weavingPendingProductApprovalList
                                            .length,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var item = controller
                                                  .weavingPendingProductApprovalList[
                                              index];
                                          int weavingId = item.id ?? 0;
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: ShapeDecoration(
                                              color: Colors.white.withAlpha(99),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 0.5,
                                                    color: Color(0xFFE4E4E4)),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      spacing: 2,
                                                      children: [
                                                        Text(
                                                          "Weaver: ${item.weaverName ?? 'N/A'} , Loom: ${item.loomNo ?? 'N/A'}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          item.productName ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Wages: ₹${item.wages ?? 0}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        Text(
                                                          'Created By: ${item.createdByName ?? ""} At: ${item.eDate ?? ""}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),

                                                      ],
                                                    ),
                                                  ),

                                                  // Approve button
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await _submit(weavingId,
                                                          "Approved");
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child:
                                                        const Text("Approve"),
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Reject button
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await _submit(weavingId,
                                                          "Rejected");
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: const Text("Reject"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        'No pending weaving products found!',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Visibility(
                        visible: HttpUrl.baseUrl ==
                            "http://dev-apiabtex.tamilzorous.com/",
                        child: const Text(
                          "Testing Server",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Developed by',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Image.asset(
                            'assets/Dashboard Icons/tz_logo.png',
                            // width: 200.0,
                            height: 20,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Ver: ${AppUtils().appVersion}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async => _showLogoutDialog(context),
                            tooltip: 'Logout',
                            icon: const Icon(
                              Icons.power_settings_new,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '${box.read('name')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${DateTime.now()}',
                            style: const TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _submit(int id, String status) async {
    var request = {
      'status': status,
    };
    await controller.weavingStatusChange(request, id);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Get.back(),
              autofocus: true,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue), // Border color
              ),
              child: const Text(
                'CANCEL',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                var box = GetStorage();
                await box.erase();
                Get.toNamed('/');
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text(
                'LOGOUT',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

itemClicked(String item) {
  switch (item) {
    case 'Ledger':
      Get.toNamed(Ledgers.routeName);
      break;
    case 'Goods Inward Slip':
      Get.toNamed(GoodsInwardSlipScreen.routeName);
      break;
    case 'Warp or Yarn Delivery Slip':
      Get.toNamed(WarpOrYarnDeliveryProduction.routeName);
      break;
    case 'Empty in - Out':
      Get.toNamed(EmptyInOutList.routeName);
      break;
    case 'Weaving':
      Get.toNamed(AddWeaving.routeName);
      break;
    case 'Payment':
      Get.toNamed(PaymentV2.routeName);
      break;
    case 'Warp Delivery To Roller':
      Get.toNamed(WarpDeliveryToRoller.routeName);
      break;
    case 'Warp Inward From Roller':
      Get.toNamed(WarpInwardFromRoller.routeName);
      break;
    case 'Warp Delivery To Dyer':
      Get.toNamed(WarpDeliveryToDyer.routeName);
      break;
    case 'Warp Inward From Dyer':
      Get.toNamed(WarpInwardFromDyer.routeName);
      break;

    case 'New Yarn':
      Get.toNamed(Yarns.routeName);
      break;
    case 'Product Info':
      Get.toNamed(ProductInfo.routeName);
      break;
    case 'Yarn Purchase':
      Get.toNamed(YarnPurchase.routeName);
      break;
    case 'Yarn Delivery To Warper':
      Get.toNamed(YarnDeliveryToWarper.routeName);
      break;
    case 'Jari Twisting - Yarn Inward':
      Get.toNamed(JariTwistingYarnInward.routeName);
      break;
    case 'Warp Inward':
      Get.toNamed(WarpInward.routeName);
      break;
    case 'Product Sale':
      Get.toNamed(ProductSale.routeName);
      break;
    case 'Product Jobwork Delivery':
      Get.toNamed(ProductDeliverToJobWorker.routeName);
      break;
    case 'Product Jobwork Inward':
      Get.toNamed(ProductInwardFromJobWorker.routeName);
      break;
    case 'Warp Search':
      Get.toNamed(WarpSearchReport.routeName);
      break;
    case 'Warp Tracking':
      Get.toNamed(WarpTrackingList.routeName);
      break;
  }
}
