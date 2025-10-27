import 'package:abtxt/view/administrator/add_administrator.dart';
import 'package:abtxt/view/basics/Cops_Reel/cops_reel.dart';
import 'package:abtxt/view/basics/account/account.dart';
import 'package:abtxt/view/basics/account_details/account_details_list.dart';
import 'package:abtxt/view/basics/app_history/app_history.dart';
import 'package:abtxt/view/basics/firm/firms.dart';
import 'package:abtxt/view/basics/ledger/ledgers.dart';
import 'package:abtxt/view/basics/new_color/new_color.dart';
import 'package:abtxt/view/basics/new_unit/new_unit.dart';
import 'package:abtxt/view/basics/new_wrap/new_warp.dart';
import 'package:abtxt/view/basics/process_type/process_type.dart';
import 'package:abtxt/view/basics/product_opening_stock/product-opening-stock.dart';
import 'package:abtxt/view/basics/productinfo/product_info.dart';
import 'package:abtxt/view/basics/saree_checker/saree_checker_list.dart';
import 'package:abtxt/view/basics/warp_checker/warp_checker_list.dart';
import 'package:abtxt/view/basics/warp_group/warp_group.dart';
import 'package:abtxt/view/basics/warping_wages_config_list/warping_wages_config.dart';
import 'package:abtxt/view/basics/winding_yarn_conversation/winding_yarn_conversation.dart';
import 'package:abtxt/view/basics/yarn/yarns.dart';
import 'package:abtxt/view/mainscreen/mainscreen_controller.dart';
import 'package:abtxt/view/production/empty_in_out/empty_in_out_list.dart';
import 'package:abtxt/view/production/loom_declaration/loom_declaration_list.dart';
import 'package:abtxt/view/production/warp_tracking/warp_tracking.dart';
import 'package:abtxt/view/production/weaving/add_weaving.dart';
import 'package:abtxt/view/production/weaving_product_approval/weaving_product_approval.dart';
import 'package:abtxt/view/report/cheque_leaf_print/cheque_leaf.dart';
import 'package:abtxt/view/report/finance/tds_report/tds_amount_list.dart';
import 'package:abtxt/view/report/letter_head/letter_head.dart';
import 'package:abtxt/view/report/warp_reports/warp_purchase_report.dart';
import 'package:abtxt/view/report/warp_reports/warp_search_report.dart';
import 'package:abtxt/view/report/warping_reports/jari_twisting_inward_report.dart';
import 'package:abtxt/view/report/weaving_reports/empty_inout_report/empty_inout_report.dart';
import 'package:abtxt/view/report/weaving_reports/saree_checker_report/saree_checker_report.dart';
import 'package:abtxt/view/report/winding_reports/winder_yarn_inward_report.dart';
import 'package:abtxt/view/report/yarn__reports/purchase_yarn_report.dart';
import 'package:abtxt/view/trasaction/credit_note/credit_note_list.dart';
import 'package:abtxt/view/trasaction/payment_v2/payment_v2.dart';
import 'package:abtxt/view/trasaction/product_deliver_to_process/product_deliver_to_process.dart';
import 'package:abtxt/view/trasaction/product_delivery_to_jobworker/product_deliver_to_jobworker.dart';
import 'package:abtxt/view/trasaction/product_inward_from_jobworker/product_inward_from_jobworker.dart';
import 'package:abtxt/view/trasaction/product_inward_from_process/product_inward_from_process.dart';
import 'package:abtxt/view/trasaction/product_order/product_order_list.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_list.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_dyer/warp_Inward_from_dyer.dart';
import 'package:abtxt/view/trasaction/warp_Inward_from_roller_list/warp_Inward_from_roller.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_dyer_list/warp_delivery_to_dyer_list.dart';
import 'package:abtxt/view/trasaction/warp_delivery_to_roller/warp_delivery_to_roller_list.dart';
import 'package:abtxt/view/trasaction/warp_inward/warp_inward.dart';
import 'package:abtxt/view/trasaction/warp_purchase/warp_purchase.dart';
import 'package:abtxt/view/trasaction/yarn_delivery_to_winder/yarn_delivery_to_winder_list.dart';
import 'package:abtxt/view/trasaction/yarn_inward_from_winder/yarn_inward_from_winder.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_list.dart';
import 'package:abtxt/view/trasaction/yarn_sales/yarn_sales_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:menu_bar/src/entry.dart';

