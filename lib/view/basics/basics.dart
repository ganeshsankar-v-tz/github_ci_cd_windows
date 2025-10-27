import 'package:abtxt/view/basics/Cops_Reel/cops_reel.dart';
import 'package:abtxt/view/basics/Product_Job_Work/Product_Job_work.dart';
import 'package:abtxt/view/basics/account/account.dart';
import 'package:abtxt/view/basics/color_matching_list/color_matching_list.dart';
import 'package:abtxt/view/basics/costing_entry_list/costing_entry_list.dart';
import 'package:abtxt/view/basics/dyer_order_opening_balance/dyer_order_opening_balance.dart';
import 'package:abtxt/view/basics/dyer_warp_opening_balance/dyer_warp_opening_balance.dart';
import 'package:abtxt/view/basics/dyer_yarn_opening_balance/dyer_yarn_opening_balance.dart';
import 'package:abtxt/view/basics/empty_beam/empty_beam.dart';
import 'package:abtxt/view/basics/firm/firms.dart';
import 'package:abtxt/view/basics/job_work_product_opening_balance/job_work_product_opening_balance.dart';
import 'package:abtxt/view/basics/ledger/ledgers.dart';
import 'package:abtxt/view/basics/ledger_opening_balance/ledger_opening_balance.dart';
import 'package:abtxt/view/basics/new_unit/new_unit.dart';
import 'package:abtxt/view/basics/process_product_opening_balance/process_product_opening_balance.dart';
import 'package:abtxt/view/basics/product_group/product_group.dart';
import 'package:abtxt/view/basics/product_opening_stock/product-opening-stock.dart';
import 'package:abtxt/view/basics/product_weft_requirements/product_weft_requirements.dart';
import 'package:abtxt/view/basics/productinfo/product_info.dart';
import 'package:abtxt/view/basics/roller_warp_opening_balance/roller_warp_opening_balance.dart';
import 'package:abtxt/view/basics/warp_group/warp_group.dart';
import 'package:abtxt/view/basics/warp_opening_stock/warp_opening_stock.dart';
import 'package:abtxt/view/basics/warp_supplier_single_yarn_rate.dart/warp_supplier_single_yarn_rate.dart';
import 'package:abtxt/view/basics/warp_yarn_opening_balance/warp_yarn_opening_balance.dart';
import 'package:abtxt/view/basics/warping_design_charges_config/warping_design_charges_config.dart';
import 'package:abtxt/view/basics/warping_wages_config_list/warping_wages_config.dart';
import 'package:abtxt/view/basics/winding_yarn_conversation/winding_yarn_conversation.dart';
import 'package:abtxt/view/basics/winding_yarn_opening_balance/winding_yarn_opening_balance.dart';
import 'package:abtxt/view/basics/yarn/yarns.dart';
import 'package:abtxt/view/basics/yarn_opening_stock/yarn_opening_stock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'basics_controller.dart';
import 'costing_change_list/costing_change_list.dart';
import 'empty_opening_stock/empty_opening_stock.dart';
import 'new_color/new_color.dart';
import 'new_wrap/new_warp.dart';

class Basics extends StatefulWidget {
  const Basics({Key? key}) : super(key: key);

  @override
  State<Basics> createState() => _State();
}

