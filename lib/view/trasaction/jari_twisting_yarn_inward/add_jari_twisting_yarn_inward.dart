import 'package:abtxt/model/JariTwistingModel.dart';
import 'package:abtxt/model/JariTwistingYarnInwardModel.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:abtxt/view/basics/jari_twisting/add_jari_twisting.dart';
import 'package:abtxt/view/basics/new_color/add_new_color.dart';
import 'package:abtxt/widgets/MyAutoComplete.dart';
import 'package:abtxt/widgets/MyDateFilter.dart';
import 'package:abtxt/widgets/MyDropdownButtonFormField.dart';
import 'package:abtxt/widgets/MySubmitButton.dart';
import 'package:abtxt/widgets/my_search_field/my_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/FirmModel.dart';
import '../../../model/LedgerModel.dart';
import '../../../model/NewColorModel.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyDeleteIconButton.dart';
import '../../../widgets/MyPrintButton.dart';
import '../../../widgets/MySFDataGridItemTable.dart';
import '../../../widgets/MyTextField.dart';
import '../../../widgets/flutter_shortcut_widget.dart';
import '../../basics/ledger/addledger.dart';
import 'jari_twisting_yarn_inward_controller.dart';

class AddJariTwistingYarnInward extends StatefulWidget {
  const AddJariTwistingYarnInward({super.key});

  static const String routeName = '/add_jari_twisting_yarn_inward';

  @override
  State<AddJariTwistingYarnInward> createState() =>
      _AddJariTwistingYarnInwardState();
}

class _AddJariTwistingYarnInwardState extends State<AddJariTwistingYarnInward> {
  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Rxn<LedgerModel> warper = Rxn<LedgerModel>();
  TextEditingController warperTextController = TextEditingController();
  Rxn<FirmModel> firmName = Rxn<FirmModel>();
  Rxn<LedgerModel> accountType = Rxn<LedgerModel>();
  Rxn<JariTwistingModel> yarnName = Rxn<JariTwistingModel>();
  TextEditingController yarnNameTextController = TextEditingController();
  Rxn<NewColorModel> colorname = Rxn<NewColorModel>();
  TextEditingController slipNoController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController stockcontroller = TextEditingController(text: "Office");
  TextEditingController boxNoController = TextEditingController();
  TextEditingController copsreelscontroller =
      TextEditingController(text: "Nothing");
  TextEditingController packController = TextEditingController(text: '0');
  TextEditingController quantityController = TextEditingController();
  TextEditingController netQuantityController =
      TextEditingController(text: '0.000');
  TextEditingController wagesRsController = TextEditingController(text: '0.00');
  TextEditingController amountController = TextEditingController(text: '0.00');

  final _formKey = GlobalKey<FormState>();
  final JariTwistingYarnInwardController controller = Get.find();

  var itemList = <dynamic>[];
  late ItemDataSource dataSource;
  RxBool isUpdate = RxBool(false);
  final FocusNode _firstInputFocusNode = FocusNode();
  final FocusNode _warperNameFocusNode = FocusNode();
  final FocusNode _wagesAccountFocusNode = FocusNode();
  final FocusNode _yarnNameFocusNode = FocusNode();
  final FocusNode _colorNameFocusNode = FocusNode();
  final FocusNode _netQtyFocusNode = FocusNode();
  var shortCut = RxString("");

  /// created by and updated by details controllers
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? displayName;
  String? displayDate;

