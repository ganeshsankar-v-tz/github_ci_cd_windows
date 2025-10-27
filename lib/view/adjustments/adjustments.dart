import 'package:abtxt/view/adjustments/product_integration/product_integration_list.dart';
import 'package:abtxt/view/adjustments/product_stock_adjustment/product_stock_list.dart';
import 'package:abtxt/view/adjustments/split_warp/split_list.dart';
import 'package:abtxt/view/adjustments/warp_merging/warp_merging_list.dart';
import 'package:abtxt/view/adjustments/yarn_stock_adjustment/yarn_stock_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'adjustment_controller.dart';
import 'alternative_warp_design/alternative_warp_design_list.dart';
import 'color_matching/color_matching.dart';

class Adjustments extends StatefulWidget {
  const Adjustments({Key? key}) : super(key: key);

  @override
  State<Adjustments> createState() => _State();
}

class _State extends State<Adjustments> {
  AdjustmentController controller = Get.put(AdjustmentController());
  @override
  void initState() {
    controller.searchFilter("");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdjustmentController>(builder: (controller) {
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
      case 'Yarn Stock':
        Get.toNamed(YarnStock.routeName);
        break;
      case 'Product Stock':
        Get.toNamed(ProductStock.routeName);
        break;
      case 'Product Integration':
        Get.toNamed(ProductIntegration.routeName);
        break;
      case 'Alternative Warp Design':
        Get.toNamed(AltWarpDesign.routeName);
        break;
      case 'Warp Merging':
        Get.toNamed(WarpMerging.routeName);
        break;
      case 'Split Warp':
        Get.toNamed(SplitList.routeName);
        break;
      case 'Color Matching':
        // Get.toNamed(ColorMatching.routeName);
        Get.snackbar("Alert", "Working in progress");
        break;
    }
  }
}
