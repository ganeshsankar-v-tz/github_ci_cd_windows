import 'dart:io';
import 'package:abtxt/model/report_models/FinishedWarpsModel.dart';
import 'package:abtxt/model/report_models/WeavingWarpReportModel.dart';
import 'package:abtxt/view/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../model/LedgerModel.dart';
import '../../model/LoomModel.dart';
import '../../model/WeavingAccount.dart';
import '../../utils/constant.dart';
import '../../widgets/MyDataGridHeader.dart';
import '../../widgets/MyDialogList.dart';
import '../../widgets/MyDropdownButtonFormField.dart';
import '../../widgets/MySFDataGridItemTable.dart';

class Weaving_Report extends StatefulWidget {
  const Weaving_Report({super.key});

  @override
  State<Weaving_Report> createState() => _Weaving_ReportState();
}

class _Weaving_ReportState extends State<Weaving_Report> {
  TextEditingController entryTypeController = TextEditingController();

  final RxString _selectedEntryType = RxString(Constants.WEAVING_REPORTS[0]);

  final _formKey = GlobalKey<FormState>();
  final messageReportFormKey = GlobalKey<FormState>();
  final deliveryFormKey = GlobalKey<FormState>();
  final finishedWarpListFormKey = GlobalKey<FormState>();

  /// Pdf
  late FinishedWarpsModel model;
  late pw.Image image1;
  int pdfItemIndex = 0;

  //Message Report
  TextEditingController weaverController = TextEditingController();
  ReportController controller = Get.put(ReportController());
  List<WeavingAccount> weavingList = [];
  TextEditingController loomController = TextEditingController();

  //Finished Warp List
  var finishedList = <FinishedWarpsModel>[];
  late FinishedWarpsDataSource dataSource;

  /// Warp Report
  var warpRepost = <WeavingWarpReportModel>[];
  late WarpReport warpRepostDataSource;

  //Report Data table

