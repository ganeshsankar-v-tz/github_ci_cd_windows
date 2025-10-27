import 'dart:convert';

import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../utils/constant.dart';
import '../../../widgets/MyDropdownButtonFormField.dart';
import '../../../widgets/MyTextField.dart';
import 'job_work_controller.dart';

class AddJobWork extends StatefulWidget {
  const AddJobWork({Key? key}) : super(key: key);
  static const String routeName = '/AddJobWork';

  @override
  State<AddJobWork> createState() => _State();
}

class _State extends State<AddJobWork> {
  TextEditingController WorkerController = TextEditingController();
  TextEditingController LotController = TextEditingController();
  TextEditingController RecordController = TextEditingController();
  TextEditingController FirmContoller = TextEditingController();
  TextEditingController DetailsController = TextEditingController();

  var dyername = false.obs;
  var Entrytype = false.obs;
  var Yarnname = false.obs;
  var colorname = false.obs;

  final _formKey = GlobalKey<FormState>();
  late JobWorkController controller;
  var additemjobwork = <dynamic>[].obs;

  @override
  void initState() {
    WorkerController.text = "01";
    LotController.text = "3";
    RecordController.text = "15/05/2023";
    FirmContoller.text = "1";
    DetailsController.text = "White";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobWorkController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close', () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text("${Get.arguments == null ? 'Add' : 'Update'} Job Work"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        //color: Colors.green,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                MyDropdownButtonFormField(
                                  controller: WorkerController,
                                  hintText: "Job Worker Name",
                                  items: Constants.Processor,
                                ),
                                MyTextField(
                                  controller: LotController,
                                  hintText: "Lot",
                                  validate: 'number',
                                ),
                                MyTextField(
                                  controller: RecordController,
                                  hintText: "Record No",
                                  validate: "number",
                                ),
                                MyDropdownButtonFormField(
                                  controller: FirmContoller,
                                  hintText: "Firm ",
                                  items: Constants.firm,
                                ),
                                MyTextField(
                                  controller: DetailsController,
                                  hintText: "Details",
                                  validate: "number&String",
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                iconSize: 42,
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  var result = await jobworkDialogue();
                                  print("result: ${result.toString()}");
                                  if (result != null) {
                                    additemjobwork.add(result);
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: Get.width,
                              color: Color(0xFFF4F2FF),
                              child: addjobworklist(),
                            ),
                            SizedBox(height: 48),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 200,
                                  child: MyElevatedButton(
                                    color: Colors.red,
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 200,
                                  child: MyElevatedButton(
                                    onPressed: () => submit(),
                                    child: Text(
                                        "${Get.arguments == null ? 'Add' : 'Update'}"),
                                  ),
                                ),
                              ],
                            )
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

  submit() {
    if (_formKey.currentState!.validate()) {
      var request = {
        "Dyername": WorkerController.text,
        "DcNo": LotController.text,
        "EntryDate": RecordController.text,
        "Details": FirmContoller.text,
        "EntryType": RecordController.text,
        "ColorName": DetailsController.text,
        "tin_no": "1234",
        "cst_no": "1234",
        "area_id": 1,
        "city_id": 1,
        "country_id": 1,
        "s_warp": dyername.value,
        "s_yarn": Entrytype.value,
        "s_saree": Yarnname.value,
        "Color": colorname.value,
        "agentName": "1234",
      };

      print(jsonEncode(request));

      controller.addLedger(request);
    }
  }

  Widget addjobworklist() {
    return Obx(() => DataTable(
          onSelectAll: (b) {},
          sortColumnIndex: 0,
          sortAscending: true,
          columns: const <DataColumn>[
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Entry Type")),
            DataColumn(label: Text("Particulars")),
            DataColumn(label: Text("Delivered Quantity")),
            DataColumn(label: Text("Received Quantity")),
            DataColumn(label: Text("Wages (Rs)")),
            DataColumn(label: Text("Action")),
          ],
          rows: additemjobwork.map((user) {
            return DataRow(
              cells: [
                DataCell(Text('${user['Date']}')),
                DataCell(Text('${user['Entry Type']}')),
                DataCell(Text('${user['Particulars']}')),
                DataCell(Text('${user['Delivered Quantity']}')),
                DataCell(Text('${user['Received Quantity']}')),
                DataCell(Text('${user['Wages (Rs)']}')),
                DataCell(
                  IconButton(
                    iconSize: 24,
                    icon: Image.asset('assets/images/ic_delete1.png', width: 18),
                    onPressed: () {
                      additemjobwork.remove(user);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ));
  }

  dynamic jobworkDialogue() async {
    TextEditingController jobController = TextEditingController();
    TextEditingController lotController = TextEditingController();
    TextEditingController RecordController = TextEditingController();
    TextEditingController firmController = TextEditingController();
    TextEditingController accountController = TextEditingController();
    TextEditingController transactionController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    jobController.text = Constants.Processor[0];
    firmController.text = Constants.Firm[0];
    accountController.text = Constants.Account[0];
    transactionController.text = Constants.Trasaction[0];

    final _formKey = GlobalKey<FormState>();

    submit() {}

    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxWidth: 800,
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.90,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Item',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Wrap(
                      children: [
                        MyDropdownButtonFormField(
                          controller: jobController,
                          hintText: "Job Worker Name",
                          items: Constants.Processor,
                        ),
                        MyTextField(
                          controller: lotController,
                          hintText: 'Lot',
                          validate: 'number',
                        ),
                        MyTextField(
                          controller: RecordController,
                          hintText: 'Record No',
                          validate: 'number',
                        ),
                        MyDropdownButtonFormField(
                          controller: firmController,
                          hintText: "Firm Name",
                          items: Constants.Firm,
                        ),
                        MyDropdownButtonFormField(
                          controller: accountController,
                          hintText: "Account Type",
                          items: Constants.Account,
                        ),
                        MyDropdownButtonFormField(
                          controller: transactionController,
                          hintText: "Transaction Type",
                          items: Constants.Trasaction,
                        ),
                        MyTextField(
                          controller: detailsController,
                          hintText: 'Details',
                          validate: 'number',
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          submit();
                        },
                        child: Text('ADD'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });

    return result;
  }
}
