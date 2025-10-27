import 'package:abtxt/view/trasaction/empty_beam_bobbin_delivery_inward/empty_beam_bobbin_delivery_inward.dart';
import 'package:abtxt/view/trasaction/product_dc_to_customer/product_dc_to_customer.dart';
import 'package:abtxt/view/trasaction/product_order/product_order_list.dart';
import 'package:abtxt/view/trasaction/product_purchase/product_purchase.dart';
import 'package:abtxt/view/trasaction/product_return_from_customer/product_return_from_customer_list.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_list.dart';
import 'package:abtxt/view/trasaction/retail_sale/retail_sale.dart';
import 'package:abtxt/view/trasaction/transaction_controller.dart';
import 'package:abtxt/view/trasaction/transport_copy_list/transport_copy.dart';
import 'package:abtxt/view/trasaction/twisting_or_warping/twisting_or_warping.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_list.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_list.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase.dart';
import 'package:abtxt/view/trasaction/warp_sale/warp_sale_list.dart';
import 'package:abtxt/view/trasaction/warper_yarn_shortage_adjustments/warper_yarn_shortage_adjustments.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_dyer/yarn_delivery_to_dyer_screen.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_warper_list/yarn_delivery_to_warper.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_list.dart';
import 'package:abtxt/view/trasaction/yarn_inward_from_dyer/list_yarn_inward_from_dyer.dart';
import 'package:abtxt/view/trasaction/yarn_inward_from_winder/yarn_inward_from_winder.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_list.dart';
import 'package:abtxt/view/trasaction/yarn_return_from_warper/yarn_return_from_warper.dart';
import 'package:abtxt/view/trasaction/yarn_sales/yarn_sales_list.dart';
import 'package:abtxt/view/trasaction/yarn_stock_report/yarn_stock_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'handloom_certificate/handloom_certificate_list.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _State();
}

class _State extends State<Transaction> {
  TransactionController controller = Get.put(TransactionController());

  @override
  void initState() {
    controller.searchFilter("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            onChanged: (search) => controller.searchFilter(search),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: controller.filterList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount:
                  (MediaQuery.of(context).size.width ~/ 250).toInt(),
            ),
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> map = controller.filterList[index];
              var item = map['title'];
              var icon = map['icon'];
              var color = map['color'];

              return Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),
                child: InkWell(
                  onTap: () => itemClicked('$item'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: ShapeDecoration(
                                color: color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Center(
                              child:
                                  Image.asset(height: 50, width: 50, '$icon'),
                            ),
                          ],
                        ),
                        Text(
                          '$item',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  itemClicked(String item) {
    switch (item) {
      //1
      case 'Yarn Purchase':
        Get.toNamed(YarnPurchase.routeName);
        break;
      //3
      case 'Yarn Sales':
        Get.toNamed(YarnSalesList.routeName);
        break;
      //4
      case 'Yarn Stock Report':
        // Get.snackbar("Alert", "Working in progress");
        Get.toNamed(YarnStockReport.routeName);
        break;
      //6
      case 'Yarn Delivery to Winder':
        Get.toNamed(YarnDeliveryToWinder.routeName);
        break;
      //7
      case 'Yarn Inward from Winder':
        Get.toNamed(YarnInwardFromWinder.routeName);
        break;
      //8
      case 'Yarn Delivery to Dyer':
        Get.toNamed(YarnDeliveryToDyer.routeName);
        break;
      //9
      case 'Yarn Inward from Dyer':
        Get.toNamed(ListYarnInwardFromDyer.routeName);
        break;
      //10
      case 'Warp Delivery to Dyer':
        Get.toNamed(WarpDeliveryToDyer.routeName);
        break;
      //11
      case 'Warp Inward From Dyer':
        Get.toNamed(WarpInwardFromDyer.routeName);
        break;
      //12
      case 'Warp Delivery To Roller':
        Get.toNamed(WarpDeliveryToRoller.routeName);
        break;
      //13
      case 'Warp Inward From Roller':
        Get.toNamed(WarpInwardFromRoller.routeName);
        break;
      //14
      case 'Warp Order':
        Get.snackbar("Alert", "Working in progress");
        // Get.toNamed(WarpOrder.routeName);
        break;
      //15
      case 'Yarn Delivery to Warper':
        Get.toNamed(YarnDeliveryToWarper.routeName);
        break;
      //16
      case 'Yarn Return from Warper':
        Get.toNamed(YarnReturnFromWarper.routeName);
        break;
      //17
      case 'Yarn Shortage Adjustment':
        Get.toNamed(WarperYarnShortageAdjustments.routeName);
        break;
      //18
      case 'Warp Inward':
        Get.toNamed(WarpInward.routeName);
        break;
      //19
      case 'Twisting or Warping':
        // Get.snackbar("Alert", "Working in progress");
        Get.toNamed(TwistingOrWarpingSheet.routeName);
        break;
      //20
      case 'Warp or Yarn Dyeing':
        Get.snackbar("Alert", "Working in progress");
        //Get.toNamed(WarpOrYarnDying.routeName);
        break;
      //21
      case 'Job Work Pure Silk':
        Get.snackbar("Alert", "Working in progress");
        //Get.toNamed(JobWorkList.routeName);
        break;
      //22
      case 'Process Pure Silk':
        Get.snackbar("Alert", "Working in progress");
        //Get.toNamed(ProcessList.routeName);
        break;
      //23
      case 'Product Purchase':
        Get.toNamed(ProductPurchase.routeName);
        break;
      //25 ProductOrderList
      case 'Product Order':
        Get.toNamed(ProductOrderList.routeName);
        break;
      //26
      case 'Product D.C to Customer':
        Get.toNamed(ProductDcToCustomer.routeName);
        break;
      //27
      case 'Product Return from Customer':
        Get.toNamed(ProductReturnFromCustomer.routeName);
        break;
      //28
      case 'Product Sale':
        // Get.snackbar("Alert", "Working in progress");
        Get.toNamed(ProductSale.routeName);
        break;
      //30
      case 'Transport Copy':
        Get.toNamed(TransportCopy.routeName);
        break;
      //31
      case 'Handloom Certificate':
        Get.toNamed(HandLoomList.routeName);
        break;
      //32
      case 'Retail Sales':
        Get.toNamed(RetailSale.routeName);
        break;
      //33
      case 'Warp Purchase':
        Get.toNamed(WarpPurchase.routeName);
        break;
      //34
      case 'Warp Sales':
        Get.toNamed(WarpSaleList.routeName);
        break;

      //35
      case 'Empty (Beam / Bobbin) Delivery / Inward':
        Get.toNamed(EmptyBeamBobbinDeliveryInward.routeName);
        break;

      //36
      // case 'Jari Twisting':
      //   Get.toNamed(JariTwisting.routeName);
      //   break;
    }
  }
}
