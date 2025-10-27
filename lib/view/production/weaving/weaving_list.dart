import 'package:abtxt/view/production/weaving/weaving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/WeavingListModel.dart';
import '../../../widgets/MyEditDelete.dart';
import 'add_weaving.dart';

List<WeavingListModel> paginatedOrders = [];
final MyDataSource dataSource = MyDataSource();
RxInt totalPage = RxInt(1);

class WeavingList extends StatefulWidget {
  const WeavingList({Key? key}) : super(key: key);
  static const String routeName = '/weaving_list';

  @override
  State<WeavingList> createState() => _State();
}

class _State extends State<WeavingList> {
  late WeavingController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeavingController>(builder: (controller) {
      this.controller = controller;
      return Scaffold(
        appBar: AppBar(
          title: Text('Production / Weaving'),
          centerTitle: false,
          elevation: 0,
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                var item = await Get.toNamed(AddWeaving.routeName);
                dataSource.notifyListeners();
              },
              icon: Icon(Icons.add),
              label: Text('ADD'),
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              SizedBox(
                height: constraint.maxHeight - 60.0,
                width: constraint.maxWidth,
                child: _buildDataGrid(constraint),
              ),
              Container(
                height: 60.0,
                child: Obx(
                  () => SfDataPager(
                    delegate: dataSource,
                    pageCount: totalPage.value.ceil().toDouble(),
                    direction: Axis.horizontal,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Widget _buildDataGrid(BoxConstraints constraint) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: const Color(0xFFF4EAFF),
        gridLineStrokeWidth: 0.1,
        gridLineColor: Color(0xFF5700BC),
      ),
      child: SfDataGrid(
        allowFiltering: true,
        allowSorting: true,
        allowMultiColumnSorting: true,
        gridLinesVisibility: GridLinesVisibility.vertical,
        source: dataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridColumn(
            width: 80,
            columnName: 'id',
            label: Center(child: Text('ID', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            width: 120,
            columnName: 'Date',
            label: Center(child: Text('Date', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'Weaver Name',
            label: Center(
                child: Text('Weaver Name', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'Loom No',
            label:
                Center(child: Text('Loom No', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'Warp Status',
            label: Center(
                child: Text('Warp Status', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'Product',
            label:
                Center(child: Text('Product', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'Wages (Rs)',
            label: Center(
                child: Text('Wages (Rs)', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            columnName: 'Unit Length',
            label: Center(
                child: Text('Unit\nLength', overflow: TextOverflow.ellipsis)),
          ),
          GridColumn(
            width: 100,
            columnName: 'button',
            label:
                Center(child: Text('Actions', overflow: TextOverflow.ellipsis)),
          ),
        ],
      ),
    );
  }
}

class MyDataSource extends DataGridSource {
  MyDataSource() {
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddWeaving.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                WeavingController controller = Get.find();
                // await controller.delete(id);
                dataSource.notifyListeners();
              },
            );
          } else {
            return Text(e.value.toString(), overflow: TextOverflow.ellipsis);
          }
        }),
      );
    }).toList());
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    if (newPageIndex < totalPage.value) {
      WeavingController controller = Get.find();
      var result = await controller.paginatedList(page: '${newPageIndex + 1}');
      paginatedOrders = result['list'];
      totalPage.value = result['totalPage'];
      buildPaginatedDataGridRows();
      notifyListeners();
    } else {
      paginatedOrders = [];
    }

    return true;
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedOrders.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'id', value: dataGridRow.id),
        DataGridCell(columnName: 'Date', value: dataGridRow.createdAt),
        DataGridCell(columnName: 'Weaver Name', value: dataGridRow.weaverName),
        DataGridCell(columnName: 'Loom No', value: dataGridRow.loom),
        DataGridCell(columnName: 'Warp Status', value: dataGridRow.warpStatus),
        DataGridCell(columnName: 'Product', value: dataGridRow.productName),
        DataGridCell(columnName: 'Wages (Rs)', value: dataGridRow.wages),
        DataGridCell(columnName: 'Unit Length', value: dataGridRow.unitLength),
        DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