  @override
  void initState() {
    // print("model values :  ${model}");
    _initValue();
    super.initState();
    dataSource = FinishedWarpsDataSource(list: finishedList);
    warpRepostDataSource = WarpReport(list: warpRepost);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Reports Screen')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                          child: Wrap(
                        children: [
                          MyDropdownButtonFormField(
                            hintText: "Entry Type",
                            items: Constants.WEAVING_REPORTS,
                            controller: entryTypeController,
                            onChanged: (value) {
                              _selectedEntryType.value = value;
                            },
                          ),
                        ],
                      )),
                      // SizedBox(
                      //   width: 200,
                      // ),
                      Obx(() => widgetByEntryType(_selectedEntryType.value))
                    ],
                  ),
                ),
              ),
              // Flexible(flex: 2, child: ReportDataTable()),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetByEntryType(String option) {
    if (option == 'Warp Notification Report') {
      return Form(
        key: messageReportFormKey,
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Warp Natification Report"),
                IconButton(
                    onPressed: () => warpNotificationPdf(),
                    icon: const Icon(Icons.print))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            MyDialogList(
              labelText: 'Weaver',
              controller: weaverController,
              list: controller.weaverList,
              onItemSelected: (LedgerModel item) {
                weaverController.text = '${item.ledgerName}';
                controller.request['weaver_id'] = item.id;
                _initValue();
                controller.fetchLoomInfo(item.id);
              },
              onCreateNew: (value) async {},
            ),
            MyDialogList(
              labelText: 'Loom',
              controller: loomController,
              list: controller.loomList,
              onItemSelected: (LoomModel item) async {
                loomController.text = '${item.subWeaverNo}';
                controller.request['loom_id'] = item.subWeaverNo;
                // initWeavingAccount();
                warpReport();
              },
              onCreateNew: (value) async {},
            ),
            const SizedBox(
              height: 20,
            ),
            warpRepostTable()
          ],
        ),
      );
    } else if (option == 'Message Report') {
      return Form(
        key: deliveryFormKey,
        child: Wrap(
          children: [Text('Message Report')],
        ),
      );
    } else if (option == 'Finished Warp List') {
      return Form(
        key: finishedWarpListFormKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Finished Warp List'),
                IconButton(
                    onPressed: () {
                      finishedWarpPdf();
                    },
                    icon: const Icon(Icons.print))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            finishedWarpDataTable()
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  submit() {
    var entryType = _selectedEntryType.value.toString();

    if (entryType == "Message Report") {
      if (_formKey.currentState!.validate()) {
        if (messageReportFormKey.currentState!.validate()) {
          Map<String, dynamic> request = {
            "entry_type": entryType,
            //   "delivery_yarn_name": deliveryYarnname.value?.name,
          };
          Get.back(result: request);
        }
      }
    }
  }

  Future<void> _initValue() async {
    ReportController controller = Get.find();
    entryTypeController.text = Constants.WEAVING_REPORTS[0];
    loomController.text = "";

    /// Finished Warps Api call and add a value in data table
    var result = await controller.finishedWarps();
    finishedList.clear();
    finishedList.addAll(result);
    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  void initWeavingAccount({var index = 0}) async {
    if (weavingList.isNotEmpty) {
      var weavingAccount = weavingList[index];
      controller.request['weaving_ac_id'] = weavingAccount.id;
      controller.request['product_id'] = weavingAccount.productId;
      controller.request['product_name'] = weavingAccount.productName;
      controller.request['product_design_no'] = weavingAccount.designNo;
      controller.request['product_meter'] = weavingAccount.unitLength;
      controller.request['product_wages'] = weavingAccount.wages;
      // controller.request['weav_no'] = weavingAccount.weavNo;
      controller.request['loom_no'] = weavingAccount.subWeaverNo;
      controller.request['wages'] = weavingAccount.wages;
      controller.request['current_status'] = '${weavingAccount.currentStatus}';
      // firmController.text = '${weavingAccount.firmName}';
      // productController.text = '${weavingAccount.productName}';
      // wagesController.text = '${weavingAccount.wages}';
      // deductionController.text = '${weavingAccount.deductionAmt}';
      // unitLengthController.text = '${weavingAccount.unitLength}';
      // currentStatus.value = "${weavingAccount.currentStatus}";
      // _initLogs();
    }
  }

  void warpReport() async {
    var result = await controller.weavingWarpReports();
    warpRepost.clear();
    warpRepost.addAll(result);
    warpRepostDataSource.updateDataGridRows();
    warpRepostDataSource.updateDataGridSource();
  }

  finishedWarpDataTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'weaver_name',
          label: const MyDataGridHeader(title: 'Weaver Name'),
        ),
        GridColumn(
          columnName: 'loom',
          label: const MyDataGridHeader(title: 'Loom'),
        ),
        GridColumn(
          columnName: 'product_quantity',
          label: const MyDataGridHeader(title: 'Qty'),
        ),
        GridColumn(
          columnName: 'meter_yards',
          label: const MyDataGridHeader(title: 'Meter Yards'),
        ),
        GridColumn(
          columnName: 'received_qty',
          label: const MyDataGridHeader(title: 'Received Qty'),
        ),
        GridColumn(
          columnName: 'received_meter',
          label: const MyDataGridHeader(title: 'Received Meter/Yards'),
        ),
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product Name'),
        ),
        GridColumn(
          columnName: 'weav_no',
          label: const MyDataGridHeader(title: 'Weav No'),
        ),
        GridColumn(
          columnName: 'finished_date',
          label: const MyDataGridHeader(title: 'Finished Date'),
        ),
      ],
      source: dataSource,
    );
  }

  warpRepostTable() {
    return MySFDataGridItemTable(
      columns: [
        GridColumn(
          columnName: 'date',
          label: const MyDataGridHeader(title: 'Date'),
        ),
        GridColumn(
          columnName: 'weaver_name',
          label: const MyDataGridHeader(title: 'Weaver Name'),
        ),
        GridColumn(
          columnName: 'loom',
          label: const MyDataGridHeader(title: 'Loom'),
        ),
        GridColumn(
          columnName: 'product_name',
          label: const MyDataGridHeader(title: 'Product'),
        ),
        GridColumn(
          columnName: 'warp_design',
          label: const MyDataGridHeader(title: 'Weav No'),
        ),
        GridColumn(
          columnName: 'balance_qty',
          label: const MyDataGridHeader(title: 'Balance Qty'),
        ),
        GridColumn(
          columnName: 'notification_status',
          label: const MyDataGridHeader(title: 'Notification Status'),
        ),
      ],
      source: warpRepostDataSource,
    );
  }

  /// Finished Warp List Pdf Design
  void finishedWarpPdf() async {
    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();
    image1 = pw.Image(pw.MemoryImage(imageBytes), width: 50, height: 50);
    // Specify the file name and location
    final file = File('D:/Finished Warp List.pdf');

    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(0),
      build: (pw.Context context) {
        return [
          pw.Container(
              width: PdfPageFormat.a4.landscape.width,
              height: PdfPageFormat.a4.landscape.height,
              padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [finishedWarpPdfDesign()])),
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

  finishedWarpPdfDesign() {
    pw.TextStyle contentStyle =
        const pw.TextStyle(color: PdfColors.black, fontSize: 8);
    pw.TextStyle headerStyle = pw.TextStyle(
        color: PdfColors.black, fontSize: 8, fontWeight: pw.FontWeight.bold);
    int i = 1;
    return pw.Expanded(
        child: pw.Container(
            width: PdfPageFormat.a4.landscape.width,
            height: PdfPageFormat.a4.landscape.height,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Finished Warp List",
                            style: pw.TextStyle(
                                color: PdfColors.green,
                                fontWeight: pw.FontWeight.bold))
                      ]),
                  pw.SizedBox(height: 3),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("All Records",
                            style: pw.TextStyle(
                                color: PdfColors.redAccent,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold))
                      ]),
                  pw.SizedBox(height: 5),
                  pw.Container(
                      height: 50,
                      width: double.infinity,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black, width: 1),
                      ),
                      child: pw.Stack(children: [
                        pw.Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: pw.Column(children: [
                              /// header
                              pw.Container(
                                  decoration: pw.BoxDecoration(
                                      color: PdfColor.fromHex("#C5C5C5"),
                                      border: const pw.Border(
                                          bottom: pw.BorderSide(
                                              color: PdfColors.black,
                                              width: 1))),
                                  child: pw.Row(children: [
                                    pw.Container(
                                      width: 40,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("S.No",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 120,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Weaver Name",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 60,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Loom",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 70,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Warp Id \n    No",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 50,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Qty",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 70,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Metre / \n Yards ",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 60,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text(" Rece \n  Qty",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 80,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("  Rece \n(Mtr/Yrd)",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 120,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Product Name",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 55,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Weav \n  No",
                                              style: headerStyle)),
                                    ),
                                    pw.Container(
                                      width: 70,
                                      height: 25,
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Center(
                                          child: pw.Text("Finished \n   Date",
                                              style: headerStyle)),
                                    ),
                                  ])),

                              /// value display

                              pw.Container(
                                  child: pw.Row(children: [
                                pw.Container(
                                  width: 40,
                                  height: 22,
                                  padding: const pw.EdgeInsets.only(
                                      top: 5, bottom: 5, right: 10),
                                  child: pw.Align(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text((i).toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 120,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text("Ganesh".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 60,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text("1".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 70,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          "model.weaverId!".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 50,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          "model.productQuantity!".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 70,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text("model.meter!".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 60,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          "model.recivedQty"!.toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 80,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          "model.recivedMeter!".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 120,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          "model.productName!".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 55,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text("model.weavNo!".toString(),
                                          style: contentStyle)),
                                ),
                                pw.Container(
                                  width: 70,
                                  height: 22,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Align(
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          "model.finishedDate!".toString(),
                                          style: contentStyle)),
                                ),
                              ])),
                            ])),

                        /// border
                        pw.Container(
                          decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                  width: 1, color: PdfColors.black)),
                          child: pw.Row(children: [
                            pw.Container(
                              width: 40,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                      right: pw.BorderSide(
                                          width: 0.1, color: PdfColors.black),
                                      left: pw.BorderSide(
                                          width: 1, color: PdfColors.black))),
                            ),
                            pw.Container(
                              width: 120,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 60,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 70,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 50,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 70,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 60,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 80,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 120,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 55,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                            pw.Container(
                              width: 70,
                              height: double.infinity,
                              padding: const pw.EdgeInsets.all(5),
                              decoration: const pw.BoxDecoration(
                                  border: pw.Border(
                                left: pw.BorderSide(
                                    width: 1, color: PdfColors.black),
                                right: pw.BorderSide(
                                    color: PdfColors.black, width: 0.6),
                              )),
                            ),
                          ]),
                        ),
                      ])),

                  /// total values
                  pw.Container(
                      decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex("#C5C5C5"),
                          border:
                              pw.Border.all(color: PdfColors.black, width: 1)),
                      child: pw.Stack(children: [
                        pw.Row(children: [
                          pw.Container(
                            width: 290,
                            height: 20,
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                              right: pw.BorderSide(
                                  width: 0.1, color: PdfColors.black),
                            )),
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text("Total", style: headerStyle)),
                          ),
                          pw.Container(
                            width: 50,
                            height: 20,
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                              right: pw.BorderSide(
                                  width: 0.1, color: PdfColors.black),
                            )),
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text("100", style: headerStyle)),
                          ),
                          pw.Container(
                            width: 70,
                            height: 20,
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                              right: pw.BorderSide(
                                  width: 0.1, color: PdfColors.black),
                            )),
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text("200", style: headerStyle)),
                          ),
                        ])
                      ]))
                ])));
  }

  /// Warp Notification Report Pdf Design

  void warpNotificationPdf() async {
    final img = await rootBundle.load('assets/images/logo.png');
    final imageBytes = img.buffer.asUint8List();
    image1 = pw.Image(pw.MemoryImage(imageBytes), width: 50, height: 50);
    // Specify the file name and location
    final file = File('D:/Warp Notification Report.pdf');

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
                  children: [warpNotificationPdfDesign()])),
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

  warpNotificationPdfDesign() {
    pw.TextStyle contentStyle =
        const pw.TextStyle(color: PdfColors.black, fontSize: 8);
    pw.TextStyle contentStyleWithRed =
        const pw.TextStyle(color: PdfColors.red700, fontSize: 8);
    pw.TextStyle headerStyle = pw.TextStyle(
        color: PdfColors.black, fontSize: 8, fontWeight: pw.FontWeight.bold);
    // DateTime now = DateTime.now();
    // String formattedDate = getFormatedDate(now);
    String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
    String hourMinutes = DateFormat.jms().format(DateTime.now());

    return pw.Expanded(
        child: pw.Container(
            height: PdfPageFormat.a4.height,
            width: PdfPageFormat.a4.width,
            child: pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Warp Notification Report",
                        style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColors.green,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text("$formattedDate    $hourMinutes",
                        style: const pw.TextStyle(
                          fontSize: 10,
                        )),
                  ]),
              pw.SizedBox(height: 5),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                pw.Text("Status = Pending",
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.redAccent,
                    ))
              ]),
              pw.SizedBox(height: 5),

              /// Table
              pw.Container(
                  height: 100,
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  child: pw.Stack(children: [
                    /// List Content
                    pw.Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: pw.Column(children: [
                          /// header
                          pw.Container(
                              decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex("#C5C5C5"),
                                  border: const pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColors.black, width: 1))),
                              child: pw.Row(children: [
                                pw.Container(
                                  width: 60,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child:
                                          pw.Text("Date", style: headerStyle)),
                                ),
                                pw.Container(
                                  width: 100,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child: pw.Text("Weaver Name",
                                          style: headerStyle)),
                                ),
                                pw.Container(
                                  width: 40,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child:
                                          pw.Text("Loom", style: headerStyle)),
                                ),
                                pw.Container(
                                  width: 120,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child: pw.Text("Product",
                                          style: headerStyle)),
                                ),
                                pw.Container(
                                  width: 100,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child: pw.Text("Warp Design",
                                          style: headerStyle)),
                                ),
                                pw.Container(
                                  width: 50,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child: pw.Text("Balance \n    Qty",
                                          style: headerStyle)),
                                ),
                                pw.Container(
                                  width: 70,
                                  height: 25,
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Center(
                                      child: pw.Text(
                                          "Notification \n     Status",
                                          style: headerStyle)),
                                ),
                              ])),

                          /// value display
                          pw.Container(
                              child: pw.Row(children: [
                            pw.Container(
                              width: 60,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(("25-01-2024").toString(),
                                      style: contentStyle)),
                            ),
                            pw.Container(
                              width: 100,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(("Ganesh").toString(),
                                      style: contentStyle)),
                            ),
                            pw.Container(
                              width: 40,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(("1").toString(),
                                      style: contentStyle)),
                            ),
                            pw.Container(
                              width: 120,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(
                                      ("Multi Check Saree").toString(),
                                      style: contentStyle)),
                            ),
                            pw.Container(
                              width: 100,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(("400+4100+400").toString(),
                                      style: contentStyle)),
                            ),
                            pw.Container(
                              width: 50,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(("15").toString(),
                                      style: contentStyle)),
                            ),
                            pw.Container(
                              width: 70,
                              height: 22,
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(("Pending").toString(),
                                      style: contentStyle)),
                            ),
                          ]))
                        ])),

                    /// Border

                    pw.Container(
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                                width: 1, color: PdfColors.black)),
                        child: pw.Row(children: [
                          pw.Container(
                            width: 60,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                          pw.Container(
                            width: 100,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                          pw.Container(
                            width: 40,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                          pw.Container(
                            width: 120,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                          pw.Container(
                            width: 100,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                          pw.Container(
                            width: 50,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                          pw.Container(
                            width: 70,
                            height: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            decoration: const pw.BoxDecoration(
                                border: pw.Border(
                                    right: pw.BorderSide(
                                        width: 1, color: PdfColors.black),
                                    left: pw.BorderSide(
                                        width: 1, color: PdfColors.black))),
                          ),
                        ]))
                  ]))
            ])));
  }

  String getFormatedDate(DateTime now) {
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    String mon = now.weekday.toString();

    return '$mon $day-$month-$year';
  }
}

