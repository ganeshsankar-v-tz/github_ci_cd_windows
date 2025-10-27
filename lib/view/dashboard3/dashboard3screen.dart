import 'package:abtxt/view/basics/jari_twisting/jari_twisting.dart';
import 'package:abtxt/view/basics/ledger/ledgers.dart';
import 'package:abtxt/view/basics/productinfo/product_info.dart';
import 'package:abtxt/view/basics/yarn/yarns.dart';
import 'package:abtxt/view/production/goods_inward_slip/goods_inward_slip_screen.dart';
import 'package:abtxt/view/production/wages_bill/wages_bill_list.dart';
import 'package:abtxt/view/trasaction/payment/payment_list.dart';
import 'package:abtxt/view/trasaction/product_dc_to_customer/product_dc_to_customer.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker.dart';
import 'package:abtxt/view/trasaction/product_purchase/product_purchase.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_list.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_warper_list/yarn_delivery_to_warper.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_list.dart';
import 'package:abtxt/view/trasaction/yarn_sales/yarn_sales_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../adjustments/split_warp/split_list.dart';
import '../adjustments/warp_merging/warp_merging_list.dart';
import '../adjustments/yarn_stock_adjustment/yarn_stock_list.dart';
import '../basics/Cops_Reel/cops_reel.dart';
import '../basics/Product_Job_Work/Product_Job_work.dart';
import '../basics/account/account.dart';
import '../basics/firm/firms.dart';
import '../basics/new_color/new_color.dart';
import '../basics/new_unit/new_unit.dart';
import '../basics/new_wrap/new_warp.dart';
import '../basics/product_group/product_group.dart';
import '../basics/warp_group/warp_group.dart';
import '../basics/warp_supplier_single_yarn_rate.dart/warp_supplier_single_yarn_rate.dart';
import '../basics/warping_wages_config_list/warping_wages_config.dart';
import '../basics/winding_yarn_conversation/winding_yarn_conversation.dart';
import '../production/append_ledger/append_ledger_Screen.dart';
import '../production/loom_declaration/loom_declaration_list.dart';
import '../production/warp_notification/warp_notification.dart';
import '../production/warp_or_yarn_delivery/warp_or_yarn_delivery_screen.dart';
import '../production/weaving/add_weaving.dart';
import '../report/dyeing_report/dyeing_warp_delivery_report.dart';
import '../report/dyeing_report/dyeing_warp_inward_report.dart';
import '../report/winding_reports/winder_yarn_delivery_report.dart';
import '../report/yarn_purchase_report.dart';
import '../trasaction/jari_twisting_yarn_inward/jari_twisting_yarn_inward_screen.dart';
import '../trasaction/product_deliver_to_process/product_deliver_to_process.dart';
import '../trasaction/product_inward_from_process/product_inward_from_process.dart';
import '../trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer.dart';
import '../trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller.dart';
import '../trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_list.dart';
import '../trasaction/warp_delivery_to_roller/warp_delivery_to_roller_list.dart';
import '../trasaction/warp_purchase/warp_purchase.dart';
import '../trasaction/warper_yarn_shortage_adjustments/warper_yarn_shortage_adjustments.dart';
import '../trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_list.dart';
import '../trasaction/yarn_inward_from_winder/yarn_inward_from_winder.dart';
import '../trasaction/yarn_return_from_warper/yarn_return_from_warper.dart';
import 'dashboard3_controller.dart';

class DashBoard3 extends StatefulWidget {
  const DashBoard3({Key? key}) : super(key: key);

  @override
  State<DashBoard3> createState() => _State();
}

class _State extends State<DashBoard3> {
  DashBoard3Controller controller = Get.put(DashBoard3Controller());
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

  var box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  List<String> searchResults = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String formattedDate = " ${now.day} -${now.month}-${now.year}";

