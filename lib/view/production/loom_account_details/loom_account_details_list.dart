import 'package:abtxt/flutter_core_widget.dart';
import 'package:abtxt/model/loom_account_model/LoomAccountDetailsModel.dart';
import 'package:abtxt/view/production/loom_account_details/loom_account_filter.dart';
import 'package:abtxt/widgets/MySFDataGridItemTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyFilterIconButton.dart';
import 'loom_account_controller.dart';

class LoomAccountDetailsList extends StatefulWidget {
  const LoomAccountDetailsList({super.key});

  static const String routeName = '/loom_account_details_list';

  @override
  State<LoomAccountDetailsList> createState() => _State();
}

class _State extends State<LoomAccountDetailsList> {
  LoomAccountController controller = Get.put(LoomAccountController());
  List<LoomAccountDetailsModel> list = <LoomAccountDetailsModel>[];
  late MyDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = MyDataSource(list: list);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoomAccountController>(builder: (controller) {
      return CoreWidget(
        appBar: AppBar(
          title: const Text('Loomwise - Bank Info'),
          actions: [
            MyFilterIconButton(onPressed: () => _filter()),
            const SizedBox(width: 12),
          ],
        ),
        loadingStatus: controller.status.isLoading,
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
              Get.back(),
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
              _filter(),
        },
        child: MySFDataGridItemTable(
          areFocusable: true,
          shrinkWrapRows: false,
          editingGestureType: EditingGestureType.tap,
          navigationMode: GridNavigationMode.cell,
          selectionMode: SelectionMode.single,
          allowEditing: true,
          source: dataSource,
          scrollPhysics: const ScrollPhysics(),
          columns: <GridColumn>[
            GridColumn(
              width: 50,
              allowEditing: false,
              columnName: 's_no',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'S.No',
              ),
            ),
            GridColumn(
              width: 200,
              allowEditing: false,
              columnName: 'weaver_name',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'Weaver Name',
              ),
            ),
            GridColumn(
              width: 80,
              allowEditing: false,
              columnName: 'loom_no',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'Loom No',
              ),
            ),
            GridColumn(
              width: 200,
              columnName: 'ac_holder',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'A/c holder',
              ),
            ),
            GridColumn(
              width: 140,
              columnName: 'ifsc_no',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'IFSC No',
              ),
            ),
            GridColumn(
              width: 200,
              columnName: 'bank_name',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'Bank Name',
              ),
            ),
            GridColumn(
              width: 150,
              columnName: 'branch',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'Branch',
              ),
            ),
            GridColumn(
              width: 250,
              columnName: 'account_no',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'Account No',
              ),
            ),
            GridColumn(
              width: 50,
              columnName: 'tds',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'TDS',
              ),
            ),
            GridColumn(
              width: 120,
              columnName: 'pan',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'PAN',
              ),
            ),
            GridColumn(
              width: 140,
              columnName: 'aathar_no',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'Aadhar Number',
              ),
            ),
            GridColumn(
              width: 100,
              columnName: 'benif_ac_typ',
              label: const MyDataGridHeader(
                alignment: Alignment.center,
                title: 'A/c Type',
              ),
            ),
          ],
        ),
      );
    });
  }

  void _api({var request = const {}}) async {
    var response = await controller.accountDetailsApiCall(request: request);
    list.clear();
    list.addAll(response);
    dataSource.notifyListeners();
    dataSource.updateDataGridRows();
  }

  void _filter() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const LoomAccountFilter(),
    );
    result != null ? _api(request: result ?? {}) : '';
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource({required List<LoomAccountDetailsModel> list}) {
    _list = list;
    updateDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];
  late List<LoomAccountDetailsModel> _list;

  @override
  List<DataGridRow> get rows => dataGridRows;

  void updateDataGridRows() {
    dataGridRows = _list.map<DataGridRow>((e) {
      int sNo = _list.indexOf(e) + 1;

      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 's_no', value: "$sNo"),
        DataGridCell<dynamic>(columnName: 'weaver_name', value: e.weaverName),
        DataGridCell<dynamic>(
            columnName: 'sub_weaver_no', value: e.subWeaverNo),
        DataGridCell<dynamic>(columnName: 'ac_holder', value: e.acHolder),
        DataGridCell<dynamic>(columnName: 'ifsc_no', value: e.ifscNo),
        DataGridCell<dynamic>(columnName: 'bank_name', value: e.bankName),
        DataGridCell<dynamic>(columnName: 'branch', value: e.branch),
        DataGridCell<dynamic>(columnName: 'account_no', value: e.accountNo),
        DataGridCell<dynamic>(columnName: 'tds', value: e.tdsPerc),
        DataGridCell<dynamic>(columnName: 'pan', value: e.panNo),
        DataGridCell<dynamic>(columnName: 'aathar_no', value: e.aatharNo),
        DataGridCell<dynamic>(columnName: 'benif_ac_typ', value: e.benifAcTyp),
      ]);
    }).toList();
  }

  dynamic newCellValue;

  TextEditingController editingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
          alignment: (e.columnName == 'id' || e.columnName == 'salary')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            e.value != null ? '${e.value}' : '',
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'ac_holder') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ac_holder', value: newCellValue);
      _list[dataRowIndex].acHolder = newCellValue.toString();
    } else if (column.columnName == 'ifsc_no') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ifsc_no', value: newCellValue);
      _list[dataRowIndex].ifscNo = newCellValue.toString();
    } else if (column.columnName == 'bank_name') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'bank_name', value: newCellValue);
      _list[dataRowIndex].bankName = newCellValue.toString();
    } else if (column.columnName == 'branch') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'branch', value: newCellValue);
      _list[dataRowIndex].branch = newCellValue.toString();
    } else if (column.columnName == 'account_no') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'account_no', value: newCellValue);
      _list[dataRowIndex].accountNo = newCellValue.toString();
    } else if (column.columnName == 'tds') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(
              columnName: 'tds', value: int.tryParse(newCellValue.toString()));
      _list[dataRowIndex].tdsPerc = int.tryParse(newCellValue.toString());
    } else if (column.columnName == 'pan') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'pan', value: newCellValue);
      _list[dataRowIndex].panNo = newCellValue.toString();
    } else if (column.columnName == 'aathar_no') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'aathar_no', value: newCellValue);
      _list[dataRowIndex].aatharNo = newCellValue.toString();
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'benif_ac_typ', value: newCellValue);
      _list[dataRowIndex].benifAcTyp = newCellValue.toString();
    }

    /// send the data after submit in api
    int rowIndex = rowColumnIndex.rowIndex;
    apiCall(newCellValue, rowIndex);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        editingController.selection = TextSelection(
            baseOffset: 0, extentOffset: editingController.text.length);
      }
    });

    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    newCellValue = null;

    final bool isNumericType =
        column.columnName == 'id' || column.columnName == 'salary';

    final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        focusNode: focusNode,
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        cursorHeight: 18,
        style: const TextStyle(fontSize: 15),
        decoration: const InputDecoration(
          isDense: true,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp)
        ],
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard ? RegExp('[0-9]') : RegExp('[a-zA-Z 0-9]');
  }

  apiCall(var data, int rowIndex) async {
    LoomAccountController controller = Get.find();
    if (data != null && rowIndex >= 0) {
      Map<String, dynamic> request = {};
      int? weaverId;

      for (int i = 0; i <= _list.length; i++) {
        weaverId = _list[rowIndex].weaverId;
        request["id"] = _list[rowIndex].id;
        request["weaver_id"] = _list[rowIndex].weaverId;
        request["sub_weaver_no"] = _list[rowIndex].subWeaverNo;
        request["branch"] = _list[rowIndex].branch;
        request["bank_name"] = _list[rowIndex].bankName;
        request["ifsc_no"] = _list[rowIndex].ifscNo;
        request["account_no"] = _list[rowIndex].accountNo;
        request["tds_perc"] = _list[rowIndex].tdsPerc;
        request["pan_no"] = _list[rowIndex].panNo;
        request["ac_holder"] = _list[rowIndex].acHolder;
        request["aathar_no"] = _list[rowIndex].aatharNo;
        request["benif_ac_typ"] = _list[rowIndex].benifAcTyp;
      }

      var result = await controller.loomAccountDetailsUpdate(request);
      var filter = {"weaver_id": weaverId};
      if (result == true) {
        var response = await controller.accountDetailsApiCall(request: filter);
        _list.clear();
        _list.addAll(response);
        updateDataGridRows();
      }
    }
  }
}
