import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/trasaction/product_sale/add_product_sales.dart';
import 'package:abtxt/view/trasaction/product_sale/product_sale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/ProductInfoModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyElevatedButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../../widgets/my_search_field/my_search_field.dart';

class ProductSalesBottomSheet extends StatefulWidget {
  final ProductSalesItemDataSource dataSource;
  final Function taxCalculation;
  final RxDouble amount;

  const ProductSalesBottomSheet({
    super.key,
    required this.dataSource,
    required this.taxCalculation,
    required this.amount,
  });

  @override
  State<ProductSalesBottomSheet> createState() =>
      _WeavingItemBottomSheetState();
}

class _WeavingItemBottomSheetState extends State<ProductSalesBottomSheet> {
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController rateController = TextEditingController(text: "0.00");
  TextEditingController discountAmountController =
      TextEditingController(text: "0.00");
  TextEditingController discountPercentageController =
      TextEditingController(text: "0");
  TextEditingController amountController = TextEditingController(text: "0.00");
  TextEditingController detailsController = TextEditingController();

  final FocusNode _productFocusNode = FocusNode();
  final FocusNode _qtyFocusNode = FocusNode();

  var productStock = RxString("0");
  var designNo = RxString("");

  final _formKey = GlobalKey<FormState>();
  ProductSaleController controller = Get.find();
  var lasSalesDetails = <dynamic>[];
  late ItemDataSource lastSaleDataSource;

