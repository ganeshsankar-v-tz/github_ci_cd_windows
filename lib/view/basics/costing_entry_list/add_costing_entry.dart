import 'dart:convert';
import 'dart:io';

import 'package:abtxt/model/CostingEntryModel.dart';
import 'package:abtxt/model/ProductInfoModel.dart';
import 'package:abtxt/view/basics/costing_entry_list/costing_entry_bottomsheet.dart';
import 'package:abtxt/view/basics/costing_entry_list/costing_entry_controller.dart';
import 'package:abtxt/view/basics/productinfo/product_info.dart';
import 'package:abtxt/widgets/AddItemsElevatedButton.dart';
import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keymap/keymap.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyAutoComplete.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyDropdownSearch.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';

class AddCostingEntry extends StatefulWidget {
  const AddCostingEntry({Key? key}) : super(key: key);
  static const String routeName = '/AddCostingEntry';

  @override
  State<AddCostingEntry> createState() => _State();
}

class _State extends State<AddCostingEntry> {
  TextEditingController idController = TextEditingController();
  Rxn<ProductInfoModel> productName = Rxn<ProductInfoModel>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController designNo = TextEditingController();
  TextEditingController recordNoController = TextEditingController();
  TextEditingController singleUnitCostController = TextEditingController();
  TextEditingController recordNo = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noofUnitsController = TextEditingController();
  TextEditingController profitController = TextEditingController();
  TextEditingController profitAmountController = TextEditingController();
  TextEditingController totalProfitAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late CostingEntryController controller;
  // var CostingEntryList = <dynamic>[].obs;
   FocusNode _designNoFocusNode =  FocusNode();

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;

  /// Pdf
  late CostingEntryModel model;
  late pw.Image image1;
  int pdfItemIndex = 0;

  @override
  void initState() {
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CostingEntryController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyN,
            'Add',
            () => _addItem(),
            isControlPressed: true,
          ),
          KeyAction(
            LogicalKeyboardKey.keyA,
            'New',
                () => Get.toNamed(ProductInfo.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Costing Entry"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(

             // margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          border: Border.all(color: Color(0xFFF9F3FF), width: 12),
                        ),
                        //color: Colors.green,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Visibility(
                                  visible: false,
                                  child: MyTextField(
                                    controller: idController,
                                    hintText: "ID",
                                    validate: "",
                                    enabled: false,
                                  ),
                                ),
                                MyAutoComplete(
                                  label: 'Product Name',
                                  items: controller.productDropdown,
                                  selectedItem: productName.value,
                                  onChanged: (ProductInfoModel item) {
                                    productName.value = item;
                                  },
                                ),
                                MyTextField(
                                  focusNode: _designNoFocusNode,
                                  controller: designNo,
                                  hintText: "Design",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: noofUnitsController,
                                  hintText: "No of Units",
                                  validate: "number",
                                ),
                                MyDateField(
                                  controller: dateController,
                                  hintText: "Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: groupController,
                                  hintText: "Group",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: singleUnitCostController,
                                  hintText: "Single Unit Cost (Rs)",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: recordNo,
                                  hintText: "Record No",
                                  validate: "number",
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: AddItemsElevatedButton(
                                width: 135,
                                onPressed: () async {
                                  _addItem();
                                },
                                child: const Text('Add Item'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ItemsTable(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: profitController,
                                  hintText: "Profit",
                                  validate: "double",
                                  suffix: const Text(
                                    "%",
                                    style: TextStyle(color: Color(0xff5700BC)),
                                  ),
                                  onChanged: (val) => singleUnitCost(),
                                ),
                                MyTextField(
                                  controller: profitAmountController,
                                  hintText: "",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: totalProfitAmountController,
                                  hintText: "",
                                  readonly: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: false,
                                  child: ElevatedButton(onPressed:
                                      ()=> Get.toNamed(ProductInfo.routeName)
                                      , child: Text('New')),
                                ),
                                Visibility(
                                  visible: Get.arguments != null,
                                  child: IconButton(
                                      onPressed: () => costingReportPdf(),
                                      icon: const Icon(Icons.print)),
                                ),
                                MyCloseButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 200,
                                  child: MyElevatedButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    child: Text(
                                        "${Get.arguments == null ? 'Save' : 'Update'}"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "product_id": productName.value?.id,
        "design_no": designNo.text,
        "noofunits": int.parse(noofUnitsController.text),
        "date": dateController.text,
        "group_id": productName.value?.groupId,
        "sgl_unit_cost":
            double.parse(singleUnitCostController.text.replaceAll(",", "")),
        "record_no": recordNo.text,
        "profit": profitController.text,
        "net_total": double.tryParse(
            totalProfitAmountController.text.replaceAll(",", "")),
      };
      dynamic totalQty = 0;
      double totalAmount = 0;
      // double totalRuning = 0;
      var costingItemList = [];
      for (var i = 0; i < itemList.length; i++) {
        var item = {
          'header': itemList[i]['header'],
          'details': itemList[i]['details'],
          'quantity': itemList[i]['quantity'],
          'unit_id': itemList[i]['unit'],
          'rate': itemList[i]['rate'],
          'amount': itemList[i]['amount'],
          'running_total': itemList[i]['running_total'],
        };
        costingItemList.add(item);

        totalQty += itemList[i]["quantity"];
        totalAmount += itemList[i]["amount"];
      }
      request['costing_items'] = costingItemList;
      request['total_qty'] = totalQty;
      request['total_amount'] = totalAmount;

      print(jsonEncode(request));
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = id;
        print(jsonEncode(request));
        controller.edit(request);
      }
    }
  }