import '../adjustments/yarn_stock_adjustment/yarn_stock_list.dart';
import '../basics/Product_Job_Work/Product_Job_work.dart';
import '../basics/jari_twisting/jari_twisting.dart';
import '../basics/machine_details/machine_details.dart';
import '../basics/product_group/product_group.dart';
import '../basics/product_weft_requirements/product_weft_requirements.dart';
import '../basics/tax_fix/tax_fix.dart';
import '../basics/vehicle_details/vechical_details.dart';
import '../dashboard2/dashboard2screen.dart';
import '../dashboard_new/product_sales_dashboard/product_sales_dashboard.dart';
import '../production/dropout_warp_allocation/warp_dropout_allocation_list.dart';
import '../production/goods_inward_slip/goods_inward_slip_screen.dart';
import '../production/warp_or_yarn_delivery/warp_or_yarn_delivery_screen.dart';
import '../report/bank_details_pdf/bank_details_pdf_screen.dart';
import '../report/dyeing_report/dyeing_warp_inward_report.dart';
import '../report/dyeing_report/dyer_warp_stock_report.dart';
import '../report/finance/banking_report/banking_report.dart';
import '../report/finance/payment_report.dart';
import '../report/jobworker_reports/jobworker_product_balance_report.dart';
import '../report/jobworker_reports/jobworker_product_delivery_report.dart';
import '../report/jobworker_reports/jobworker_product_inward_report.dart';
import '../report/process_reports/processor_product_balance.dart';
import '../report/process_reports/product_delivery_report.dart';
import '../report/process_reports/product_inward_report.dart';
import '../report/product_reports/product_sales_report.dart';
import '../report/rolling_reports/roller_warp_stock_report.dart';
import '../report/rolling_reports/rolling_warp_inward_reports.dart';
import '../report/warp_reports/warp_stock_report.dart';
import '../report/warping_reports/warping_warp_inward_report.dart';
import '../report/warping_reports/warping_yarn_balance_report.dart';
import '../report/warping_reports/warping_yarn_delivery_report.dart';
import '../report/warping_reports/yarn_ac_balance_report.dart';
import '../report/weaving_reports/finished_warp_list/finished_warp_list_screen.dart';
import '../report/weaving_reports/loom_list_report.dart';
import '../report/weaving_reports/weaver_absent_report.dart';
import '../report/weaving_reports/weaving_day_book.dart';
import '../report/weaving_reports/weaving_goods_inward_report.dart';
import '../report/weaving_reports/weaving_pending_goods_inward_report.dart';
import '../report/weaving_reports/weaving_yarn_delivery_report.dart';
import '../report/winding_reports/winder_yarn_delivery_report.dart';
import '../report/winding_reports/winder_yarn_stock_report.dart';
import '../report/yarn__reports/yarn_sale_report.dart';
import '../report/yarn__reports/yarn_stock_report.dart';
import '../trasaction/debit_note/debit_note_list.dart';
import '../trasaction/jari_twisting_yarn_inward/jari_twisting_yarn_inward_screen.dart';
import '../trasaction/jari_twisting_yarn_inward_v2/jari_twisting_yarn_inward_v2.dart';
import '../trasaction/warp_sale/warp_sale_list.dart';
import '../trasaction/warper_yarn_shortage_adjustments/warper_yarn_shortage_adjustments.dart';
import '../trasaction/yarn_delivery_to_twister/yarn_delivery_to_twister.dart';
import '../trasaction/yarn_delivery_to_warper_list/yarn_delivery_to_warper.dart';
import '../trasaction/yarn_return_from_warper/yarn_return_from_warper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/mainscreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late GetStorage box;

  @override
  late BuildContext context;
  String? userType;

  @override
  void initState() {
    box = GetStorage();
    userType = box.read("user_type") ?? '';

    if (userType == "A") {
      BASIC_MENUS.add(const MenuDivider());
      BASIC_MENUS.add(MenuButton(
        text: const Text('Administrator'),
        onTap: () => Get.toNamed(AddAdministrator.routeName),
      ));
      PRODUCTION_MENUS.add(const MenuDivider());
      PRODUCTION_MENUS.add(MenuButton(
        text: const Text('Product Approval'),
        onTap: () => Get.toNamed(WeavingProductApproval.routeName),
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(builder: (controller) {
      this.context = context;
      return MenuBarWidget(
        barStyle: const MenuStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          )),
        ),
        menuButtonStyle: const ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(36.0)),
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 13.0, vertical: 13.0)),
        ),
        barButtons: [
          BarButton(
            text: const Text('Basic Info'),
            submenu: SubMenu(
              menuItems: BASIC_MENUS,
            ),
          ),
          BarButton(
            text: const Text('Transactions'),
            submenu: SubMenu(
              menuItems: TRANSACTION_MENUS,
            ),
          ),
          BarButton(
            text: const Text('Production'),
            submenu: SubMenu(
              menuItems: PRODUCTION_MENUS,
            ),
          ),
          BarButton(
            text: const Text('Adjustment'),
            submenu: SubMenu(
              menuItems: ADJUSTMENT_MENUS,
            ),
          ),
          BarButton(
            text: const Text('Reports'),
            submenu: SubMenu(
              menuItems: REPORTS_MENUS,
            ),
          ),
          BarButton(
            text: const Text('Dashboard'),
            submenu: SubMenu(
              menuItems: DASHBOARD,
            ),
          ),
        ],
        child: const Scaffold(
          body: DashBoard2(),
        ),
      );
    });
  }

  var BASIC_MENUS = <MenuEntry>[
    MenuButton(
      onTap: () => Get.toNamed(Firms.routeName),
      text: const Text('Firm (or) Company Info'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(Account.routeName),
      text: const Text('Account Types'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(Ledgers.routeName),
      text: const Text('Ledgers'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(TaxFix.routeName),
      text: const Text('Tax Fix'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(NewColor.routeName),
      text: const Text('Colors'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(NewUnit.routeName),
      text: const Text('Units'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(CopsReel.routeName),
      text: const Text('Cops/Reel'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(Yarns.routeName),
      text: const Text('Yarns'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(WindingYarnConversation.routeName),
      text: const Text('Winding Yarn Conversions'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(WarpGroup.routeName),
      text: const Text('Warp Group'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(NewWarp.routeName),
      text: const Text('Warp Info..'),
    ),
    MenuButton(
        // onTap: () {},
        text: const Text('Warping Config.'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(WarpingWagesConfig.routeName),
            text: const Text('Wages Config.'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(JariTwisting.routeName),
            text: const Text('JariTwisting - Yarn Conversions'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
        text: const Text('Product'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(ProductGroup.routeName),
            text: const Text('Product Group'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(ProductInfo.routeName),
            text: const Text('Product Info'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(ProductWeftRequirements.routeName),
            text: const Text('Product Weft Requirements'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(ProductJobWorkBasics.routeName),
            text: const Text('Product JobWorks'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
      text: const Text('Product Opening Stock'),
      onTap: () => Get.toNamed(ProductOpeningBalance.routeName),
    ),
    const MenuDivider(),
    MenuButton(
      text: const Text('Machine Details'),
      onTap: () => Get.toNamed(MachineDetails.routeName),
    ),
    const MenuDivider(),
    MenuButton(
        text: const Text('Checker'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            text: const Text('Saree Checker'),
            onTap: () => Get.toNamed(SareeChecker.routeName),
          ),
          MenuButton(
            text: const Text('Warp Checker'),
            onTap: () => Get.toNamed(WarpChecker.routeName),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
      text: const Text('Process Type'),
      onTap: () => Get.toNamed(ProcessType.routeName),
    ),
    const MenuDivider(),
    MenuButton(
      text: const Text('Bank Info'),
      onTap: () => Get.toNamed(AccountDetailsList.routeName),
    ),
    const MenuDivider(),
    MenuButton(
      text: const Text('App History'),
      onTap: () => Get.toNamed(AppHistory.routeName),
    ),
    const MenuDivider(),
    MenuButton(
      text: const Text('Vehicle Details'),
      onTap: () => Get.toNamed(VehicleDetails.routeName),
    ),
  ];
  var TRANSACTION_MENUS = [
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(YarnPurchase.routeName),
      text: const Text('Yarn Purchase'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(YarnSalesList.routeName),
      text: const Text('Yarn Sales'),
    ),
    const MenuDivider(),
    MenuButton(
        text: const Text('Winding'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(YarnDeliveryToWinder.routeName),
            text: const Text('Yarn Delivery'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(YarnInwardFromWinder.routeName),
            text: const Text('Yarn Inward'),
          ),
        ])),
    MenuButton(
        text: const Text('Dyeing'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(WarpDeliveryToDyer.routeName),
            text: const Text('Warp Delivery'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(WarpInwardFromDyer.routeName),
            text: const Text('Warp Inward'),
          ),
        ])),
    MenuButton(
        text: const Text('Rolling'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(WarpDeliveryToRoller.routeName),
            text: const Text('Warp Delivery'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(WarpInwardFromRoller.routeName),
            text: const Text('Warp Inward'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(ProductOrderList.routeName),
      text: const Text('Product Order'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(ProductSale.routeName),
      text: const Text('Product Sales'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(WarpPurchase.routeName),
      text: const Text('Warp Purchase'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(WarpSaleList.routeName),
      text: const Text('Warp Sale'),
    ),
    const MenuDivider(),
    MenuButton(
        text: const Text('Warping..(Art Silk)'),
        submenu: SubMenu(menuItems: [
          MenuButton(
              onTap: () => Get.toNamed(YarnDeliveryToWarper.routeName),
              text: const Text('Yarn Delivery to Warper')),
          MenuButton(
            onTap: () => Get.toNamed(YarnReturnFromWarper.routeName),
            text: const Text('Yarn Return From Warper'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(WarperYarnShortageAdjustments.routeName),
            text: const Text('Yarn Shortage Adjustments'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(WarpInward.routeName),
            text: const Text('Warp Inward'),
          ),
          // MenuButton(
          //   onTap: () {},
          //   text: const Text('Multi Warp Inward'),
          // ),
          MenuButton(
            onTap: () => Get.toNamed(JariTwistingYarnInward.routeName),
            text: const Text('Jari Twisting - Yarn Inward'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
        text: const Text('Jari Twisting'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(YarnDeliveryToTwister.routeName),
            text: const Text('Yarn Delivery to twister'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(JariTwistingYarnInwardV2.routeName),
            text: const Text('Jari Twisting - Yarn Inward'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
        text: const Text('JobWork'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(ProductDeliverToJobWorker.routeName),
            text: const Text('Product Delivery'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(ProductInwardFromJobWorker.routeName),
            text: const Text('Product Inward'),
          ),
        ])),
    MenuButton(
        text: const Text('Process'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(ProductDeliverToProcess.routeName),
            text: const Text('Product Delivery'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(ProductInwardFromProcess.routeName),
            text: const Text('Product Inward'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
      text: const Text('Finance'),
      submenu: SubMenu(
        menuItems: [
          MenuButton(
            onTap: () => Get.toNamed(PaymentV2.routeName),
            text: const Text('Payment'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const BankingReport());
            },
            text: const Text('Banking Report'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(DebitNoteList.routeName),
            text: const Text('Debit Note'),
          ),
          MenuButton(
            onTap: () => Get.toNamed(CreditNoteList.routeName),
            text: const Text('Credit Note'),
          ),
        ],
      ),
    ),
  ];
  var PRODUCTION_MENUS = [
    MenuButton(
      onTap: () => Get.toNamed(LoomDeclarationList.routeName),
      text: const Text('Loom Declaration'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(AddWeaving.routeName),
      text: const Text('Weaving..'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(GoodsInwardSlipScreen.routeName),
      text: const Text('Goods Inward Slip'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(WarpOrYarnDeliveryProduction.routeName),
      text: const Text('Warp / Yarn Delivery Slip'),
    ),
    MenuButton(
      onTap: () => Get.toNamed(EmptyInOutList.routeName),
      text: const Text('Empty In - Out'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(WarpDropoutAllocationList.routeName),
      text: const Text('Warp Dropout Allocation'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.toNamed(WarpTrackingList.routeName),
      text: const Text('Warp Tracking'),
    ),
  ];
  var ADJUSTMENT_MENUS = [
    MenuButton(
      onTap: () => Get.toNamed(YarnStock.routeName),
      text: const Text('Yarn Stock - Adjustment'),
    ),
  ];
  var REPORTS_MENUS = [
    MenuButton(
      onTap: () => Get.toNamed(ChequeLeaf.routeName),
      text: const Text('Cheque Leaf'),
    ),
    const MenuDivider(),
    MenuButton(
      onTap: () => Get.dialog(const LetterHead()),
      text: const Text('Letter Pade'),
    ),
    const MenuDivider(),
    MenuButton(
        text: const Text('Winding..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const WinderYarnDeliverReport());
            },
            text: const Text('Yarn Delivery Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const WinderYarnInwardReport());
            },
            text: const Text('Yarn Inward Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () async {
              Get.dialog(const WinderYarnStockReport());
            },
            text: const Text('Winder-Yarn Stock Report'),
          ),
        ])),
    MenuButton(
        text: const Text('Dyeing...'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const DyeingWarpInwardReport());
            },
            text: const Text('Warp Inward Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const DyerWarpStockReport());
            },
            text: const Text('Dyer-Warp Stock Report'),
          ),
        ])),
    MenuButton(
        text: const Text('Rolling..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const RollerWarpStockReport());
            },
            text: const Text('Roller-Warp Stock Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const RollingWarpInwardReport());
            },
            text: const Text('Warp Inward Report'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
        text: const Text('Yarn..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const YarnStockReport());
            },
            text: const Text('Yarn Stock Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () async {
              Get.dialog(const PurchaseYarnReport());
            },
            text: const Text('Purchase Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const YarnSaleReport());
            },
            text: const Text('Sales Report'),
          ),
        ])),
    MenuButton(
        text: const Text('Warp..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const WarpStockReport());
            },
            text: const Text('Warp Stock Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () async {
              Get.dialog(const WarpPurchaseReport());
            },
            text: const Text('Purchase Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () => Get.toNamed(WarpSearchReport.routeName),
            text: const Text('Warp Search'),
          ),
        ])),
    MenuButton(
        text: const Text('Product..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const ProductSalesReport());
            },
            text: const Text('Sales Report'),
          ),
        ])),
    const MenuDivider(),
    MenuButton(
        text: const Text('Warping..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const YarnAcBalanceReport());
            },
            text: const Text('Yarn, A/c Balance Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () async {
              Get.dialog(const WarpingYarnBalanceReport());
            },
            text: const Text('Yarn Balance Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const WarpingYarnDeliveryReport());
            },
            text: const Text('Yarn Delivery Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const WarpingWarpInwardReport());
            },
            text: const Text('Warp Inward Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const JariTwistingInwardReport());
            },
            text: const Text('Jar Twisting Inward Report'),
          ),
        ])),
    MenuButton(
      text: const Text('Weaving..'),
      submenu: SubMenu(menuItems: [
        MenuButton(
          onTap: () async {
            Get.dialog(const FinishedWarpList());
          },
          text: const Text('Finished Warps List'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const WeavingYarnDeliveryReport());
          },
          text: const Text('Yarn Delivery Summary'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const WeavingGoodsInwardReport());
          },
          text: const Text('Goods Inward Report'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const WeavingPendingGoodsInwardReport());
          },
          text: const Text('Pending Goods Inward Report'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const WeaverAbsentReport());
          },
          text: const Text('Weaver Absent Report'),
        ),
        const MenuDivider(),
        MenuButton(
          onTap: () async {
            Get.dialog(const WeavingDayBook());
          },
          text: const Text('Day Book Report'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const LoomListReportWeaving());
          },
          text: const Text('Loom List'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const EmptyInOutReport());
          },
          text: const Text('Empty In / Out Report'),
        ),
        MenuButton(
          onTap: () async {
            Get.dialog(const SareeCheckerReport());
          },
          text: const Text('Saree Checker Report'),
        ),
      ]),
    ),

    const MenuDivider(),

    MenuButton(
        text: const Text('JobWork...'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const JobworkerProductDeliveryReport());
            },
            text: const Text('Product Delivery Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const JobworkerProductInwardReport());
            },
            text: const Text('Product Inward Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () async {
              Get.dialog(const JobworkerProductBalanceReport());
            },
            text: const Text('JobWorker-Product Balance Report'),
          ),
        ])),
    MenuButton(
        text: const Text('Process..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const ProductDeliveryReport());
            },
            text: const Text('Product Delivery Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const ProductInwardReport());
            },
            text: const Text('Product Inward Report'),
          ),
          const MenuDivider(),
          MenuButton(
            onTap: () async {
              Get.dialog(const ProcessorProductBalance());
            },
            text: const Text('Processor-Product Balance'),
          ),
        ])),
    // const MenuDivider(),
    MenuButton(
        text: const Text('Finance..'),
        submenu: SubMenu(menuItems: [
          MenuButton(
            onTap: () async {
              Get.dialog(const PaymentReport());
            },
            text: const Text('Payment Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const TdsAmountList());
            },
            text: const Text('TDS Amount Report'),
          ),
          MenuButton(
            onTap: () async {
              Get.dialog(const BankDetailsPDFList());
            },
            text: const Text('Bank Details Report'),
          ),
        ])),
  ];
  var DASHBOARD = [
    MenuButton(
      onTap: () => Get.toNamed(ProductSalesDashboard.routeName),
      text: const Text('Product Sales Dashboard'),
    ),
  ];
}