    return GetBuilder<DashBoard3Controller>(builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        body: Container(
          child: Row(
            children: [
              Container(
                width: width * .22,
                height: height,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 21,
                    ),
                    Container(
                      width: 262,
                      height: 37,
                      /*
                      decoration: ShapeDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 0.50, color: Color(0xFF9C9C9C)),
                          borderRadius: BorderRadius.circular(65),
                        ),
                      ),
                      */

                      child: Autocomplete<String>(
                        /*
                        optionsBuilder: (TextEditingValue value) {
                          if (value.text == '') {
                            return items;
                          }
                          return items.where((Object option) {
                            return option
                                .toString()
                                .toLowerCase()
                                .contains(value.text.toLowerCase());
                          });
                        },
                        */

                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return [
                            'Firm',
                            'Account Type',
                            'Ledger',
                            'Colours',
                            'Units',
                            'Cops/Reel',
                            'Yarns',
                          ].where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String value) {
                          setState(() {
                            switch (value.toLowerCase()) {
                              case 'firm':
                                // searchResult = Get.toNamed(Ledgers.routeName);
                                searchResults.add(
                                    Get.toNamed(Firms.routeName) as String);
                                break;
                              case 'account type':
                                searchResults.add(
                                    Get.toNamed(Account.routeName) as String);
                                break;
                              case 'ledger':
                                searchResults.add(
                                    Get.toNamed(Ledgers.routeName) as String);
                                break;
                              case 'colours':
                                searchResults.add(
                                    Get.toNamed(NewColor.routeName) as String);
                                break;
                              case 'units':
                                searchResults.add(
                                    Get.toNamed(NewUnit.routeName) as String);
                                break;
                              case 'cops/reel':
                                searchResults.add(
                                    Get.toNamed(CopsReel.routeName) as String);
                                break;
                              case 'yarns':
                                searchResults.add(
                                    Get.toNamed(Yarns.routeName) as String);
                                break;
                              default:
                                // searchResult = 'No result';
                                break;
                            }
                          });
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxHeight: 400, maxWidth: 270),
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final dynamic option =
                                          options.elementAt(index);
                                      return InkWell(
                                        onTap: () => onSelected(option),
                                        child: Builder(
                                            builder: (BuildContext context) {
                                          final bool highlight =
                                              AutocompleteHighlightedOption.of(
                                                      context) ==
                                                  index;
                                          if (highlight) {
                                            SchedulerBinding.instance
                                                .addPostFrameCallback(
                                                    (Duration timeStamp) {
                                              Scrollable.ensureVisible(context,
                                                  alignment: 0.5);
                                            });
                                          }
                                          return Container(
                                            color: highlight
                                                ? Theme.of(context).focusColor
                                                : null,
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text('$option'),
                                          );
                                        }),
                                      );
                                    }),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController controller,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextField(
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            controller: controller,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              labelText: 'Search..',
                              suffixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(65),
                              ),
                            ),
                            focusNode: focusNode,

                            onChanged: (value) {
                              // filterSearchResults(value);
                              itemClicked(value.toLowerCase());
                            },
                            // onSubmitted: (value) {
                            //   if (filteredItems.isNotEmpty) {
                            //     showSelectedValue(filteredItems[0]);
                            //   }
                            // },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Container(
                        width: width * .22,
                        height: height * .82,
                        // color: Colors.tealAccent,
                        child: ListView(children: <Widget>[
                          ListTile(
                            leading: const Icon(
                              Icons.info,
                              color: Colors.black,
                            ),
                            title: ExpansionTile(
                              title: const Text(
                                "Basics",
                                style: TextStyle(color: Colors.black),
                              ),

                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              // borderSide: BorderSide.none,

                              children: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Get.toNamed(Firms.routeName),
                                    child: const Row(
                                      children: [
                                        /*
                                        Icon(
                                          Icons.circle,
                                          color: Color(0xFF5C5C5C),
                                          size: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                   */
                                        Expanded(
                                          child: Text(
                                            'Firm (or) Company Info',
                                            textAlign: TextAlign.start,
                                            // overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    )),
                                TextButton(
                                    onPressed: () =>
                                        Get.toNamed(Account.routeName),
                                    child: const Text(
                                      'Account Types',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF5C5C5C),
                                          fontSize: 12),
                                    )),
                                TextButton(
                                    onPressed: () =>
                                        Get.toNamed(Ledgers.routeName),
                                    child: const Text(
                                      'Ledgers',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF5C5C5C),
                                          fontSize: 12),
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(NewColor.routeName),
                                  child: const Text(
                                    'Colours',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () =>
                                        Get.toNamed(NewUnit.routeName),
                                    child: const Text(
                                      'Units',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF5C5C5C),
                                          fontSize: 12),
                                    )),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(CopsReel.routeName),
                                  child: const Text(
                                    'Cops/Reel',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(Yarns.routeName),
                                  child: const Text(
                                    'Yarns',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(
                                      WindingYarnConversation.routeName),
                                  child: const Text(
                                    'Winding Yarn Conversions',
                                    textAlign: TextAlign.start,
                                    // overflow: TextOverflow.ellipsis,
                                    // softWrap: false,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(WarpGroup.routeName),
                                  child: const Text(
                                    'Warp Group',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(NewWarp.routeName),
                                  child: const Text(
                                    'Warp Info..',
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Warping Config.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            WarpingWagesConfig.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Wages Config.',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () =>
                                            Get.toNamed(JariTwisting.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'JariTwisting - Yarn Conversion',
                                                // overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                TextButton(
                                    onPressed: () => Get.toNamed(
                                        WarpSupplierSingleYarnRate.routeName),
                                    child: const Text(
                                      'Warp Supplier-Yarn Rate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF5C5C5C),
                                          fontSize: 12),
                                    )),
                                ExpansionTile(
                                  title: const Text(
                                    'Product',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Get.toNamed(ProductGroup.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Group',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () =>
                                            Get.toNamed(ProductInfo.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Info',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            ProductJobWorkBasics.routeName),
                                        // child: Text(
                                        //   'Product JobWorks',
                                        //   textAlign: TextAlign.start,
                                        //   style: TextStyle(
                                        //     color: Color(0xFF5C5C5C),
                                        //   ),
                                        // )
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product JobWorks',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.sync_alt_outlined,
                              color: Colors.black,
                            ),
                            title: ExpansionTile(
                              title: const Text(
                                "Transaction",
                                style: TextStyle(color: Colors.black),
                              ),
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: <Widget>[
                                //MyDataTable
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(YarnPurchase.routeName),
                                  child: const Text(
                                    'Yarn Purchase',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(YarnSalesList.routeName),
                                  child: const Text(
                                    'Yarn Sales',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'Winding',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            YarnDeliveryToWinder.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Delivery',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            YarnInwardFromWinder.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Inward',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Dyeing',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            WarpDeliveryToDyer.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Delivery',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            WarpInwardFromDyer.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Inward',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Rolling',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            WarpDeliveryToRoller.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Delivery',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            WarpInwardFromRoller.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Inward',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(
                                      ProductDcToCustomer.routeName),
                                  child: const Text(
                                    'Product D.C to Customer',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(ProductSale.routeName),
                                  child: const Text(
                                    'Product Sales',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(WarpPurchase.routeName),
                                  child: const Text(
                                    'Warp Purchase',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'Warping..(Art Silk)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            YarnDeliveryToWarper.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Delivery to Warper',
                                                // overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            YarnReturnFromWarper.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Return From Warper',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            WarperYarnShortageAdjustments
                                                .routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Shortage Adjustments',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () =>
                                            Get.toNamed(WarpInward.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Inward',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            JariTwistingYarnInward.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Jari Twisting - Yarn Inward',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'JobWork',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            ProductDeliverToJobWorker
                                                .routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Delivery',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            ProductInwardFromJobWorker
                                                .routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Inward',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'Process',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            ProductDeliverToProcess.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Delivery',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () => Get.toNamed(
                                            ProductInwardFromProcess.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Inward',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'Finance',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Get.toNamed(Payment.routeName),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Payment',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.settings,
                              color: Colors.black,
                            ),
                            title: ExpansionTile(
                              title: const Text(
                                "Production",
                                style: TextStyle(color: Colors.black),
                              ),
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: <Widget>[
                                //MyDataTable
                                TextButton(
                                  onPressed: () => Get.toNamed(
                                      LoomDeclarationList.routeName),
                                  child: const Text(
                                    'Loom Declaration',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(AddWeaving.routeName),
                                  child: const Text(
                                    'Weaving..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(WarpNotification.routeName),
                                  child: const Text(
                                    'Warp Notification',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(AppendLedgerScreen.routeName),
                                  child: const Text(
                                    'Append Ledgers',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(
                                      GoodsInwardSlipScreen.routeName),
                                  child: const Text(
                                    'Goods Inward Slip',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(WagesBillList.routeName),
                                  child: const Text(
                                    'Wages Bill',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(
                                      WarpOrYarnDeliveryProduction.routeName),
                                  child: const Text(
                                    'Warp / Yarn Delivery Slip',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          ListTile(
                            leading: const Icon(
                              Icons.tune,
                              color: Colors.black,
                            ),
                            title: ExpansionTile(
                              title: const Text(
                                "Adjustment",
                                style: TextStyle(color: Colors.black),
                              ),
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: <Widget>[
                                //MyDataTable
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(YarnStock.routeName),
                                  child: const Text(
                                    'Yarn Stock - Adjustment',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(SplitList.routeName),
                                  child: const Text(
                                    'Split Warp',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(WarpMerging.routeName),
                                  child: const Text(
                                    'Warp Merging..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Report
                          ListTile(
                            leading: const Icon(
                              Icons.moving,
                              color: Colors.black,
                            ),
                            title: ExpansionTile(
                              title: const Text(
                                "Report",
                                style: TextStyle(color: Colors.black),
                              ),
                              tilePadding: EdgeInsets.zero,
                              childrenPadding: EdgeInsets.zero,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: <Widget>[
                                //MyDataTable

                                ExpansionTile(
                                  title: const Text(
                                    'Winding',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () async {
                                          final result = await Get.dialog(
                                              const WinderYarnDeliverReport());
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Delivery Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Inward Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Winder Yarn Stock Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Dyeing...',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Delivery Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Inward Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn - Order Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Dyer - Yarn Stock Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Dyer-Warp Stock Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          final result = await Get.dialog(
                                              const DyeingWarpInwardReport());
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Inward Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          final result = await Get.dialog(
                                              const DyeingWarpDeliveryReport());
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Delivery Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Rolling..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'todo..',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'Yarn..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () async {
                                          final result = await Get.dialog(
                                              const YarnPurchaseReport());
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Purchase Order Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Stock Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Stock - DateWise Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Purchase Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Wise Purchase Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Purchase Return Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Sales Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Wise Sales Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Box Search',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                //warp
                                ExpansionTile(
                                  title: const Text(
                                    'Warp..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Stock Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Order Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Order Flow Chart',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Purchase Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Wise Purchase Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Sales Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Wise Sales Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Search',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                //product
                                ExpansionTile(
                                  title: const Text(
                                    'Product..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Product Stock Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Purchase Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product Wise Purchase Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Maximum Purchased Products Report',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Purchase Return Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Order Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'D.C Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'D.C Value Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'D.C Summary View',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Customer - Rate Chart',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Retails Sales Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Sales Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Sales Return Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Sales Return - Value Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product Wise Sales Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Firm Wise Sales Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Maximum Moved Products Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'UnMoved Products List',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Image View',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                //Warping
                                ExpansionTile(
                                  title: const Text(
                                    'Warping..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn, A/c Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Balance Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Yarn Delivery Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Warp Inward Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Jari Inward Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                //Weaving..
                                ExpansionTile(
                                  title: const Text(
                                    'Weaving..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Finished Warps List',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver - Yarn Stock Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver Yarn Stock - Cross Check',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Delivery Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver - (Other) Warp Stock Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product or MainWarp Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Excess & Shortage Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver Wages Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver Payment Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Delivery (Main Warp) Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Delivery (Other Warp) Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Beam / Bobbin Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Yarn Delivery Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Goods Inward Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Goods Inwards - Last Wages Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Debit Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Message Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Last Entry Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver Absent Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Advance Issued Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Wages Deducted Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Day Book Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Weaver List',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Loom List',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weight, Amount Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '(Datawise) Wages Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'WeaverWise A/c Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Beam / Bobbin  Token Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Delivered-Weft Colors',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weaver Balance (Pure Silk)',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Manual Warp Notification',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Warp Notification Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Weft Colours Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                //Garment
                                ExpansionTile(
                                  title: const Text(
                                    'Garment',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Text(
                                              '- todo..',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                //Jobwork
                                ExpansionTile(
                                  title: const Text(
                                    'JobWork...',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product Delivery Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product Inward Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF5C5C5C),
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'JobWroker - Product Balance Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Process..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product Delivery Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Product Inward Report',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Proessor - Product Balance',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Color(0xFF5C5C5C),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),

                                ExpansionTile(
                                  title: const Text(
                                    'Finance..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '- todo..',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Value Reports..',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '- todo..',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                ExpansionTile(
                                  title: const Text(
                                    'Others',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Color(0xFF5C5C5C), fontSize: 12),
                                  ),
                                  children: <Widget>[
                                    TextButton(
                                        onPressed: () {},
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF5C5C5C),
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '- todo..',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Color(0xFF5C5C5C),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(
                  left: 19,
                  right: 19,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          height: height * .75,
                          width: width,
                          // color: Colors.tealAccent,
                          /*
                        child: GridView.builder(
                          itemCount: controller.list.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 8,
                            crossAxisCount:
                                (MediaQuery.of(context).size.width ~/ 120)
                                    .toInt(),
                          ),
                          /*
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 10, // Number of columns
                                crossAxisSpacing: 1.0, // Spacing between columns
                                mainAxisSpacing: 1.0, // Spacing between rows
                                childAspectRatio: 1.0, // Aspect ratio of items
                              ),
                             */
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> map = controller.list[index];
                            var item = map['title'];
                            var icon = map['icon'];
                            var color = map['color'];
                            // return InkWell(
                            //   onTap: () => itemClicked('$item'),
                            //   child: Tooltip(
                            //     message: "$item",
                            //     child: Container(
                            //         width: 50,
                            //         height: 200,
                            //         padding: const EdgeInsets.all(16),
                            //         child: Image.asset('$icon')),
                            //   ),
                            // );

                            return InkWell(
                              onTap: () => itemClicked('$item'),
                              child: Container(
                                height: 200,
                                width: 100,
                                color: Colors.green,
                                //  padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Image.asset('$icon'),
                                    Text('venki')
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        */

                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                              childAspectRatio: 1.0, // Aspect ratio of items
                            ),
                            itemCount:
                                controller.list.length, // Total number of items
                            itemBuilder: (BuildContext context, int index) {
                              // Function called for each item in the grid
                              // Use index to fetch item data from your data source
                              Map<String, dynamic> map = controller.list[index];
                              var item = map['title'];
                              var icon = map['icon'];
                              var color = map['color'];
                              return InkWell(
                                onTap: () => itemClicked('$item'),
                                child: Tooltip(
                                  message: "$item",
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    padding: const EdgeInsets.only(
                                      top: 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          '$icon',
                                          width:
                                              35, // Specify the desired width
                                          height: 35,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "$item",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          width: 323,
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF3F3F3)),
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 235,
                                      height: 35,
                                      child: Text(
                                        '${box.read('name')}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      height: 35,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 117,
                                            height: 35,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month,
                                                  size: 13,
                                                  color: Color(0xFF696969),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  "$formattedDate",
                                                  style: const TextStyle(
                                                    color: Color(0xFF696969),
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 117,
                                            height: 35,
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                const Icon(
                                                  Icons.access_time_outlined,
                                                  size: 13,
                                                  color: Color(0xFF696969),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '$formattedTime',
                                                  style: const TextStyle(
                                                    color: Color(0xFF696969),
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),

                                                // Text(
                                                //   '${dateToday}',
                                                //   style:
                                                //       const TextStyle(fontSize: 8),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async =>
                                        _showLogoutDialog(context),
                                    tooltip: 'Logout',
                                    icon: const Icon(
                                      Icons.power_settings_new,
                                      size: 32,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Color(0xFFDA5050),
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
          // padding: const EdgeInsets.all(20),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text('Dashboard3'),
          //     GridView.builder(
          //       itemCount: controller.list.length,
          //       shrinkWrap: true,
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisSpacing: 20,
          //         mainAxisSpacing: 8,
          //         crossAxisCount:
          //             (MediaQuery.of(context).size.width ~/ 90).toInt(),
          //       ),
          //       itemBuilder: (BuildContext context, int index) {
          //         Map<String, dynamic> map = controller.list[index];
          //         var item = map['title'];
          //         var icon = map['icon'];
          //         var color = map['color'];
          //         return InkWell(
          //           onTap: () => itemClicked('$item'),
          //           child: Tooltip(
          //             message: "$item",
          //             child: Container(
          //               width: 24,
          //               height: 24,
          //               padding: const EdgeInsets.all(16),
          //               child: Image.asset('$icon'),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //     Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Image.asset(
          //             'assets/images/logo.png',
          //             height: 180,
          //           ),
          //           Container(
          //             padding: const EdgeInsets.all(36),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.end,
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [
          //                 IconButton(
          //                   onPressed: () async => _showLogoutDialog(context),
          //                   tooltip: 'Logout',
          //                   icon: const Icon(
          //                     Icons.power_settings_new,
          //                     color: Colors.red,
          //                   ),
          //                 ),
          //                 Text(
          //                   '${box.read('name')}',
          //                   style: const TextStyle(fontSize: 12),
          //                 ),
          //                 Text(
          //                   '${DateTime.now()}',
          //                   style: const TextStyle(fontSize: 8),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           /*
          //           Container(
          //             width: 323,
          //             height: 90,
          //             child: Stack(
          //               children: [
          //                 Positioned(
          //                   left: 0,
          //                   top: 0,
          //                   child: Container(
          //                     width: 323,
          //                     height: 90,
          //                     child: Stack(
          //                       children: [
          //                         Positioned(
          //                           left: 0,
          //                           top: 0,
          //                           child: Container(
          //                             width: 323,
          //                             height: 90,
          //                             decoration: ShapeDecoration(
          //                               color: Color(0xFFF3F3F3),
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                       BorderRadius.circular(5)),
          //                             ),
          //                           ),
          //                         ),
          //                         Positioned(
          //                           left: 17,
          //                           top: 12,
          //                           child: Text(
          //                             'Naveen R',
          //                             style: TextStyle(
          //                               color: Colors.black,
          //                               fontSize: 16,
          //                               fontFamily: 'Poppins',
          //                               fontWeight: FontWeight.w500,
          //                               height: 0,
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 Positioned(
          //                   left: 124,
          //                   top: 50,
          //                   child: Container(
          //                     width: 86,
          //                     height: 20,
          //                     child: Stack(
          //                       children: [
          //                         Positioned(
          //                           left: 15,
          //                           top: 0,
          //                           child: Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.access_time_outlined,
          //                                 size: 13,
          //                                 color: Color(0xFF696969),
          //                               ),
          //                               SizedBox(
          //                                 width: 4,
          //                               ),
          //                               Text(
          //                                 '6:00:00 PM',
          //                                 style: TextStyle(
          //                                   color: Color(0xFF696969),
          //                                   fontSize: 13,
          //                                   fontFamily: 'Poppins',
          //                                   fontWeight: FontWeight.w500,
          //                                   height: 0,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 Positioned(
          //                   left: 17,
          //                   top: 50,
          //                   child: Container(
          //                     width: 93,
          //                     height: 20,
          //                     child: Stack(
          //                       children: [
          //                         Positioned(
          //                           left: 0,
          //                           top: 0,
          //                           child: Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.calendar_month,
          //                                 size: 13,
          //                                 color: Color(0xFF696969),
          //                               ),
          //                               SizedBox(
          //                                 width: 2,
          //                               ),
          //                               Text(
          //                                 '25-01-2024',
          //                                 style: TextStyle(
          //                                   color: Color(0xFF696969),
          //                                   fontSize: 13,
          //                                   fontFamily: 'Poppins',
          //                                   fontWeight: FontWeight.w500,
          //                                   height: 0,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                       top: 10, bottom: 10, right: 10),
          //                   child: Align(
          //                     alignment: Alignment.centerRight,
          //                     child: Column(
          //                       children: [
          //                         IconButton(
          //                           onPressed: () async =>
          //                               _showLogoutDialog(context),
          //                           tooltip: 'Logout',
          //                           icon: const Icon(
          //                             Icons.power_settings_new,
          //                             size: 32,
          //                             color: Colors.red,
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           height: 5,
          //                         ),
          //                         Text(
          //                           'Logout',
          //                           style: TextStyle(
          //                             color: Color(0xFFDA5050),
          //                             fontSize: 11,
          //                             fontFamily: 'Poppins',
          //                             fontWeight: FontWeight.w600,
          //                             height: 0,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //           */
          //           Container(
          //             width: 323,
          //             height: 90,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(5),
          //                 color: Color(0xFFF3F3F3)),
          //             padding: EdgeInsets.only(
          //                 left: 10, top: 10, bottom: 10, right: 10),
          //             child: Row(
          //               children: [
          //                 Expanded(
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width: 235,
          //                         height: 35,
          //                         child: Text(
          //                           '${box.read('name')}',
          //                           style: const TextStyle(
          //                             color: Colors.black,
          //                             fontSize: 16,
          //                             fontFamily: 'Poppins',
          //                             fontWeight: FontWeight.w500,
          //                             height: 0,
          //                           ),
          //                         ),
          //                       ),
          //                       Container(
          //                         width: 235,
          //                         height: 35,
          //                         child: Row(
          //                           children: [
          //                             Container(
          //                               width: 117,
          //                               height: 35,
          //                               child: Row(
          //                                 children: [
          //                                   Icon(
          //                                     Icons.calendar_month,
          //                                     size: 13,
          //                                     color: Color(0xFF696969),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 2,
          //                                   ),
          //                                   Text(
          //                                     '25-01-2024',
          //                                     style: TextStyle(
          //                                       color: Color(0xFF696969),
          //                                       fontSize: 13,
          //                                       fontFamily: 'Poppins',
          //                                       fontWeight: FontWeight.w500,
          //                                       height: 0,
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                             Container(
          //                               width: 117,
          //                               height: 35,
          //                               child: Row(
          //                                 children: [
          //                                   SizedBox(
          //                                     width: 4,
          //                                   ),
          //                                   Icon(
          //                                     Icons.access_time_outlined,
          //                                     size: 13,
          //                                     color: Color(0xFF696969),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 4,
          //                                   ),
          //                                   Text(
          //                                     '6:00:00 PM',
          //                                     style: TextStyle(
          //                                       color: Color(0xFF696969),
          //                                       fontSize: 13,
          //                                       fontFamily: 'Poppins',
          //                                       fontWeight: FontWeight.w500,
          //                                       height: 0,
          //                                     ),
          //                                   ),
          //
          //                                   // Text(
          //                                   //   '${dateToday}',
          //                                   //   style:
          //                                   //       const TextStyle(fontSize: 8),
          //                                   // ),
          //                                 ],
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Column(
          //                   children: [
          //                     IconButton(
          //                       onPressed: () async =>
          //                           _showLogoutDialog(context),
          //                       tooltip: 'Logout',
          //                       icon: const Icon(
          //                         Icons.power_settings_new,
          //                         size: 32,
          //                         color: Colors.red,
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 5,
          //                     ),
          //                     Text(
          //                       'Logout',
          //                       style: TextStyle(
          //                         color: Color(0xFFDA5050),
          //                         fontSize: 11,
          //                         fontFamily: 'Poppins',
          //                         fontWeight: FontWeight.w600,
          //                         height: 0,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
      );
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                var box = GetStorage();
                await box.erase();
                Get.toNamed('/');
              },
              child: const Text('LOGOUT'),
            ),
          ],
        );
      },
    );
  }
}

itemClicked(String item) {
  switch (item) {
    // 1
    case 'Ledger':
      Get.toNamed(Ledgers.routeName);
      break;
    //   2
    case 'New Yarn':
      Get.toNamed(Yarns.routeName);
      break;
    //   3
    case 'Product Info':
      Get.toNamed(ProductInfo.routeName);
      break;
    //   4
    case 'Yarn Purchase':
      Get.toNamed(YarnPurchase.routeName);
      break;
    //   5
    case 'Yarn Sale':
      Get.toNamed(YarnSalesList.routeName);
      break;
    //   6
    case 'Product Purchase':
      Get.toNamed(ProductPurchase.routeName);
      break;
    //   7
    case 'Warp Order':
      // Get.toNamed(WarpOrder.routeName);
      break;
    //   8
    case 'Warp Sale':
      // Get.toNamed(WarpSaleList.routeName);
      break;
    //   9
    case 'Yarn Delivery To Warper':
      Get.toNamed(YarnDeliveryToWarper.routeName);
      break;
    //   10
    case 'Warp Inward':
      Get.toNamed(WarpInward.routeName);
      break;
    //   11
    case 'Jari Twisting':
      Get.toNamed(JariTwisting.routeName);
      break;
    //   12
    case 'Product DC to Customer':
      Get.toNamed(ProductDcToCustomer.routeName);
      break;
    //   13
    case 'Product Sale':
      Get.toNamed(ProductSale.routeName);
      break;
    //   14
    case 'Product Jobwork Delivery':
      Get.toNamed(ProductDeliverToJobWorker.routeName);
      break;
    //   15
    case 'Product Jobwork Inward':
      Get.toNamed(ProductInwardFromJobWorker.routeName);
      break;
    //   16
    case 'Payment':
      Get.toNamed(Payment.routeName);
      break;
    //   17
    case 'Goods Inward Slip':
      Get.toNamed(GoodsInwardSlipScreen.routeName);
      break;
    //   18
    case 'Wages Bill':
      Get.toNamed(WagesBillList.routeName);
      break;
    //   19
    case 'Warp or Yarn Delivery Slip':
      Get.toNamed(WarpOrYarnDeliveryProduction.routeName);
      break;
    //   20
    case 'Weaving':
      Get.toNamed(Payment.routeName);
      break;

    //
    // case 'Firm':
    //   Get.toNamed(Firms.routeName);
    //   break;
    // case 'Account':
    //   Get.toNamed(Account.routeName);
    //   break;
    // case 'New Colour':
    //   Get.toNamed(NewColor.routeName);
    //   break;
    // case 'New Unit':
    //   Get.toNamed(NewUnit.routeName);
    //   break;
    // case 'Cops-Reel':
    //   Get.toNamed(CopsReel.routeName);
    //   break;
    //
    // case 'Winding Yarn Conversions':
    //   Get.toNamed(WindingYarnConversation.routeName);
    //   break;
    // case 'Warp Design Sheet':
    //   Get.snackbar("Alert", "Working in progress");
    //   break;
    // case 'Warp Group':
    //   Get.toNamed(WarpGroup.routeName);
    //   break;
    // case 'New Warp':
    //   Get.toNamed(NewWarp.routeName);
    //   break;
    // case 'Warping Wages Config':
    //   Get.toNamed(WarpingWagesConfig.routeName);
    //   break;
    // case 'Warping Design Charges Config':
    //   Get.toNamed(WarpingDesignChargesConfig.routeName);
    //   break;
    // case 'Warp Supplier Single yarn Rate':
    //   Get.toNamed(WarpSupplierSingleYarnRate.routeName);
    //   break;
    // case 'Product Group':
    //   Get.toNamed(ProductGroup.routeName);
    //   break;
    //
    // case 'Product Image':
    //   Get.snackbar("Alert", "Working in progress");
    //   break;
    // case 'Product Weft Requirement':
    //   Get.toNamed(product_weft_requirements.routeName);
    //   break;
    // case 'Product Job Work':
    //   Get.toNamed(ProductJobWorkBasics.routeName);
    //   break;
    // case 'Color Matching':
    //   Get.toNamed(ColorMatchingList.routeName);
    //   break;
    // case 'Costing Entry':
    //   Get.toNamed(CostingEntryList.routeName);
    //   break;
    // case 'Costing Change':
    //   Get.toNamed(CostingChangeList.routeName);
    //   break;
    // case 'Costing Change':
    //   Get.toNamed(CostingChangeList.routeName);
    //   break;
    // case 'Yarn Opening Stock':
    //   Get.toNamed(YarnOpeningStock.routeName);
    //   break;
    // case 'Warp Opening Stock':
    //   Get.toNamed(WarpOpeningStock.routeName);
    //   break;
    // case 'Product Opening Stock':
    //   Get.toNamed(Product_Opening_Stock.routeName);
    //   break;
    // case 'Empty Opening Stock':
    //   Get.toNamed(EmptyOpeningStock.routeName);
    //   break;
  }
}
