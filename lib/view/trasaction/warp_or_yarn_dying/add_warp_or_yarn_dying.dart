import 'dart:convert';

import 'package:abtxt/view/trasaction/warp_or_yarn_dying/warp_or_yarn_dying_bottom_sheet.dart';
import 'package:abtxt/view/trasaction/warp_or_yarn_dying/warp_or_yarn_dying_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/warp_or_yarn_dying_model.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/ledger/addledger.dart';
import 'create_lot_bottom_sheet.dart';

class AddWarpOrYarnDying extends StatefulWidget {
  const AddWarpOrYarnDying({Key? key}) : super(key: key);
  static const String routeName = '/AddWarpOrYarnDying';

  @override
  State<AddWarpOrYarnDying> createState() => _State();
}

class _State extends State<AddWarpOrYarnDying> {
  TextEditingController idController = TextEditingController();
  Rxn<LedgerModel> dyerNameController = Rxn<LedgerModel>();
  TextEditingController LotController = TextEditingController();
  TextEditingController RecordNoController = TextEditingController();
  Rxn<FirmModel> FirmController = Rxn<FirmModel>();



  final _formKey = GlobalKey<FormState>();
  late WarpOrYarnDyingController controller;
  var additemwarporYarndyinglist = <dynamic>[].obs;
  var additemCreateLotlist = <dynamic>[].obs;

  @override
  void initState() {
_initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarpOrYarnDyingController>(builder: (controller) {
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
            title: Text(
                "${idController.text == '' ? 'Add' : 'Update'} Warp or Yarn Dying"),
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
                                MyTextField(
                                  controller: idController,
                                  hintText: "ID",
                                  validate: "",
                                  enabled: false,
                                ),
                                Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // const Text(
                                  //   'Dyer Name',
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.w600,
                                  //       color: Colors.black87),
                                  // ),
                                  Container(
                                    width: 240,
                                    padding: EdgeInsets.all(8),
                                    child: DropdownButtonFormField(
                                      value: dyerNameController.value,
                                      items: controller.DyerName
                                          .map((LedgerModel item) {
                                        return DropdownMenuItem<LedgerModel>(
                                          value: item,
                                          child: Text('${item.ledgerName}',style: TextStyle(fontWeight: FontWeight.normal)),
                                        );
                                      }).toList(),
                                      onChanged: (LedgerModel? value) {
                                        dyerNameController.value = value;
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                        border: OutlineInputBorder(),
                                        // hintText: 'Select',
                                        labelText: 'Dyer Name'
                                      ),
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
                                SizedBox(
                                  width: 11,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 17.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(AddLedger.routeName);
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
                                                ' Create New',
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
                                  width: 12,
                                ),
                                MyTextField(
                                  controller: LotController,
                                  hintText: "Lot",
                                  validate: 'number',
                                  inputType: TextInputType.phone,
                                ),
                                SizedBox(
                                  width: 11,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 17.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: ()  async {
                                        var result = await CreateLotDialoge();
                                        print("result: ${result.toString()}");
                                        if (result != null) {
                                          additemCreateLotlist.add(result);
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
                                  width: 12,
                                ),
                                MyTextField(
                                  controller: RecordNoController,
                                  hintText: "Record No",
                                  validate: 'number',
                                  inputType: TextInputType.phone,
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
                                        value: FirmController.value,
                                        items: controller.Firm
                                            .map((FirmModel item) {
                                          return DropdownMenuItem<FirmModel>(
                                            value: item,
                                            child: Text('${item.firmName}',style: TextStyle(fontWeight: FontWeight.normal)),
                                          );
                                        }).toList(),
                                        onChanged: (FirmModel? value) {
                                          FirmController.value = value;
                                        },
                                        decoration: const InputDecoration(
                                          contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                          border: OutlineInputBorder(),
                                          // hintText: 'Select',
                                          labelText: 'Firm'
                                        ),
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

                              ],
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: AddItemsElevatedButton(
                                width: 135,
                                onPressed: () async {
                                  var result = await WarporYarndyingDialoge();
                                  print("result: ${result.toString()}");
                                  if (result != null) {
                                    additemwarporYarndyinglist.add(result);
                                  }
                                },
                                child: const Text('Add Item'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: Get.width,
                              color: Color(0xFFF4F2FF),
                              child: warporYarndyingitem(),
                            ),
                            SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 200,
                                  child: MyElevatedButton(
                                    color: Colors.red,
                                    onPressed: () => submit(),
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
                                        "${idController.text == '' ? 'Add' : 'Update'}"),
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
        "dyer_id": dyerNameController.value?.id,
        "lot": LotController.text,
        "recored_no": RecordNoController.text,
        "firm_id": FirmController.value?.id,


      };

      print(jsonEncode(request));

    }

  }
  void _initValue() {
    WarpOrYarnDyingController controller = Get.find();



    if (Get.arguments != null) {
      WarpOrYarnDyingController controller = Get.find();
      WarpOrYarnDyingModel warporyarndying = Get.arguments['item'];
      idController.text = '${warporyarndying.id}';

      LotController.text = '${warporyarndying.lot}';
      RecordNoController.text = '${warporyarndying.recoredNo}';

    }
  }
  Widget warporYarndyingitem() {
    return Obx(() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 0,
      sortAscending: true,
      columns: const <DataColumn>[
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("Entry Type")),
        DataColumn(label: Text("Particulars")),
        DataColumn(label: Text("Tks/")),
        DataColumn(label: Text("Delivered Weight")),
        DataColumn(label: Text("Received Weight")),
        DataColumn(label: Text("Wastage Weight")),
        DataColumn(label: Text("Waste")),
        DataColumn(label: Text("Wages (Rs)")),
        DataColumn(label: Text("Action")),
      ],
      rows: additemwarporYarndyinglist.map((user) {
        return DataRow(
          cells: [
            DataCell(Text('${user['yarn_name']}')),
            DataCell(Text('${user['color_name']}')),
            DataCell(Text('${user['delivered_from']}')),
            DataCell(Text('${user['box_no']}')),
            DataCell(Text('${user['stock']}')),
            DataCell(Text('${user['pack']}')),
            DataCell(Text('${user['quantity']}')),
            DataCell(Text('${user['less']}')),
            DataCell(Text('${user['net_quantity']}')),
            DataCell(Text('${user['calculate_type']}')),
            DataCell(Text('${user['rate']}')),
            DataCell(Text('${user['amount']}')),
            DataCell(
              IconButton(
                iconSize: 24,
                icon: Image.asset('assets/images/ic_delete1.png', width: 18),
                onPressed: () {
                  additemwarporYarndyinglist.remove(user);
                },
              ),
            ),
          ],
        );
      }).toList(),
    ));
  }
  dynamic WarporYarndyingDialoge() async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const WarpOrYarnDyingBottomSheet();
          //error lin
        });
    return result;
  }

  dynamic CreateLotDialoge() async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return const CreateLotBottomSheet();
          //error lin
        });
    return result;
  }

}