class FinishedWarpsDataSource extends DataGridSource {
  FinishedWarpsDataSource({required List<FinishedWarpsModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<FinishedWarpsModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(columnName: 'loom', value: e.loom),
        DataGridCell<dynamic>(
            columnName: 'product_quantity', value: e.productQuantity),
        DataGridCell<dynamic>(columnName: 'meter_yards', value: e.meter),
        DataGridCell<dynamic>(columnName: 'received_qty', value: e.recivedQty),
        DataGridCell<dynamic>(
            columnName: 'received_meter', value: e.recivedMeter),
        DataGridCell<dynamic>(columnName: 'product_name', value: e.productName),
        DataGridCell<dynamic>(columnName: 'weav_no', value: e.weavNo),
        DataGridCell<dynamic>(
            columnName: 'finished_date', value: e.finishedDate),
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
        child: Text(dataGridCell.value.toString()),
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

class WarpReport extends DataGridSource {
  WarpReport({required List<WeavingWarpReportModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRow = [];
  late List<WeavingWarpReportModel> _list;

  void updateDataGridRows() {
    dataGridRow = _list.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'date', value: e.date),
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(columnName: 'loom', value: e.loom),
        DataGridCell<dynamic>(columnName: 'product_name', value: e.productName),
        DataGridCell<dynamic>(columnName: 'warp_design', value: e.warpName),
        DataGridCell<dynamic>(columnName: 'balance_qty', value: e.remainingQty),
        const DataGridCell<dynamic>(
            columnName: 'notification_status', value: ""),
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
        child: Text(dataGridCell.value.toString()),
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
