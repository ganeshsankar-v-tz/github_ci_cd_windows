import 'package:abtxt/view/basics/ledger/ledger_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/LedgerModel.dart';

class LedgerDataSource extends DataGridSource {
  LedgerDataSource({required List<LedgerModel> ledgerData}) {
    _ledgerData = ledgerData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'image', value: e.image),
              DataGridCell<String>(columnName: 'name', value: e.ledgerName),
              DataGridCell<String>(columnName: 'mobile', value: e.phone),
              DataGridCell<Widget>(columnName: 'button', value: null),
            ]))
        .toList();
  }

  List<DataGridRow> _ledgerData = [];

  @override
  List<DataGridRow> get rows => _ledgerData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>(
      (e) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: LayoutBuilder(builder: (context, constraints) {
            if (e.columnName == 'button') {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      var id = '${row.getCells()[0].value.toString()}';
                      Get.snackbar('EDIT', "$id");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      var id = '${row.getCells()[0].value.toString()}';
                      //Get.snackbar('DELETE', "$id");
                      LedgerController controller = Get.find();
                      // controller.deleteLedger(id);
                    },
                  ),
                ],
              );
            } else if (e.columnName == 'image') {
              return Image.network(
                'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                width: 100,
              );
            } else {
              return Text(e.value.toString());
            }
          }),
          //child: Text(e.value.toString()),
        );
      },
    ).toList());
  }
}