  void _initValue() {
    if (Get.arguments != null) {
      CostingEntryController controller = Get.find();
      CostingEntryModel item = Get.arguments['item'];
      model = item;
      idController.text = '${item.id}';
      designNo.text = '${item.designNo}';
      noofUnitsController.text = '${item.noofunits}';
      dateController.text = '${item.date}';
      singleUnitCostController.text = '${item.sglUnitCost}';
      recordNo.text = '${item.recordNo}';
      groupController.text = '${item.groupName}';
      profitController.text = '${item.profit}';

      var productId = controller.productDropdown
          .where((element) => '${element.id}' == '${item.productId}')
          .toList();
      if (productId.isNotEmpty) {
        productName.value = productId.first;
        productNameController.text = "${productId.first.productName}";
      }

      item.productDetails?.forEach((element) {
        var request = {
          "header": element.header,
          "details": element.details,
          "quantity": element.quantity,
          "unit_name": element.unitName,
          "unit": element.unitId,
          "rate": element.rate,
          "amount": element.amount,
          "running_total": element.runningTotal,
        };
        itemList.add(request);
      });
    }
    // initTotal();
    singleUnitCost();
  }

/*  void initTotal() {
    double amountTotal = 0.0;

    double netQtyTotal = 0.0;
    //   double runningTotal = 0.0;

    for (var i = 0; i < itemList.length; i++) {
      netQtyTotal += itemList[i]['quantity'] ?? 0.0;
      amountTotal += itemList[i]['amount'] ?? 0.0;
      // runningTotal += CostingEntryList[i]['running_total'] ?? 0.0;
    }
    // runningtotalController.text = '$runningTotal';
  }*/

  void singleUnitCost() {
    double totalAmount = 0;
    double profitPercentage = double.tryParse(profitController.text) ?? 0;
    double profit = 0;
    double totalProfit = 0;
    double singleUnitCost = 0;
    int noOfUnits = int.tryParse(noofUnitsController.text) ?? 0;

    for (var i = 0; i < itemList.length; i++) {
      totalAmount += itemList[i]["amount"];
    }
    profit = profitPercentage * totalAmount / 100;
    totalProfit = profit + totalAmount;
    singleUnitCost = totalProfit / noOfUnits;
    profitAmountController.text =
        formatAsRupees(double.tryParse(profit.toStringAsFixed(2)) ?? 0);
    totalProfitAmountController.text =
        formatAsRupees(double.tryParse(totalProfit.toStringAsFixed(2)) ?? 0);
    singleUnitCostController.text =
        formatAsRupees(double.tryParse(singleUnitCost.toStringAsFixed(2)) ?? 0);
  }

