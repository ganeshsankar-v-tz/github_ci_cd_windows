import 'package:abtxt/view/basics/product_image/product_image_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keymap/keymap.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../http/http_urls.dart';
import '../../../model/new_product_image.dart';
import '../../../widgets/MyDataGridHeader.dart';
import '../../../widgets/MyEditDelete.dart';
import '../../../widgets/MySFDataGridTable.dart';
import 'add_product_image.dart';

List<NewProductImageModel> paginatedOrders = [];
ProductImageDataSource dataSource = ProductImageDataSource();
int totalPage = 1;
int _rowsPerPage = 10;

class ProductImageList extends StatefulWidget {
  const ProductImageList({Key? key}) : super(key: key);
  static const String routeName = '/product_image_list';

  @override
  State<ProductImageList> createState() => _State();
}

class _State extends State<ProductImageList> {
  late ProductImageController controller;
  @override
  void dispose() {
    paginatedOrders.clear();
    totalPage = 1;
    _rowsPerPage = 10;
    dataSource = ProductImageDataSource();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductImageController>(builder: (controller) {
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
            'Add', () => Get.toNamed(AddProductImage.routeName),
            isControlPressed: true,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Basic Info / Product Image List'),
            centerTitle: false,
            elevation: 0,
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  var item = await Get.toNamed(AddProductImage.routeName);
                  dataSource.notifyListeners();
                },
                icon: Icon(Icons.add),
                label: Text('ADD'), // <-- Text
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          body: MySFDataGridTable(
            columns: [
              GridColumn(
                width: 80,
                columnName: 'id',
                label: const MyDataGridHeader(title: 'ID'),
              ),
              GridColumn(
                width: 120,
                columnName: 'created_at',
                label: const MyDataGridHeader(title: 'Date'),
              ),
              GridColumn(
                allowSorting: false,
                allowFiltering: false,
                columnName: 'image',
                label: const MyDataGridHeader(title: 'Image'),
              ),
              GridColumn(
                columnName: 'product_name',
                label: const MyDataGridHeader(title: 'Product'),
              ),
              GridColumn(
                columnName: 'design_no',
                label: const MyDataGridHeader(title: 'Design No'),
              ),
              GridColumn(
                columnName: 'length',
                label: const MyDataGridHeader(title: 'Saree Length (Meter)'),
              ),
              GridColumn(
                width: 100,
                columnName: 'button',
                label: const MyDataGridHeader(title: 'Actions'),
                allowFiltering: false,
                allowSorting: false,
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
          ),
        ),
      );
    });
  }
}

class ProductImageDataSource extends DataGridSource {
  ProductImageDataSource() {
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
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          if (e.columnName == 'button') {
            return MyEditDelete(
              onEditPressed: () async {
                var id = row.getCells()[0].value;
                int index =
                    paginatedOrders.indexWhere((element) => element.id == id);
                var item = paginatedOrders[index];
                await Get.toNamed(AddProductImage.routeName,
                    arguments: {"item": item});
                dataSource.notifyListeners();
              },
              onDeletePressed: () async {
                var id = row.getCells()[0].value.toString();
                ProductImageController controller = Get.find();
                await controller.deleteNewProductImage(id);
                dataSource.notifyListeners();
              },
            );
          } else if (e.columnName == 'image') {
            return CachedNetworkImage(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              imageUrl: "${HttpUrl.baseUrl}${e.value.toString()}",
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Colors.grey,
              ),
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
      ProductImageController controller = Get.find();
      var result = await controller.productimages(
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
            columnName: 'created_at',
            value: dataGridRow.createdAt),
        DataGridCell(columnName: 'image', value: dataGridRow.productName),
        DataGridCell(
            columnName: 'product_name', value: dataGridRow.productName),
        DataGridCell(columnName: 'design_no', value: dataGridRow.designNo),
        DataGridCell(columnName: 'length', value: dataGridRow.length),
        DataGridCell(columnName: 'button', value: null),
      ]);
    }).toList(growable: false);
  }
}
