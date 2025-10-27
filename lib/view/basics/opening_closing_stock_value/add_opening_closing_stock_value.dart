import 'package:abtxt/view/basics/opening_closing_stock_value/opening_closing_stock_value_controller.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/FirmModel.dart';
import '../../../model/OpeningClosingStockValueModel.dart';
import '../../../widgets/AddItemsElevatedButton.dart';
import '../../../widgets/CountTextField.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyDateField.dart';
import '../../../widgets/MyTextField.dart';
import 'opening_closing_stock_value_bottomsheet.dart';

class AddOpeningClosingStockValue extends StatefulWidget {
  const AddOpeningClosingStockValue({Key? key}) : super(key: key);
  static const String routeName = '/AddOpeningClosingStockValue';

  @override
  State<AddOpeningClosingStockValue> createState() => _State();
}

class _State extends State<AddOpeningClosingStockValue> {
  TextEditingController idController = TextEditingController();
  TextEditingController ac_Session = TextEditingController();
  Rxn<FirmModel> firmname = Rxn<FirmModel>();
  TextEditingController opening_Date = TextEditingController();
  TextEditingController closing_Date = TextEditingController();
  TextEditingController debit = TextEditingController();
  TextEditingController credit = TextEditingController();
  TextEditingController difference = TextEditingController();

