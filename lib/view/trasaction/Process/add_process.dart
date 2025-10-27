import 'package:abtxt/view/trasaction/Process/process_bottomsheet.dart';
import 'package:abtxt/view/trasaction/Process/process_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/ProcessPureSilkModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import 'crate_lot_process.dart';

class AddProcess extends StatefulWidget {
  const AddProcess({Key? key}) : super(key: key);
  static const String routeName = '/AddProcess';

  @override
  State<AddProcess> createState() => _State();
}

class _State extends State<AddProcess> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> processerName = Rxn<LedgerModel>();
  TextEditingController LotController = TextEditingController();
  TextEditingController RecordController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  TextEditingController detailsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late ProcessController controller;
  var processList = <dynamic>[].obs;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcessController>(builder: (controller) {
      this.controller = controller;
      return KeyboardWidget(
        bindings: [
          KeyAction(
            LogicalKeyboardKey.keyQ,
            'Close',
            () => Get.back(),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          backgroundColor: Color(0xFFF9F3FF),
          appBar: AppBar(
            elevation: 0,
            title: Text("${idController.text == '' ? 'Add' : 'Update'} Process"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
              ),
              //height: Get.height,
              margin: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   "Processor Name",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w600,
                            //       color: Colors.black87),
                            // ),
                            Container(
                              width: 240,
                              padding: EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                value: processerName.value,
                                items: controller.ledgerDropdown
                                    .map((LedgerModel item) {
                                  return DropdownMenuItem<LedgerModel>(
                                    value: item,
                                    child: Text(
                                      '${item.ledgerName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (LedgerModel? value) {
                                  processerName.value = value;
                                },
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    border: OutlineInputBorder(),
                                    hintText: '',
                                    labelText: 'Processor Name'),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        MyTextField(
                          controller: LotController,
                          hintText: "Lot",
                          validate: "string",
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 17.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                var result = await CreateLotDialoge(context);
                                print("result: ${result.toString()}");
                                if (result != null) {
                                  processList.add(result);
                                }
                              },
                              splashColor: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              child: Ink(
                                width: 140,
                                height: 30,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFDCFFDB),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 0.20, color: Color(0xFF00DE16)),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        ' Create Lot',
                                        style: TextStyle(
                                          color: Color(0xFF202020),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MyTextField(
                          controller: RecordController,
                          hintText: "Record No",
                          validate: "number",
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   'Firm',
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w600,
                            //       color: Colors.black87),
                            // ),
                            Container(
                              width: 240,
                              padding: EdgeInsets.all(8),
                              child: DropdownButtonFormField(
                                value: firmName.value,
                                items:
                                    controller.firmName.map((FirmModel item) {
                                  return DropdownMenuItem<FirmModel>(
                                    value: item,
                                    child: Text(
                                      '${item.firmName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (FirmModel? value) {
                                  firmName.value = value;
                                },
                                decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    border: OutlineInputBorder(),
                                    hintText: '',
                                    labelText: 'Firm'),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        MyTextField(
                          controller: detailsController,
                          hintText: "Details",
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: AddItemsElevatedButton(
                        width: 135,
                        onPressed: () async {
                          var result = await processpureDialog();
                          print("result: ${result.toString()}");
                          if (result != null) {
                            processList.add(result);
                          }
                        },
                        child: const Text('Add Item'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: Get.width,
                      color: Color(0xFFF4F2FF),
                      child: returnItems(),
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
                                "${Get.arguments == null ? 'Save' : 'Update'} "),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "processor_id": processerName.value?.id,
        "lot": LotController.text,
        "recored_no": RecordController.text,
        "firm_id": firmName.value?.id,
        "details": detailsController.text ?? '',
        "total_delivered_qty": "1",
        "total_recived_qty": "1",
        "total_wages": "1",
      };

      //  print(jsonEncode(request));
      for (var i = 0; i < processList.length; i++) {
        request['date[$i]'] = processList[i]['date'];
        request['entry_type[$i]'] = processList[i]['entry_type'];
        request['delivered_qty[$i]'] = processList[i]['delivered_qty'];
        request['recived_qty[$i]'] = processList[i]['recived_qty'];
        request['wages[$i]'] = processList[i]['wages'];
        request['particulars[$i]'] = processList[i]['particulars'];
      }
      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        var requestdata = DioFormData.FormData.fromMap(request);
        controller.addProcess(requestdata);
      } else {
        request['id'] = id;
        var requestdata = DioFormData.FormData.fromMap(request);
        controller.updateProcess(requestdata, id);
      }
    }
  }

  void _initValue() {
    LotController.text = '10';
    RecordController.text = '10';
    detailsController.text = "Test";

    if (Get.arguments != null) {
      ProcessController controller = Get.find();
      ProcessPureSilkModel item = Get.arguments['item'];
      idController.text = '${item.id}';
      //1
      var processerNameList = controller.ledgerDropdown
          .where((element) => '${element.id}' == '${item.processorId}')
          .toList();
      if (processerNameList.isNotEmpty) {
        processerName.value = processerNameList.first;
      }
      //2
      LotController.text = '${item.lot}';
      //3
      RecordController.text = '${item.recoredNo}';
      //4

      var firmNameList = controller.firmName
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
      }
      //5
      detailsController.text = '${item.details}';

      item.processItem?.forEach((element) {
        var request = {
          "date": "${element.date}",
          "entry_type": "${element.entryType}",
          "delivered_qty": "${element.deliveredQty}",
          "recived_qty": "${element.recivedQty}",
          "wages": "${element.wages}",
          "particulars": "${element.wages}",
        };
        processList.add(request);
      });
    }
  }

  Widget returnItems() {
    return Obx(() => DataTable(
          onSelectAll: (b) {},
          sortColumnIndex: 0,
          sortAscending: true,
          columns: const <DataColumn>[
            DataColumn(
                label: Text(
              "Date",
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text("Entry Type", overflow: TextOverflow.ellipsis)),
            DataColumn(
                label: Text("Particulars", overflow: TextOverflow.ellipsis)),
            DataColumn(
                label: Text("Delivered Quantity",
                    overflow: TextOverflow.ellipsis)),
            DataColumn(
                label:
                    Text("Received Quantity", overflow: TextOverflow.ellipsis)),
            DataColumn(
                label: Text("Wages (Rs)", overflow: TextOverflow.ellipsis)),
            DataColumn(label: Text("Action", overflow: TextOverflow.ellipsis)),
          ],
          rows: processList.map((user) {
            return DataRow(
              cells: [
                DataCell(
                    Text('${user['date']}', overflow: TextOverflow.ellipsis)),
                DataCell(Text('${user['entry_type']}',
                    overflow: TextOverflow.ellipsis)),
                DataCell(Text('${user['particulers']}',
                    overflow: TextOverflow.ellipsis)),
                DataCell(Text('${user['delivered_qty']}',
                    overflow: TextOverflow.ellipsis)),
                DataCell(Text('${user['recived_qty']}',
                    overflow: TextOverflow.ellipsis)),
                DataCell(
                    Text('${user['wages']}', overflow: TextOverflow.ellipsis)),
                DataCell(
                  IconButton(
                    iconSize: 24,
                    icon:
                        Image.asset('assets/images/ic_delete1.png', width: 18),
                    onPressed: () {
                      processList.remove(user);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ));
  }

  dynamic processpureDialog() async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const ProcessBottomSheet();
          // return const venki();
          //error lin
        });
    return result;
  }

  dynamic CreateLotDialoge(context) async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const ProcessCreateLotBottomSheet();
          //error lin
        });
    return result;
  }
}
