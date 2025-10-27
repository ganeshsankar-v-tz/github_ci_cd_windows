import 'package:abtxt/model/NewColorModel.dart';
import 'package:abtxt/model/YarnModel.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/view/basics/yarn/add_yarn.dart';
import 'package:abtxt/view/trasaction/yarn_purchase/yarn_purchase_controller.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/LastYarnPurchaseDetailsModel.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/constant.dart';
import '../../../widgets/MyAddButton.dart';
import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';

class YarnPurchaseBottomSheet extends StatefulWidget {
  const YarnPurchaseBottomSheet({super.key});

  @override
  State<YarnPurchaseBottomSheet> createState() => _State();
}

class _State extends State<YarnPurchaseBottomSheet> {
  YarnPurchaseController controller = Get.find();
  Rxn<YarnModel> yarnName = Rxn<YarnModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();

  TextEditingController stocktoController =
      TextEditingController(text: "Office");
  TextEditingController bagContoller = TextEditingController();
  TextEditingController packController = TextEditingController(text: "0");

  //TextEditingController quantityController = TextEditingController();
  // TextEditingController lessController = TextEditingController(text: '0');
  TextEditingController netQuantityController =
      TextEditingController(text: "0.000");
  TextEditingController calculateController =
      TextEditingController(text: 'Qty x Rate');
  TextEditingController rateController = TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController();
  TextEditingController lastInvoiceNoController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController lastRateController = TextEditingController(text: "0");
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();
  var shortCut = RxString("");