  @override
  void initState() {
    super.initState();
    lastSaleDataSource = ItemDataSource(list: lasSalesDetails);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductSaleController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: const Text('Add Item Product Sales'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Get.back(),
          ),
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () => Get.back()),
            SaveIntent: SetCounterAction(perform: () => submit()),
          },
          child: FocusScope(
            autofocus: true,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              MySearchField(
                                width: 350,
                                label: "Product Name",
                                items: controller.productName,
                                textController: productNameController,
                                focusNode: _productFocusNode,
                                requestFocus: _qtyFocusNode,
                                onChanged: (ProductInfoModel item) {
                                  productName.value = item;
                                  _productStockDetails(item.id);
                                  _lastOrderDetails();
                                },
                              ),
                              Obx(
                                () => Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Product Stock : ${productStock.value}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      const SizedBox(width: 30),
                                      Text(
                                        designNo.value,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              MyTextField(
                                controller: qtyController,
                                focusNode: _qtyFocusNode,
                                hintText: "Quantity",
                                validate: "number",
                                onChanged: (value) {
                                  amountCalculation();
                                },
                                suffix: const Text(
                                  "Saree",
                                  style: TextStyle(color: Color(0xFF5700BC)),
                                ),
                              ),
                              Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  controller: rateController,
                                  hintText: "Rate",
                                  validate: "double",
                                  onChanged: (value) {
                                    amountCalculation();
                                  },
                                ),
                                onFocusChange: (hasFocus) {
                                  AppUtils.fractionDigitsText(
                                    rateController,
                                    fractionDigits: 2,
                                  );
                                },
                              ),
                              Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  controller: discountPercentageController,
                                  hintText: "Discount Percentage",
                                  onChanged: (value) {
                                    amountCalculation();
                                  },
                                ),
                                onFocusChange: (hasFocus) {
                                  AppUtils.fractionDigitsText(
                                    discountPercentageController,
                                    fractionDigits: 2,
                                  );
                                },
                              ),
                              Focus(
                                skipTraversal: true,
                                child: MyTextField(
                                  enabled: false,
                                  controller: discountAmountController,
                                  hintText: "Discount Amount",
                                  validate: "double",
                                  onChanged: (value) {
                                    amountCalculation();
                                  },
                                ),
                                onFocusChange: (hasFocus) {
                                  AppUtils.fractionDigitsText(
                                    discountAmountController,
                                    fractionDigits: 2,
                                  );
                                },
                              ),
                              MyTextField(
                                controller: amountController,
                                hintText: "Amount",
                                enabled: false,
                              ),
                              MyTextField(
                                controller: detailsController,
                                hintText: "Details",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MyElevatedButton(
                        message: "",
                        onPressed: () => submit(),
                        child: const Text('ADD'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Last Sale Details"),
                    const SizedBox(height: 6),
                    itemsTable()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget itemsTable() {
    return MySFDataGridItemTable(
      shrinkWrapRows: false,
      scrollPhysics: const ScrollPhysics(),
      columns: [
        GridColumn(
          width: 130,
          columnName: 'date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          columnName: 'qty',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          width: 100,
          columnName: 'rate',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Rate'),
        ),
        GridColumn(
          width: 140,
          columnName: 'amount',
          label: const MyDataGridHeader(
              alignment: Alignment.center, title: 'Amount'),
        ),
      ],
      source: lastSaleDataSource,
    );
  }

  Future submit() async {
    if (_formKey.currentState!.validate()) {
      int qty = int.tryParse(qtyController.text) ?? 0;
      double amount = double.tryParse(amountController.text) ?? 0.0;

      for (var e in controller.itemList) {
        if (e["product_id"] == productName.value?.id) {
          return AppUtils.infoAlert(message: "This Product Already added");
        }
      }

      if (qty == 0) {
        return AppUtils.infoAlert(message: "The entered quantity is '0'");
      }

      if (amount == 0) {
        return AppUtils.infoAlert(message: "The entered amount is '0'");
      }
      var request = {
        "product_name": productName.value?.productName,
        "product_id": productName.value?.id,
        "qty": qty,
        "rate": double.tryParse(rateController.text) ?? 0.0,
        "amount": amount,
        "details": detailsController.text,
        "discount": double.tryParse(discountAmountController.text) ?? 0.0,
        "discount_per": double.tryParse(discountPercentageController.text) ?? 0.0,
      };

      controller.getBackBoolean.value = true;
      controller.itemList.add(request);
      taxAmountCalculation();
      widget.dataSource.updateDataGridRows();
      widget.dataSource.updateDataGridSource();
      controllerClear();
    }
  }

  void taxAmountCalculation() {
    double total = 0;
    for (var element in controller.itemList) {
      total += element['amount'];
    }

    widget.amount.value = total;

    /// calculate the tax amount in add page
    widget.taxCalculation();
  }

  void amountCalculation() {
    int qty = int.tryParse(qtyController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0.0;
    double discountAmount = 0.0;
    double discountPercentage =
        double.tryParse(discountPercentageController.text) ?? 0.0;
    double amount = 0.0;
    double total = qty * rate;

    discountAmount = (total * discountPercentage) / 100;

    amount = total - discountAmount;

    discountAmountController.text = discountAmount.toStringAsFixed(2);
    amountController.text = amount.toStringAsFixed(2);
  }

  void _lastOrderDetails() async {
    var customerId = controller.customerId;
    var productId = productName.value?.id;

    if (customerId == null || productId == null) {
      return;
    }

    lasSalesDetails.clear();
    lastSaleDataSource.updateDataGridRows();
    lastSaleDataSource.updateDataGridSource();

    var data = await controller.lastYarnPurchaseDetails(productId, customerId);

    data?.forEach((e) {
      lasSalesDetails.add(e);
      lastSaleDataSource.updateDataGridRows();
      lastSaleDataSource.updateDataGridSource();
    });

    if (lasSalesDetails.isNotEmpty) {
      rateController.text = "${lasSalesDetails.last["rate"] ?? 0.0}";
    } else {
      rateController.text = "0.00";
    }
  }

  void controllerClear() {
    productStock.value = "0";
    productName.value = null;
    productNameController.text = "";
    qtyController.text = "0";
    rateController.text = "0.00";
    amountController.text = "0.00";
    detailsController.text = "";
    discountAmountController.text = "0.00";
    discountPercentageController.text = "0";

    FocusScope.of(context).requestFocus(_productFocusNode);
  }

  Future<void> _productStockDetails(int? id) async {
    int orderQty = 0;
    var result = await controller.productStockBalance(id);

    int productQty = int.tryParse("$result") ?? 0;
    var ll = controller.itemList.where((e) => e['product_id'] == id).toList();
    for (var element in ll) {
      orderQty += int.tryParse("${element['qty']}") ?? 0;
    }

    productStock.value = "${productQty - orderQty}";
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
        DataGridCell<dynamic>(columnName: 'e_date', value: e['e_date']),
        DataGridCell<dynamic>(columnName: 'qty', value: e['qty']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e['amount']),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      double value = double.tryParse('${dataGridCell.value}') ?? 0;
      final columnName = dataGridCell.columnName;
      switch (columnName) {
        case 'amount':
          return buildFormattedCell(value, decimalPlaces: 2);
        case 'rate':
          return buildFormattedCell(value, decimalPlaces: 2);
        default:
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dataGridCell.value != null ? '${dataGridCell.value}' : '',
              style: AppUtils.cellTextStyle(),
            ),
          );
      }
    }).toList());
  }

  Widget buildFormattedCell(dynamic value, {int decimalPlaces = 2}) {
    if (value is num) {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        decimalDigits: decimalPlaces,
        name: '',
      );
      return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatter.format(value),
          style: AppUtils.cellTextStyle(),
        ),
      );
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '$value' : '',
        style: AppUtils.cellTextStyle(),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
