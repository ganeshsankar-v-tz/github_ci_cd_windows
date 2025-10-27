import 'package:abtxt/widgets/MyDateField.dart';
import 'package:abtxt/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import '../../../model/AlternativeWarpDesignModel.dart';
import '../../../model/WarpDesignSheetModel.dart';
import '../../../widgets/MyCloseButton.dart';
import '../../../widgets/MyCreateNew.dart';
import '../../../widgets/MyDialogList.dart';
import '../../../widgets/MyTextField.dart';
import '../../basics/warp_design_sheet/add_warp_design_sheet.dart';
import 'alternative_warp_design_controller.dart';

class AddAltWarpDesign extends StatefulWidget {
  const AddAltWarpDesign({Key? key}) : super(key: key);
  static const String routeName = '/add_alternative_warp_design';

  @override
  State<AddAltWarpDesign> createState() => _State();
}

class _State extends State<AddAltWarpDesign> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController RecordController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  Rxn<WarpDesignSheetModel> warpDesign_name = Rxn<WarpDesignSheetModel>();
  TextEditingController warpDesignController = TextEditingController();
  TextEditingController warpidController = TextEditingController();
  TextEditingController warptypeController = TextEditingController();
  TextEditingController endsController = TextEditingController();

  TextEditingController emptypeController = TextEditingController();
  TextEditingController empqytController = TextEditingController();
  TextEditingController proqytController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController WarpConditionController = TextEditingController();
  TextEditingController SheetController = TextEditingController();

  TextEditingController altwarpdesignController = TextEditingController();

  TextEditingController altwarpidController = TextEditingController();
  TextEditingController altwarpTypeController = TextEditingController();
  TextEditingController alttotalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AltWarpDesignController controller;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltWarpDesignController>(builder: (controller) {
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
                "${idController.text == '' ? 'Add' : 'Update'} Alternative Warp Design"),
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
                              crossAxisAlignment: WrapCrossAlignment.center,
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
                                MyDateField(
                                  controller: dateController,
                                  hintText: "Date",
                                  validate: "string",
                                  readonly: true,
                                ),
                                MyTextField(
                                  controller: RecordController,
                                  hintText: "Record No",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: detailsController,
                                  hintText: "Details",
                                  validate: "string",
                                ),

                                MyDialogList(
                                  labelText: 'Warp Design',
                                  controller: warpDesignController,
                                  list: controller.warpDesign,
                                  showCreateNew: true,
                                  onItemSelected: (WarpDesignSheetModel item) {
                                    warpDesignController.text = '${item.designName}';
                                    warpDesign_name.value = item;
                                  },
                                  onCreateNew: (value) async {
                                    var item =
                                    await Get.toNamed(AddWarpDesignSheet.routeName);
                                    controller.onInit();
                                  },
                                ),

                                MyTextField(
                                  controller: warpidController,
                                  hintText: "Warp ID No",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: warptypeController,
                                  hintText: "Warp Type ",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: endsController,
                                  hintText: "Total Ends",
                                  validate: "number",
                                ),
                                MyTextField(
                                  controller: emptypeController,
                                  hintText: "Empty Type ",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: empqytController,
                                  hintText: "Empty Qty",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: proqytController,
                                  hintText: "Product Qty",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: meterController,
                                  hintText: "Meter",
                                  validate: "double",
                                ),
                                MyTextField(
                                  controller: WarpConditionController,
                                  hintText: "Warp Condition",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: SheetController,
                                  hintText: "Sheet",
                                  validate: "number",
                                ),
                              ],
                            ),
                            Container(
                              child: const Divider(
                                color: Colors.black12,
                                height: 25,
                                thickness: .50,
                                indent: 0,
                                endIndent: 0,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  child: const Text(
                                    "Alternative Warp:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF5700BC),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              children: [
                                MyTextField(
                                  controller: altwarpdesignController,
                                  hintText: "Warp Design",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: altwarpidController,
                                  hintText: "Warp ID No",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: altwarpTypeController,
                                  hintText: "Warp Type",
                                  validate: "string",
                                ),
                                MyTextField(
                                  controller: alttotalController,
                                  hintText: "Total Ends",
                                  validate: "number",
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
                                  child: MyElevatedButton(
                                    onPressed: controller.status.isLoading
                                        ? null
                                        : () => submit(),
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
        ),
      );
    });
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> request = {
        "date": dateController.text,
        "record_no": RecordController.text,
        "details": detailsController.text ?? '',
        "old_warp_design_id": warpDesign_name.value?.id,
        "warp_id_no": warpidController.text,
        "warp_type": warptypeController.text,
        "total_ends": endsController.text,
        "empty_type": emptypeController.text,
        "empty_qty": empqytController.text,
        "product_qty": proqytController.text,
        "meter": meterController.text,
        "warp_condition": WarpConditionController.text,
        "sheet": SheetController.text,
        "alt_warp_design_id": altwarpdesignController.text,
        "alt_warp_id": altwarpidController.text,
        "alt_Warp_type": altwarpTypeController.text,
        "alt_total_ends": alttotalController.text,
      };
      print(request);
      var id = idController.text;
      if (id.isEmpty) {
        controller.add(request);
      } else {
        request['id'] = '$id';

        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    // dateController.text = "2023-10-23";
    // RecordController.text = "1";
    // detailsController.text = "details";
    // warpidController.text = "RR05-23";
    // warptypeController.text = "Main Warp";
    // endsController.text = "4800";
    //
    // emptypeController.text = "Beam";
    // empqytController.text = "";
    // proqytController.text = "";
    // meterController.text = "100.50 ";
    // WarpConditionController.text = "Dyed";
    // SheetController.text = "";
    //
    // altwarpdesignController.text = "400+4000+300";
    // altwarpidController.text = "RS-01";
    // altwarpTypeController.text = "Main Warp";
    // alttotalController.text = "4800";

    if (Get.arguments != null) {
      AltWarpDesignController controller = Get.find();
      AlternativeWarpDesignModel data = Get.arguments['item'];
      idController.text = '${data.id}';
      dateController.text = '${data.date}';
      RecordController.text = '${data.recordNo}';
      detailsController.text = '${data.details}';
      var dyerList = controller.warpDesign
          .where((element) => '${element.id}' == '${data.oldWarpDesignId}')
          .toList();
      if (dyerList.isNotEmpty) {
        warpDesign_name.value = dyerList.first;
      }
      warpidController.text = '${data.oldWarpDesign}';
      warptypeController.text = '${data.warpType}';
      endsController.text = '${data.totalEnds}';

      emptypeController.text = '${data.emptyType}';
      empqytController.text = '${data.emptyQty}';
      proqytController.text = '${data.productQty}';
      meterController.text = '${data.meter}';
      WarpConditionController.text = '${data.warpCondition}';
      SheetController.text = '${data.sheet}';

      altwarpdesignController.text = '${data.altWarpDesignId}';
      altwarpidController.text = '${data.altWarpId}';
      altwarpTypeController.text = '${data.altWarpType}';
      alttotalController.text = '${data.altTotalEnds}';
    }
  }
}