  final _formKey = GlobalKey<FormState>();
  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  @override
  void initState() {
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _colorNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YarnPurchaseController>(builder: (controller) {
      return ShortCutWidget(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true): NavigateIntent(),
        },
        appBar: AppBar(title: const Text('Add Item to Yarn Purchase')),
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            NavigateIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      MySearchField(
                                        label: 'Yarn Name',
                                        items: controller.yarnDropdown,
                                        textController: yarnNameTextController,
                                        focusNode: _yarnNameFocusNode,
                                        requestFocus: _netQtyFocusNode,
                                        onChanged: (YarnModel item) {
                                          yarnName.value = item;
                                          _yarnLastPurchase();
                                        },
                                      ),
                                      Focus(
                                        focusNode: _colorNameFocusNode,
                                        skipTraversal: true,
                                        child: MyAutoComplete(
                                          label: 'Color Name',
                                          items: controller.colorDropdown,
                                          selectedItem: colorname.value,
                                          onChanged: (NewColorModel item) {
                                            colorname.value = item;
                                            _yarnLastPurchase();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      MyDropdownButtonFormField(
                                        controller: stocktoController,
                                        hintText: "Stock to",
                                        items: const ["Office", "Godown"],
                                      ),
                                      MyTextField(
                                        controller: bagContoller,
                                        hintText: "Bag/Box No",
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      MyTextField(
                                        controller: packController,
                                        hintText: "Pack",
                                        validate: "number",
                                        onChanged: (value) {
                                          _sumQuantityRate();
                                        },
                                      ),
                                    ],
                                  ),
                                  // Wrap(
                                  //   children: [
                                  //     MyTextField(
                                  //       controller: quantityController,
                                  //       hintText: "Quantity",
                                  //       validate: "double",
                                  //       suffix: Obx(
                                  //         () => Text(
                                  //           yarnName.value?.unitName ?? "Unit",
                                  //           style: const TextStyle(
                                  //               color: Color(0XFF5700BC)),
                                  //         ),
                                  //       ),
                                  //       onChanged: (value) {
                                  //         _sumQuantityRate();
                                  //       },
                                  //     ),
                                  //     MyTextField(
                                  //       controller: lessController,
                                  //       hintText: "Less(-)",
                                  //       suffix: Obx(
                                  //         () => Text(
                                  //           yarnName.value?.unitName ?? "Unit",
                                  //           style: const TextStyle(
                                  //               color: Color(0XFF5700BC)),
                                  //         ),
                                  //       ),
                                  //       validate: "double",
                                  //       onChanged: (value) {
                                  //         _sumQuantityRate();
                                  //       },
                                  //     ),
                                  //   ],
                                  // ),
                                  Wrap(
                                    children: [
                                      Obx(
                                        () => Focus(
                                            skipTraversal: true,
                                            child: MyTextField(
                                              focusNode: _netQtyFocusNode,
                                              controller: netQuantityController,
                                              hintText: "Net Quantity",
                                              validate: "double",
                                              onChanged: (value) {
                                                _sumQuantityRate();
                                              },
                                              suffix: Text(
                                                yarnName.value?.unitName ??
                                                    "Unit",
                                                style: const TextStyle(
                                                    color: Color(0XFF5700BC)),
                                              ),
                                            ),
                                            onFocusChange: (hasFocus) {
                                              AppUtils.fractionDigitsText(
                                                  netQuantityController);
                                            }),
                                      ),
                                      Focus(
                                          skipTraversal: true,
                                          child: MyTextField(
                                            controller: rateController,
                                            hintText: "Rate(Rs)",
                                            validate: "double",
                                            onChanged: (value) {
                                              _sumQuantityRate();
                                            },
                                          ),
                                          onFocusChange: (hasFocus) {
                                            AppUtils.fractionDigitsText(
                                                rateController,
                                                fractionDigits: 2);
                                          }),
                                    ],
                                  ),
                                  Wrap(
                                    children: [
                                      MyDropdownButtonFormField(
                                        controller: calculateController,
                                        hintText: "Calculate Type",
                                        items: const [
                                          "Qty x Rate",
                                          "Pack x Rate",
                                          "Nothing"
                                        ],
                                        onChanged: (value) {
                                          _sumQuantityRate();
                                        },
                                      ),
                                      MyTextField(
                                        controller: amountController,
                                        hintText: "Amount(Rs)",
                                        validate: "double",
                                        onFieldSubmitted: (value) {
                                          double number =
                                              double.tryParse(value) ?? 0;
                                          String formattedValue =
                                              number.toStringAsFixed(2);
                                          amountController.text =
                                              formattedValue;
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(shortCut.value,
                                      style: AppUtils.shortCutTextStyle()),
                                ),
                                const SizedBox(width: 12),
                                MyAddButton(
                                  onPressed: () => submit(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(flex: 1, child: lastPurchase()),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (yarnName.value == null) {
        return AppUtils.infoAlert(message: "Select the Yarn name");
      }

      var request = {
        "yarn_name": yarnName.value?.name,
        "color_name": colorname.value?.name,
        "yarn_id": yarnName.value?.id,
        "color_id": colorname.value?.id,
        "stock_to": stocktoController.text,
        "box_no": bagContoller.text,
        "pack": int.tryParse(packController.text) ?? 0,
        "item_quantity": double.tryParse(netQuantityController.text) ?? 0,
        "less": 0,
        "net_quantity": double.tryParse(netQuantityController.text) ?? 0,
        "calculate_type": calculateController.text,
        "rate": rateController.text,
        "amount": double.tryParse(amountController.text) ?? 0,
      };
      Get.back(result: request);
    }
  }

  void _initValue() {
    YarnPurchaseController controller = Get.find();

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.colorDropdown.isNotEmpty) {
      colorname.value = controller.colorDropdown.first;
    }

    if (Get.arguments != null) {
      var item = Get.arguments['item'];
      bagContoller.text = item['box_no'] ?? '';
      packController.text = '${item['pack']}';
      //  quantityController.text = '${item['item_quantity']}';
      // lessController.text = '${item['less']}';
      netQuantityController.text = '${item['net_quantity']}';
      rateController.text = '${item['rate']}';
      amountController.text = '${item['amount']}';

      var yarnList = controller.yarnDropdown
          .where((element) => '${element.id}' == '${item['yarn_id']}')
          .toList();
      if (yarnList.isNotEmpty) {
        yarnName.value = yarnList.first;
      }
      var colorList = controller.colorDropdown
          .where((element) => '${element.id}' == '${item['color_id']}')
          .toList();
      if (colorList.isNotEmpty) {
        colorname.value = colorList.first;
      }

      if (Constants.stockTo.contains(item['stock_to'])) {
        stocktoController.text = '${item['stock_to']}';
      }

      if (["Qty x Rate", "Pack x Rate"].contains(item['calculate_type'])) {
        calculateController.text = '${item['calculate_type']}';
      }
    }

    if (controller.lastYarn != null) {
      var item = controller.lastYarn;
      yarnNameTextController.text = "${item['yarn_name']}";
    } else {
      yarnNameTextController.text = "";
    }
  }

  shortCutKeys() {
    if (_yarnNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Yarn',Press Alt+C ";
    } else if (_colorNameFocusNode.hasFocus) {
      shortCut.value = "To Create 'New Color',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  void navigateAnotherPage() async {
    if (_yarnNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddYarn.routeName);

      if (result == "success") {
        controller.yarnInfo();
      }
    } else if (_colorNameFocusNode.hasFocus) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.colorInfo();
      }
    }
  }

  void _sumQuantityRate() {
    double netQuantity = double.tryParse(netQuantityController.text) ?? 0;
    // double less = double.tryParse(lessController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    int pack = int.tryParse(packController.text) ?? 0;
    // var netQuantity = quantity - less;
    // netQuantityController.text = '$netQuantity';

    double amount = 0;
    if (calculateController.text == 'Qty x Rate') {
      amount = netQuantity * rate;
    } else if (calculateController.text == "Pack x Rate") {
      amount = pack * rate;
    } else {
      amount = 0;
    }

    amountController.text = amount.toStringAsFixed(3);
  }

  lastPurchase() {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      descendantsAreFocusable: false,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*SizedBox(
              child: Column(
                children: [
                  const Text(
                    'Last Purchase Details',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.green),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          width: 80,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Invoice No"))),
                      const SizedBox(width: 10),
                      MySmallTextField(
                        controller: lastInvoiceNoController,
                        readonly: true,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          width: 80,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Date"))),
                      const SizedBox(width: 10),
                      MySmallTextField(
                        controller: lastDateController,
                        readonly: true,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          width: 80,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Rate"))),
                      const SizedBox(width: 10),
                      MySmallTextField(
                        controller: lastRateController,
                        readonly: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),*/
            itemsTable()
          ],
        ),
      ),
    );
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          columnName: 'purchase_date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          columnName: 'invoice_no',
          label: const MyDataGridHeader(title: 'Dc/Inv No'),
        ),
        GridColumn(
          width: 100,
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate'),
        ),
      ],
      source: dataSource,
    );
  }

  _yarnLastPurchase() async {
    var supplierId = controller.supplierId;
    var yarnId = yarnName.value?.id;
    var colorId = colorname.value?.id;

    if (supplierId == null || yarnId == null || colorId == null) {
      return;
    }
    itemList.clear();
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
    lastRateController.text = "0";
    lastDateController.text = "";
    lastInvoiceNoController.text = "";
    rateController.text = "0";

    LastYarnPurchaseDetailsModel? data =
        await controller.lastYarnPurchaseDetails(supplierId, yarnId, colorId);

    lastRateController.text = data?.lastYarnPurchase?.first.rate != null
        ? "${data?.lastYarnPurchase?.first.rate}"
        : '';
    rateController.text = data?.lastYarnPurchase?.first.rate != null
        ? "${data?.lastYarnPurchase?.first.rate}"
        : '0';
    lastDateController.text = data?.lastYarnPurchase?.first.purchaseDate != null
        ? "${data?.lastYarnPurchase?.first.purchaseDate}"
        : '';
    lastInvoiceNoController.text =
        data?.lastYarnPurchase?.first.invoiceNo != null
            ? "${data?.lastYarnPurchase?.first.invoiceNo}"
            : '';

    data?.lastRate?.forEach((e) {
      var request = e.toJson();
      itemList.add(request);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
    });
  }
}

class ItemDataSource extends DataGridSource {
  ItemDataSource({required List<dynamic> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<dynamic> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(
            columnName: 'purchase_date', value: e['purchase_date']),
        DataGridCell<dynamic>(columnName: 'invoice_no', value: e['invoice_no']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          dataGridCell.value.toString(),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
