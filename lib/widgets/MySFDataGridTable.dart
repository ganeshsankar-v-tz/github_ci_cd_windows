import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../utils/constant.dart';

class MySFDataGridTable extends StatelessWidget {
  final List<GridColumn> columns;
  final DataGridSource source;
  final int totalPage;
  final bool isLoading;
  final Function onRowsPerPageChanged;
  final Function? onRowSelected;
  final border;

  const MySFDataGridTable({
    Key? key,
    this.border = true,
    required this.columns,
    required this.source,
    this.totalPage = 1,
    this.isLoading = false,
    int rowsPerPage = 10,
    required this.onRowsPerPageChanged,
    this.onRowSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: constraint.maxHeight - 60.0,
                  width: constraint.maxWidth,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: const Color(0xFFF4EBFF),
                      gridLineStrokeWidth: 0.1,
                      gridLineColor: const Color(0xEFAAAAAA),
                      filterIconColor: Colors.green,
                    ),
                    child: SfDataGrid(
                      showColumnHeaderIconOnHover: true,
                      allowFiltering: true,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.vertical,
                      source: source,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: columns,
                      selectionMode: SelectionMode.single,
                      onCellTap: ((details) {
                        final DataGridRow row = source.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                        int selectedRowIndex = source.rows.indexOf(row);
                        //int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                        if(onRowSelected != null){
                          onRowSelected!(selectedRowIndex);
                        }
                      }),
                    ),
                  ),
                ),
                Container(
                  height: 60.0,
                  child: SfDataPager(
                    delegate: source,
                    availableRowsPerPage: Constants.PAGING,
                    pageCount: totalPage.ceil().toDouble(),
                    onRowsPerPageChanged: (int? rowsPerPage) {
                      onRowsPerPageChanged(rowsPerPage);
                      /*rowsPerPage = rowsPerPage!;
                      widget.source.notifyListeners();*/
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 18,
                  color: Colors.blue.shade600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