  @override
  void initState() {
    _warperNameFocusNode.addListener(() => shortCutKeys());
    _wagesAccountFocusNode.addListener(() => shortCutKeys());
    _yarnNameFocusNode.addListener(() => shortCutKeys());
    _colorNameFocusNode.addListener(() => shortCutKeys());
    _initValue();
    super.initState();
    dataSource = ItemDataSource(list: itemList);
    if (Get.arguments != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_firstInputFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JariTwistingYarnInwardController>(builder: (controller) {
      return ShortCutWidget(
        appBar: AppBar(
          title: Text(
              "${idController.text == '' ? 'Add' : 'Update'}  Jari Twisting - Yarn Inward"),
          actions: [
            Visibility(
              visible: idController.text.isNotEmpty,
              child: MyDeleteIconButton(
                onPressed: (password) {
                  controller.delete(idController.text, password);
                },
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: slipNoController.text.isNotEmpty,
              child: MyPrintButton(
                onPressed: () => _print(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.keyQ, control: true):
              GetBackIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyP, control: true):
              PrintIntent(),
          SingleActivator(LogicalKeyboardKey.keyC, alt: true):
              NavigateAnotherPageIntent(),
        },
        loadingStatus: controller.status.isLoading,
        child: Actions(
          actions: <Type, Action<Intent>>{
            GetBackIntent: SetCounterAction(perform: () {
              Get.back();
            }),
            SaveIntent: SetCounterAction(perform: () {
              submit();
            }),
            PrintIntent: SetCounterAction(perform: () {
              _print();
            }),
            NavigateAnotherPageIntent: SetCounterAction(perform: () {
              navigateAnotherPage();
            }),
          },
          child: FocusScope(
            autofocus: true,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF9F3FF), width: 16),
                ),
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
                          MyAutoComplete(
                            label: 'Firm',
                            items: controller.Firm,
                            selectedItem: firmName.value,
                            enabled: !isUpdate.value,
                            onChanged: (FirmModel item) {
                              firmName.value = item;
                              //  _firmNameFocusNode.requestFocus();
                            },
                            autofocus: false,
                          ),
                          Focus(
                            focusNode: _wagesAccountFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Wages Account',
                              items: controller.wagesAccountList,
                              selectedItem: accountType.value,
                              enabled: !isUpdate.value,
                              onChanged: (LedgerModel item) {
                                accountType.value = item;
                              },
                              autofocus: false,
                            ),
                          ),
                          MySearchField(
                            label: 'Warper Name',
                            enabled: !isUpdate.value,
                            items: controller.warperList,
                            textController: warperTextController,
                            focusNode: _warperNameFocusNode,
                            requestFocus: _firstInputFocusNode,
                            onChanged: (LedgerModel item) async {
                              warper.value = item;
                              controller.request['warper_id'] = item.id;
                            },
                          ),
                          Visibility(
                            visible: slipNoController.text.isNotEmpty,
                            child: MyTextField(
                              controller: slipNoController,
                              hintText: "Slip No",
                              readonly: true,
                              enabled: !isUpdate.value,
                            ),
                          ),
                          MyDateFilter(
                            controller: dateController,
                            labelText: "Date",
                            focusNode: _firstInputFocusNode,
                            // readonly: true,
                          ),
                          ExcludeFocusTraversal(
                            child: MyTextField(
                              controller: detailsController,
                              hintText: "Details",
                              // validate: "string",
                            ),
                          ),
                          MySearchField(
                            label: 'Yarn Name',
                            enabled: !isUpdate.value,
                            items: controller.Yarn,
                            textController: yarnNameTextController,
                            focusNode: _yarnNameFocusNode,
                            requestFocus: _netQtyFocusNode,
                            onChanged: (JariTwistingModel item) async {
                              yarnName.value = item;
                              netQuantityController.text = '0.000';
                              itemList.clear();
                              var result = await controller
                                  .yarnIdByConsumedYarn(item.yarnId);

                              for (var element in result) {
                                var request = element.toJson();
                                itemList.add(request);
                              }
                              dataSource.updateDataGridRows();
                              dataSource.updateDataGridSource();
                            },
                          ),
                          Focus(
                            focusNode: _colorNameFocusNode,
                            skipTraversal: true,
                            child: MyAutoComplete(
                              label: 'Color Name',
                              items: controller.Color,
                              selectedItem: colorname.value,
                              enabled: !isUpdate.value,
                              onChanged: (NewColorModel item) {
                                colorname.value = item;

                                for (var i = 0; i < itemList.length; i++) {
                                  itemList[i]["color_id"] = item.id;
                                  itemList[i]["color_name"] = item.name;
                                }
                                dataSource.updateDataGridRows();
                                dataSource.updateDataGridSource();
                              },
                            ),
                          ),
                          MyDropdownButtonFormField(
                            controller: stockcontroller,
                            hintText: "Stock in",
                            items: const ["Office", "Godown"],
                            enabled: !isUpdate.value,
                          ),
                          MyTextField(
                            controller: boxNoController,
                            hintText: "Box No.",
                            enabled: !isUpdate.value,
                          ),
                          MyDropdownButtonFormField(
                            controller: copsreelscontroller,
                            hintText: "Cops/Reel Name",
                            items: const ["Nothing"],
                            enabled: !isUpdate.value,
                          ),
                          MyTextField(
                            controller: packController,
                            hintText: "Pack",
                          ),
                          Focus(
                              skipTraversal: true,
                              child: MyTextField(
                                focusNode: _netQtyFocusNode,
                                controller: netQuantityController,
                                hintText: "Net Quantity",
                                validate: "double",
                                onChanged: (value) => _calculate(),
                                suffix: const Text(
                                  "Kg",
                                  style: TextStyle(color: Color(0XFF5700BC)),
                                ),
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(
                                    netQuantityController);
                              }),
                          Focus(
                              skipTraversal: true,
                              child: ExcludeFocusTraversal(
                                child: MyTextField(
                                  controller: wagesRsController,
                                  hintText: "Wages (Rs)",
                                  validate: "double",
                                  onChanged: (value) => _calculate(),
                                ),
                              ),
                              onFocusChange: (hasFocus) {
                                AppUtils.fractionDigitsText(
                                  wagesRsController,
                                  fractionDigits: 2,
                                );
                              }),
                          MyTextField(
                            controller: amountController,
                            hintText: "Amount(Rs)",
                            validate: "double",
                            enabled: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ExcludeFocusTraversal(child: itemsTable()),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          crateAndUpdatedBy(),
                          const Spacer(),
                          Obx(
                            () => Text(shortCut.value,
                                style: AppUtils.shortCutTextStyle()),
                          ),
                          const SizedBox(width: 12),
                          MySubmitButton(
                            onPressed:
                                controller.status.isLoading ? null : submit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  shortCutKeys() {
    if (_warperNameFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Warper',Press Alt+C ";
    } else if (_wagesAccountFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Wages Account',Press Alt+C ";
    } else if (_yarnNameFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Conversion Yarn',Press Alt+C ";
    } else if (_colorNameFocusNode.hasFocus && Get.arguments == null) {
      shortCut.value = "To Create 'Colour',Press Alt+C ";
    } else {
      shortCut.value = "";
    }
  }

  navigateAnotherPage() async {
    if (_warperNameFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.warperInfo();
      }
    } else if (_wagesAccountFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddLedger.routeName);

      if (result == "success") {
        controller.WagesAccountInfo();
      }
    } else if (_yarnNameFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddJariTwisting.routeName);

      if (result == "success") {
        controller.YarnInfo();
      }
    } else if (_colorNameFocusNode.hasFocus && Get.arguments == null) {
      var result = await Get.toNamed(AddNewColor.routeName);

      if (result == "success") {
        controller.ColorInfo();
      }
    }
  }

  Future<void> _print() async {
    if (idController.text.isEmpty) {
      return;
    }

    var request = {'id': idController.text};
    String? response =
        await controller.jariTwistingYarnInwardPdf(request: request);

    if (response!.isNotEmpty) {
      final Uri url = Uri.parse(response);
      if (!await launchUrl(url)) {
        throw Exception('Error : $response');
      }
    }
  }

  _calculate() {
    double netQuantity = double.tryParse(netQuantityController.text) ?? 0.0;
    double wages = double.tryParse(wagesRsController.text) ?? 0.0;
    var totalAmount = netQuantity * wages;
    amountController.text = totalAmount.toStringAsFixed(2);

    for (var i = 0; i < itemList.length; i++) {
      var consumedQuantity = netQuantity * itemList[i]["usage"];
      itemList[i]['quantity'] = consumedQuantity;
    }

    dataSource.updateDataGridRows();
    dataSource.updateDataGridSource();
  }

  submit() {
    if (_formKey.currentState!.validate()) {
      if (warper.value == null) {
        return AppUtils.infoAlert(message: "Select the Warper Name");
      }

      if (itemList.isEmpty) {
        return AppUtils.infoAlert(message: "Enter the item Details");
      }

      Map<String, dynamic> request = {
        "warper_id": warper.value?.id,
        "firm_id": firmName.value?.id,
        "e_date": dateController.text,
        "wages_ano": accountType.value?.id,
        "details": detailsController.text,
        "yarn_id": yarnName.value?.yarnId,
        "color_id": colorname.value?.id,
        "stock_in": stockcontroller.text,
        "box_no": boxNoController.text,
        "cr_no": copsreelscontroller.text == 'Nothing' ? 0 : 1,
        "pck": int.tryParse(packController.text) ?? 0,
        "quantity": double.tryParse(netQuantityController.text) ?? 0.0,
        "wages": double.tryParse(wagesRsController.text) ?? 0.0,
        "net_amount": double.tryParse(amountController.text) ?? 0.0,
      };
      request["item_details"] = itemList;

      var id = idController.text;
      if (id.isEmpty) {
        controller.filterData = null;
        controller.add(request);
      } else {
        request['id'] = id;
        request['slip_no'] = int.parse(slipNoController.text);
        controller.edit(request, id);
      }
    }
  }

  void _initValue() {
    dateController.text = AppUtils.parseDateTime("${DateTime.now()}");
    accountType.value = AppUtils.findLedgerAccountByName(
        controller.wagesAccountList, 'Twisting Wages');
    controller.request = <String, dynamic>{};
    firmName.value = AppUtils.setDefaultFirmName(controller.Firm);

    // AUTO SELECT THE FIRST ITEM OF COLOUR.
    if (controller.Color.isNotEmpty) {
      colorname.value = controller.Color.first;
    }

    if (controller.yarnName.isNotEmpty) {
      yarnNameTextController.text = controller.yarnName;
    }

    if (controller.warperName.isNotEmpty) {
      warperTextController.text = controller.warperName;
    }

    if (Get.arguments != null) {
      isUpdate.value = true;
      var item = JariTwistingYarnInwardModel.fromJson(Get.arguments['item']);

      idController.text = tryCast(item.id);
      dateController.text = item.eDate ?? '';
      detailsController.text = item.details ?? '';
      boxNoController.text = tryCast(item.boxNo);
      copsreelscontroller.text = "Nothing";
      packController.text = tryCast(item.pck);
      quantityController.text = tryCast(item.quantity);
      var netQuantity = (item.quantity ?? 0) - (item.lessQuantity ?? 0);
      netQuantityController.text = '$netQuantity';
      wagesRsController.text = tryCast(item.wages);
      amountController.text = tryCast(item.netAmount);
      slipNoController.text = tryCast(item.slipNo);

      // Firm Name
      var firmNameList = controller.Firm.where(
          (element) => '${element.id}' == '${item.firmId}').toList();
      if (firmNameList.isNotEmpty) {
        firmName.value = firmNameList.first;
      }
      // // Yarn Name
      var yarnNameList = controller.Yarn.where(
          (element) => '${element.yarnId}' == '${item.yarnId}').toList();
      if (yarnNameList.isNotEmpty) {
        yarnName.value = yarnNameList.first;
        yarnNameTextController.text = '${yarnNameList.first.yarnName}';
      }

      // Warper Name
      var warperNamelist = controller.warperList
          .where((element) => '${element.id}' == '${item.warperId}')
          .toList();
      if (warperNamelist.isNotEmpty) {
        warper.value = warperNamelist.first;
        warperTextController.text = '${warperNamelist.first.ledgerName}';
      }
      var wagesNameList = controller.wagesAccountList
          .where((element) => '${element.id}' == '${item.wagesAno}')
          .toList();
      if (wagesNameList.isNotEmpty) {
        accountType.value = wagesNameList.first;
      }

      var colorNameList = controller.Color.where(
          (element) => '${element.id}' == '${item.colorId}').toList();
      if (colorNameList.isNotEmpty) {
        colorname.value = colorNameList.first;
      }

      /// get created by and updated by details
      DateTime createDate = DateTime.parse(item.createdAt ?? "0000-00-00");
      DateTime updateDate = DateTime.parse(item.updatedAt ?? "0000-00-00");
      createdAt = AppUtils.dateFormatter.format(createDate);
      updatedAt = AppUtils.dateFormatter.format(updateDate);
      createdBy = item.creatorName;
      updatedBy = item.updatedName;
      if (updatedBy != null) {
        displayName = "Edit : $updatedBy";
        displayDate = updatedAt;
      } else {
        displayName = "New : $createdBy";
        displayDate = createdAt;
      }

      item.itemDetails?.forEach((element) {
        var request = element.toJson();
        itemList.add(request);
      });
    }
  }

  Widget itemsTable() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: const Row(children: [
              Text(
                'Consumed Yarns',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ]),
          ),
          MySFDataGridItemTable(
            columns: [
              GridColumn(
                columnName: 'yarn_name',
                label: const MyDataGridHeader(title: 'Yarn Name'),
              ),
              GridColumn(
                columnName: 'color_name',
                label: const MyDataGridHeader(title: 'Color Name'),
              ),
              GridColumn(
                width: 120,
                columnName: 'quantity',
                label: const MyDataGridHeader(title: 'Quantity'),
              ),
              GridColumn(
                visible: false,
                columnName: 'usage',
                label: const MyDataGridHeader(title: 'Usage'),
              ),
            ],
            tableSummaryRows: [
              GridTableSummaryRow(
                showSummaryInRow: false,
                title: 'Total: ',
                titleColumnSpan: 1,
                columns: [
                  const GridSummaryColumn(
                    name: 'quantity',
                    columnName: 'quantity',
                    summaryType: GridSummaryType.sum,
                  ),
                ],
                position: GridTableSummaryRowPosition.bottom,
              ),
            ],
            source: dataSource,
          ),
        ]);
  }

  Widget crateAndUpdatedBy() {
    String id = idController.text;
    String formattedDate = AppUtils.dateFormatter.format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${id.isEmpty ? "New : ${AppUtils().loginName}" : displayName}",
          style: AppUtils.updateAndCreateTextStyle(),
        ),
        const SizedBox(width: 12),
        Text(
          "${id.isEmpty ? formattedDate : displayDate}",
          style: AppUtils.updateAndCreateTextStyle(),
        )
      ],
    );
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
        DataGridCell<dynamic>(columnName: 'yarn_name', value: e['yarn_name']),
        DataGridCell<dynamic>(columnName: 'color_name', value: e['color_name']),
        DataGridCell<dynamic>(columnName: 'quantity', value: e['quantity']),
        DataGridCell<dynamic>(columnName: 'usage', value: e['usage']),
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
        case 'quantity':
          return buildFormattedCell(value, decimalPlaces: 3);
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
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    final columnName = summaryColumn?.columnName;
    double parsedValue = double.tryParse(summaryValue) ?? 0;
    TextAlign alignment;

    switch (columnName) {
      case 'quantity':
        alignment = TextAlign.right;
        return _buildFormattedCell(parsedValue,
            decimalPlaces: 3, alignment: alignment);
      default:
        /* alignment = TextAlign.left;
        return const Text('Total: ',  style: TextStyle(fontWeight: FontWeight.w700),);*/
        return null;
    }
  }

  Widget _buildFormattedCell(double value,
      {int decimalPlaces = 0, required TextAlign alignment}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      decimalDigits: decimalPlaces,
      name: '',
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      child: Text(
        formatter.format(value),
        style: AppUtils.footerTextStyle(),
        textAlign: alignment,
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRow;

  void updateDataGridSource() {
    notifyListeners();
  }
}
