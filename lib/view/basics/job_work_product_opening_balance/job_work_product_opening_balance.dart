import 'package:abtxt/view/basics/job_work_product_opening_balance/add_job_work_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/job_worker_product_model.dart';
import '../../../widgets/MyDataGridHeader.dart';
import 'package:abtxt/widgets/MySFDataGridTable.dart';
import '../../../widgets/MyEditDelete.dart';
import 'job_work_product_opening_balance_controller.dart';

List<JobWorkerProductModel> paginatedOrders = [];
JobWorkProductOpeningBalanceDataSource dataSource =
    JobWorkProductOpeningBalanceDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class JobWorkProductOpeningBalance extends StatefulWidget {
  const JobWorkProductOpeningBalance({Key? key}) : super(key: key);
  static const String routeName = '/job_work_product';

  @override
  State<JobWorkProductOpeningBalance> createState() => _State();
}

class _State extends State<JobWorkProductOpeningBalance> {
  late JobWorkProductOpeningBalanceController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = JobWorkProductOpeningBalanceDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobWorkProductOpeningBalanceController>(
      builder: (controller) {
        this.controller = controller;
        return KeyboardWidget(
          bindings: [
            KeyAction(
              LogicalKeyboardKey.keyQ,
              'Close', () => Get.back(),
              isControlPressed: true,
            ),
            KeyAction(
              LogicalKeyboardKey.keyN,
              'Add', () => Get.toNamed(AddJobWorkerProduct.routeName),
              isControlPressed: true,
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              title: Text('Basic Info / Job Work Product Opening Balance'),
              centerTitle: false,
              elevation: 0,
              actions: [
                ElevatedButton.icon(
                  onPressed: () async {
                    var item = await Get.toNamed(AddJobWorkerProduct.routeName);
                    dataSource.notifyListeners();
                  },
                  icon: Icon(Icons.add),
                  label: Text('ADD'), // <-- Text
                ),
                SizedBox(width: 15)
              ],
            ),
            body: MySFDataGridTable(
              columns: <GridColumn>[
                GridColumn(
                  width: 80,
                  columnName: 'id',
                  label: const MyDataGridHeader(title: 'ID'),
                ),
                GridColumn(
                  width: 120,
                  columnName: 'date',
                  label: const MyDataGridHeader(title: 'Date'),
                ),
                GridColumn(
                  columnName: 'job worker name',
                  label: const MyDataGridHeader(title: 'Job Worker Name'),
                ),
                GridColumn(
                  columnName: 'record no',
                  label: const MyDataGridHeader(title: 'Record No'),
                ),
                GridColumn(
                  columnName: 'details',
                  label: const MyDataGridHeader(title: 'Details'),
                ),
              ],
              source: dataSource,
              totalPage: totalPage,
              rowsPerPage: _rowsPerPage,
              isLoading: controller.status.isLoading,
              onRowsPerPageChanged: (var page) {
                _rowsPerPage = page;
                dataSource.notifyListeners();
              },
              onRowSelected: (index) async {
                var item = paginatedOrders[index];
                await Get.toNamed(AddJobWorkerProduct.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
            ),
          ),
        );
      },
    );
  }
}

class JobWorkProductOpeningBalanceDataSource extends DataGridSource {
  JobWorkProductOpeningBalanceDataSource() {
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
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddJobWorkerProduct.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                JobWorkProductOpeningBalanceController controller = Get.find();
                await controller.delete(id);
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
    if (newPageIndex < totalPage) {
      JobWorkProductOpeningBalanceController controller = Get.find();
      var result = await controller.jobWorkProduct(
          page: '${newPageIndex + 1}', limit: _rowsPerPage);
      paginatedOrders = result['list'];
      totalPage = result['totalPage'];
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
        DataGridCell(
          columnName: 'date',
          value: dataGridRow.createdAt,
        ),
        DataGridCell(
            columnName: 'job worker name', value: dataGridRow.jobworkerName),
        DataGridCell(columnName: 'record no', value: dataGridRow.recordNo),
        DataGridCell(columnName: 'details', value: dataGridRow.details),]);
    }).toList(growable: false);
  }
}
