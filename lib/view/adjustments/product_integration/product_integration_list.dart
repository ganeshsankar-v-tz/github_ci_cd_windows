import 'package:abtxt/view/adjustments/product_integration/product_integration_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../model/product_integration_model.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'add_product_integration.dart';

List<ProductIntegrationModel> paginatedOrders = [];
ProductIntegrationDataSource dataSource = ProductIntegrationDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class ProductIntegration extends StatefulWidget {
  const ProductIntegration({Key? key}) : super(key: key);
  static const String routeName = '/product_integration_list';

  @override
  State<ProductIntegration> createState() => _State();
}

class _State extends State<ProductIntegration> {
  late ProductIntegrationController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = ProductIntegrationDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductIntegrationController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddProductIntegration.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Adjustment / Product Integration- Adjustment'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddProductIntegration.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: Text('ADD'),
              ),
              SizedBox(
                width: 15,
              ),
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
                columnName: 'Date',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                columnName: 'Record No',
                label: const MyDataGridHeader(title: 'Record No'),
              ),
              GridColumn(
                columnName: 'Integrate by',
                label: const MyDataGridHeader(title: 'Integrated by'),
              ),
              GridColumn(
                columnName: 'Product',
                label: const MyDataGridHeader(title: 'Product'),
              ),
              GridColumn(
                columnName: 'Quantity',
                label: const MyDataGridHeader(title: 'Quantity'),
              ),
              // GridColumn(
              //   width: 100,
              //   allowSorting: false,
              //   allowFiltering: false,
              //   columnName: 'button',
              //   label: const MyDataGridHeader(title: 'Actions'),
              // ),
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
              await Get.toNamed(AddProductIntegration.routeName,
                  arguments: {"item": item});
              dataSource.notifyListeners();
            },

          ),
        ),
      );
    });
  }
}

class ProductIntegrationDataSource extends DataGridSource {
  ProductIntegrationDataSource() {
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
                await Get.toNamed(AddProductIntegration.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                ProductIntegrationController controller = Get.find();
                await controller.deleteProductintegration(id);
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
      ProductIntegrationController controller = Get.find();
      var result = await controller.productIntegration(
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
            columnName: 'Date', value: dataGridRow.date),
        DataGridCell(columnName: 'Record No', value: dataGridRow.recoredNo),
        DataGridCell(
            columnName: 'Integrated by', value: dataGridRow.integrateBy),
        DataGridCell(columnName: 'Product', value: dataGridRow.productId),
        DataGridCell(columnName: 'Quantity', value: dataGridRow.quantity),
        // DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