  String formatAsRupees(double value) {
    var formatter = NumberFormat.currency(locale: 'en_IN', symbol: '');
    return formatter.format(value);
  }

  /// Pdf Design

  void costingReportPdf() async {
    final file = File('D:/Product Costing Report.pdf');

    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      orientation: pw.PageOrientation.portrait,
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      build: (pw.Context context) {
        return [
          pw.Container(
              width: PdfPageFormat.a4.portrait.width,
              height: PdfPageFormat.a4.portrait.height,
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [getPdfPage()])),
        ];
      },
    ));

    // Write to the file
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File saved at ${file.path}'),
      ),
    );
    OpenAppFile.open(file.absolute.path);
  }

  getPdfPage() {
    pw.TextStyle contentStyle =
        const pw.TextStyle(color: PdfColors.black, fontSize: 10);
    pw.TextStyle headerStyle = pw.TextStyle(
        color: PdfColors.black, fontSize: 10, fontWeight: pw.FontWeight.bold);
    DateTime now = DateTime.now();
    String formattedDate = getFormatedDate(now);
    return pw.Expanded(
        child: pw.Container(
      height: PdfPageFormat.a4.height,
      width: PdfPageFormat.a4.width,
      child: pw.Column(children: [
        pw.Row(children: [
          pw.Text("Product - Costing Report",
              style: pw.TextStyle(
                  color: PdfColors.green, fontWeight: pw.FontWeight.bold))
        ]),
        pw.SizedBox(height: 15),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
          pw.Row(children: [
            pw.Text("Product Name : ", style: contentStyle),
            pw.Text(" ${model.productName}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ]),
          pw.Row(children: [
            pw.Text("Design No :", style: contentStyle),
            pw.Text("${model.designNo}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ]),
          pw.Row(children: [
            pw.Text("No Of Units :", style: contentStyle),
            pw.Text("${model.noofunits}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ])
        ]),
        pw.SizedBox(height: 15),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Row(children: [
            pw.Text("Single Unit Cost (Rs) :", style: contentStyle),
            pw.Text("${model.sglUnitCost}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ]),
          pw.Row(children: [
            pw.Text("Group :", style: contentStyle),
            pw.Text("${model.groupName}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ]),
          pw.Row(children: [
            pw.Text("Date :", style: contentStyle),
            pw.Text("${model.date}",
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
          ]),
        ]),
        pw.SizedBox(height: 15),

        /// Table
        pw.Expanded(
            child: pw.Container(
                height: 250,
                width: double.infinity,
                child: pw.Stack(children: [
                  pw.Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: pw.Column(children: [
                        /// Header
                        pw.Container(
                            decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("#C5C5C5"),
                                border: pw.Border.all(
                                    width: 1, color: PdfColors.black)),
                            child: pw.Row(children: [
                              pw.Container(
                                width: 100,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child:
                                        pw.Text("Header", style: headerStyle)),
                              ),
                              pw.Container(
                                width: 120,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child:
                                        pw.Text("Details", style: headerStyle)),
                              ),
                              pw.Container(
                                width: 60,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child: pw.Text("Qty", style: headerStyle)),
                              ),
                              pw.Container(
                                width: 50,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child: pw.Text("Unit", style: headerStyle)),
                              ),
                              pw.Container(
                                width: 65,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child: pw.Text("    Rate / \nWages (Rs)",
                                        style: headerStyle)),
                              ),
                              pw.Container(
                                width: 65,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child: pw.Text("Amount\n   (Rs)",
                                        style: headerStyle)),
                              ),
                              pw.Container(
                                width: 75,
                                height: 30,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        right: pw.BorderSide(
                                            width: 1, color: PdfColors.black),
                                        left: pw.BorderSide(
                                            width: 1, color: PdfColors.black))),
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Center(
                                    child: pw.Text("Running \n   Total",
                                        style: headerStyle)),
                              ),
                            ])),

                        for (int i = 0; i < model.productDetails!.length; i++)
                          pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      width: 1, color: PdfColors.black)),
                              child: pw.Row(children: [
                                pw.Container(
                                  width: 100,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          model.productDetails![i].header
                                              .toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 120,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          model.productDetails![i].details
                                              .toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 60,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                          model.productDetails![i].quantity
                                              .toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 50,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          model.productDetails![i].unitName
                                              .toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 65,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                          formatAsRupees(double.tryParse(model
                                                  .productDetails![i].rate
                                                  .toString()) ??
                                              0),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 65,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                          formatAsRupees(double.tryParse(model
                                                  .productDetails![i].amount
                                                  .toString()) ??
                                              0),
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              fontWeight: pw.FontWeight.bold))),
                                ),
                                pw.Container(
                                  width: 75,
                                  height: 22,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1, color: PdfColors.black),
                                          left: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text("", style: contentStyle)),
                                ),
                              ])),

                        /// Total Value
                        pw.Container(
                            height: 25,
                            width: double.infinity,
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                    color: PdfColors.black, width: 1)),
                            child: pw.Row(children: [
                              pw.Container(
                                  width: 395,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.end,
                                      children: [
                                        pw.Text("Profit : ",
                                            style: contentStyle),
                                        pw.Text(
                                            "${double.tryParse(model.profit!.toString()) ?? 0}  %",
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 10))
                                      ])),
                              pw.Container(
                                  width: 65,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                          profitAmountController.text,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 10)))),
                              pw.Container(
                                  width: 75,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          right: pw.BorderSide(
                                              width: 1,
                                              color: PdfColors.black))),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text("",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 10)))),
                            ]))
                      ])),
                ]))),
      ]),
    ));
  }

  String getFormatedDate(DateTime now) {
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    return '$day-$month-$year';
  }

  Widget ItemsTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'header',
          label: const MyDataGridHeader(title: 'Header'),
        ),
        GridColumn(
          columnName: 'details',
          label: const MyDataGridHeader(title: 'Details'),
        ),
        GridColumn(
          columnName: 'quantity',
          label: const MyDataGridHeader(title: 'Quantity'),
        ),
        GridColumn(
          columnName: 'unit',
          label: const MyDataGridHeader(title: 'Units'),
        ),
        GridColumn(
          columnName: 'rate',
          label: const MyDataGridHeader(title: 'Rate/Wages'),
        ),
        GridColumn(
          columnName: 'amount',
          label: const MyDataGridHeader(title: 'Amount'),
        ),
        GridColumn(
          columnName: 'running_total',
          label: const MyDataGridHeader(title: 'Running Total'),
        ),
      ],
      tableSummaryRows: [
        GridTableSummaryRow(
          showSummaryInRow: false,
          title: 'Total: ',
          titleColumnSpan: 1,
          columns: [
            const GridSummaryColumn(
              name: 'amount',
              columnName: 'amount',
              summaryType: GridSummaryType.sum,
            ),
          ],
          position: GridTableSummaryRowPosition.bottom,
        ),
      ],
      source: dataSource,
      onRowSelected: (index) async {
        var item = itemList[index];
        var result = await Get.to(const CostingEntryBottomSheet(),
            arguments: {'item': item});
        if (result['item'] == 'delete') {
          itemList.removeAt(index);
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        } else if (result != null) {
          itemList[index] = result;
          dataSource.updateDataGridRows();
          dataSource.updateDataGridSource();
        }
      },
    );
  }

  void _addItem() async {
    var result = await Get.to(CostingEntryBottomSheet());
    if (result != null) {
      itemList.add(result);
      dataSource.updateDataGridRows();
      dataSource.updateDataGridSource();
      singleUnitCost();
    }
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
        DataGridCell<dynamic>(columnName: 'header', value: e['header']),
        DataGridCell<dynamic>(columnName: 'details', value: e['details']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        // DataGridCell<dynamic>(columnName: 'unitName', value: e['unitName']),
        DataGridCell<dynamic>(columnName: 'unit', value: e['unit_name']),
        DataGridCell<dynamic>(columnName: 'rate', value: e['rate']),
        DataGridCell<dynamic>(columnName: 'amount', value: e["amount"]),
        DataGridCell<dynamic>(
            columnName: 'running_total', value: e['running_total']),
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
        child: Text(dataGridCell.value != null ? '${dataGridCell.value}': ''),
      );
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '${summaryValue}',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