  TextEditingController total_opening_stock = TextEditingController();
  TextEditingController total_closing_stock = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late OpeningClosingStockValueController controller;
  var addOpenCloseList = <dynamic>[].obs;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpeningClosingStockValueController>(
        builder: (controller) {
      this.controller = controller;
      return Scaffold(
        backgroundColor: Color(0xFFF9F3FF),
        appBar: AppBar(
          elevation: 0,
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'} Opening Closing Stock Value"),
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
                              Visibility(
                                visible: false,
                                child: MyTextField(
                                  controller: idController,
                                  hintText: "ID",
                                  validate: "",
                                  enabled: false,
                                ),
                              ),
                              MyTextField(
                                controller: ac_Session,
                                hintText: "A/C Session",
                                validate: "string",
                              ),
                              Container(
                                width: 240,
                                padding: EdgeInsets.all(8),
                                child: DropdownButtonFormField(
                                  style: TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 14,
                                      fontFamily: 'Poppins'),
                                  value: firmname.value,
                                  items: controller.firm_dropdown
                                      .map((FirmModel item) {
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
                                    firmname.value = value;
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      border: OutlineInputBorder(),
                                      // hintText: 'Select',
                                      labelText: 'Firm',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF939393),
                                        width: 0.4,
                                      ),
                                    ),
                                    labelStyle: TextStyle(fontSize: 14),),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              MyDateField(
                                controller: opening_Date,
                                hintText: "Opening Date",
                                validate: "string",
                                readonly: true,
                              ),
                              MyDateField(
                                controller: closing_Date,
                                hintText: "Closing Date",
                                validate: "string",
                                readonly: true,
                              ),
                              MyTextField(
                                controller: debit,
                                hintText: "Debit",
                                validate: "double",
                              ),
                              MyTextField(
                                controller: credit,
                                hintText: "Credit",
                                validate: "double",
                              ),
                              MyTextField(
                                controller: difference,
                                hintText: "Difference",
                                validate: "double",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: AddItemsElevatedButton(
                              width: 135,
                              onPressed: () async {
                                var result =
                                    await addOpeningClosingStockValuetemDialog();
                                print("result: ${result.toString()}");
                                if (result != null) {
                                  addOpenCloseList.add(result);
                                  initTotal();
                                }
                              },
                              child: const Text('Add Item'),
                            ),
                          ),
                          SizedBox(height: 20),
                          addOpenCloselist(),
                          const SizedBox(height: 40),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.enD,
                            children: [
                              Expanded(child: Container()),
                              // Padding(padding: EdgeInsets.only(left: 440)),
                              SizedBox(
                                width: 170,
                                child: CountTextField(
                                  controller: total_opening_stock,
                                  hintText: "Opening",
                                  readonly: true,
                                  suffix: const Text('Dr',
                                      style:
                                          TextStyle(color: Color(0xFF5700BC))),
                                ),
                              ),
                              // Padding(padding: EdgeInsets.only(left: 280)),
                              SizedBox(
                                width: 170,
                                child: CountTextField(
                                  controller: total_closing_stock,
                                  hintText: "Closing",
                                  suffix: const Text('Dr',
                                      style:
                                          TextStyle(color: Color(0xFF5700BC))),
                                  readonly: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyCloseButton(
                                onPressed: () => Get.back(),
                                child: const Text('Close'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
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
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "ac_session": ac_Session.text,
        "firm_id": firmname.value?.id,
        "opening_date": opening_Date.text,
        "closing_date": closing_Date.text,
        "debit": debit.text,
        "credit": credit.text,
        "difference": difference.text,
      };
      var open_item = [];
      double total_opening_stock = 0.0;
      double total_closing_stock = 0.0;
      for (var i = 0; i < addOpenCloseList.length; i++) {
        var item = {
          "ledger_ac": addOpenCloseList[i]['ledger_ac'],
          "opening_stock": addOpenCloseList[i]['opening_stock'],
          "closing_stock": addOpenCloseList[i]['closing_stock'],
        };
        total_opening_stock +=
            double.tryParse(addOpenCloseList[i]['opening_stock']) ?? 0;
        total_closing_stock +=
            double.tryParse(addOpenCloseList[i]['closing_stock']) ?? 0;
        open_item.add(item);
      }
      request['open_item'] = open_item;
      request['total_opening_stock'] = total_opening_stock;
      request['total_closing_stock'] = total_closing_stock;

      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.addOpeningClosingStock(request);
      } else {
        request['id'] = '$id';
        controller.editOpeningClosingStock(request, id);
      }

      print(request);
    }
  }

  void _initValue() {
    OpeningClosingStockValueController controller = Get.find();
    if (Get.arguments != null) {
      OpeningClosingStockValueModel item = Get.arguments['item'];
      idController.text = '${item.id}';
      ac_Session.text = '${item.acSession}';
      var firmName = controller.firm_dropdown
          .where((element) => '${element.id}' == '${item.firmId}')
          .toList();
      if (firmName.isNotEmpty) {
        firmname.value = firmName.first;
      }
      opening_Date.text = '${item.openingDate}';
      closing_Date.text = '${item.closingDate}';
      debit.text = '${item.debit}';
      credit.text = '${item.credit}';
      difference.text = '${item.difference}';
      item.itemDetails?.forEach((element) {
        var request = {
          "ledger_ac": "${element.ledgerAc}",
          "opening_stock": "${element.openingStock}",
          "closing_stock": "${element.closingStock}",
        };
        addOpenCloseList.add(request);
      });
    }
    initTotal();
  }

  void initTotal() {
    double Tottal_open = 0.0;
    double Tottal_close = 0.0;

    for (var i = 0; i < addOpenCloseList.length; i++) {
      Tottal_open +=
          double.tryParse(addOpenCloseList[i]['opening_stock']) ?? 0.0;
      Tottal_close +=
          double.tryParse(addOpenCloseList[i]['closing_stock']) ?? 0;
    }
    total_opening_stock.text = '$Tottal_open';
    total_closing_stock.text = '$Tottal_close';
  }

  Widget addOpenCloselist() {
    final ScrollController scrollView = ScrollController();
    return Obx(() => Container(
          width: Get.width,
          color: const Color(0xFFF4F2FF),
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollView,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: scrollView,
              child: Column(
                children: [
                  DataTable(
                    columnSpacing: 350,
                    onSelectAll: (b) {},
                    sortColumnIndex: 0,
                    sortAscending: true,
                    columns: const <DataColumn>[
                      DataColumn(label: Text("Ledger A /c")),
                      DataColumn(label: Text("Opening Stock")),
                      DataColumn(label: Text("Closing Stock")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows: addOpenCloseList.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${user['ledger_ac']}')),
                          DataCell(Text('${user['opening_stock']}')),
                          DataCell(Text('${user['closing_stock']}')),
                          DataCell(
                            IconButton(
                              iconSize: 24,
                              icon: Image.asset('assets/images/ic_delete1.png', width: 18),
                              onPressed: () {
                                addOpenCloseList.remove(user);
                                initTotal();
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  dynamic addOpeningClosingStockValuetemDialog() async {
    var result = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        constraints: const BoxConstraints(maxWidth: 800),
        builder: (context) {
          return OpeningClosingStockValueBottomSheet();
          //error lin
        });
    return result;
  }
}