class _State extends State<Basics> {
  BasicController controller = Get.put(BasicController());
  @override
  void initState() {
    controller.searchFilter("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        appBar: AppBar(
          title: TextField(
            onChanged: (search) => controller.searchFilter(search),
            decoration: InputDecoration(
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
      case 'Firm':
        Get.toNamed(Firms.routeName);
        break;
      //2
      case 'Account':
        Get.toNamed(Account.routeName);
        break;
      //3
      case 'Ledger':
        Get.toNamed(Ledgers.routeName);
        break;
      //4
      case 'New Colour':
        Get.toNamed(NewColor.routeName);
        break;
      //5
      case 'New Unit':
        Get.toNamed(NewUnit.routeName);
        break;
      //6
      case 'Cops-Reel':
        Get.toNamed(CopsReel.routeName);
        break;
      //7
      case 'New Yarn':
        Get.toNamed(Yarns.routeName);
        break;
      //8
      case 'Winding Yarn Conversions':
        Get.toNamed(WindingYarnConversation.routeName);
        break;
      case 'Warp Design Sheet':
        Get.snackbar("Alert", "Working in progress");
        // Get.toNamed(WarpDesignSheet.routeName);
        break;
      //10
      case 'Warp Group':
        Get.toNamed(WarpGroup.routeName);
        break;
      //11
      case 'New Warp':
        Get.toNamed(NewWarp.routeName);
        break;
      //12
      case 'Warping Wages Config':
        Get.toNamed(WarpingWagesConfig.routeName);
        break;
      //13_1
      case 'Warping Design Charges Config':
        Get.toNamed(WarpingDesignChargesConfig.routeName);
        break;
//warping_design_charges_config.png
      //13
      case 'Warp Supplier Single yarn Rate':
        Get.toNamed(WarpSupplierSingleYarnRate.routeName);
        break;
      //14
      case 'Product Group':
        Get.toNamed(ProductGroup.routeName);
        break;
      //15
      case 'Product Info':
        Get.toNamed(ProductInfo.routeName);
        break;
      //16
      case 'Product Image':
        Get.snackbar("Alert", "Working in progress");
        // Get.toNamed(ProductImageList.routeName);
        break;
      //17
      case 'Product Weft Requirement':
        Get.toNamed(ProductWeftRequirements.routeName);
        break;
      //18
      case 'Product Job Work':
        Get.toNamed(ProductJobWorkBasics.routeName);
        break;
      //19
      case 'Color Matching':
        Get.toNamed(ColorMatchingList.routeName);
        break;
      //20
      case 'Costing Entry':
        Get.toNamed(CostingEntryList.routeName);
        break;
      //21
      case 'Costing Change':
        // Get.snackbar("Alert", "Working in progress");
        Get.toNamed(CostingChangeList.routeName);
        break;
      //22
      case 'Yarn Opening Stock':
        Get.toNamed(YarnOpeningStock.routeName);
        break;
      //23
      case 'Warp Opening Stock':
        Get.toNamed(WarpOpeningStock.routeName);
        break;
      //24
      case 'Product Opening Stock':
        Get.toNamed(ProductOpeningBalance.routeName);
        break;
      //25
      case 'Empty Opening Stock':
        Get.toNamed(EmptyOpeningStock.routeName);
        break;
      //26
      case 'Ledger Opening Balance':
        Get.toNamed(LedgerOpeningBalance.routeName);
        break;
      //27
      case 'Opening Closing Stock Value':
        Get.snackbar("Alert", "Working in progress");
        // Get.toNamed(OpeningClosingStockValue.routeName);
        break;
      //28
      case 'Dyer Order Opening Balance':
        Get.toNamed(DyerOrderOpeningBalance.routeName);
        break;
      //29
      case 'Dyer Yarn Opening Balance':
        Get.toNamed(DyerYarnOpeningBalance.routeName);
        break;
      //30
      case 'Dyer Warp Opening Balance':
        Get.toNamed(DyerWarpOpeningBalance.routeName);
        break;
      //31
      case 'Warp Yarn Opening Balance':
        Get.toNamed(WarpYarnOpeningBalance.routeName);
        break;
      //32
      case 'Roller Warp Opening Balance':
        Get.toNamed(RollerWarpOpeningBalance.routeName);
        break;
      //33
      case 'Winding Yarn Opening Balance':
        Get.toNamed(WindingYarnOpeningBalance.routeName);
        break;
      //34
      case 'Empty Beam':
        Get.toNamed(empty_beam.routeName);
        break;
      //35
      case 'Process Product Opening Balance':
        Get.toNamed(ProcessProductOpeningBalance.routeName);
        break;
      //36
      case 'Job Work Product Opening Balance':
        Get.toNamed(JobWorkProductOpeningBalance.routeName);
        break;
    }
  }
}
