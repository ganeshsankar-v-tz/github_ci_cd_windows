import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MySFDataGridRawTable extends StatelessWidget {
  final List<GridColumn> columns;
  final DataGridSource source;
  final Function? onRowSelected;
  final Color? color;
  final Color? headerColor;
  final bool isLoading;
  final List<GridSummaryColumn> tableSummaryColumns;
  final SelectionMode selectionMode;
  final DataGridController? controller;
  final bool areFocusable;
  final SelectionManagerBase? selectionManager;


  const MySFDataGridRawTable({
    super.key,
    required this.columns,
    required this.source,
    this.onRowSelected,
    this.color = const Color(0xFFF4F2FF),
    this.headerColor = const Color(0xFFF4F2FF),
    this.isLoading = false,
    this.tableSummaryColumns = const [],
    this.selectionMode = SelectionMode.single,
    this.controller,
    this.areFocusable = false,
    this.selectionManager,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: FocusNode(descendantsAreFocusable: areFocusable),
      child: Container(
        color: color,
        margin: const EdgeInsets.only(left: 12, right: 12),
        child: Stack(
          children: [
            SfDataGridTheme(
              data: SfDataGridThemeData(
                selectionColor: const Color(0xffA3D8FF),
                headerColor: headerColor,
                gridLineStrokeWidth: 0.3,
                gridLineColor: const Color(0xEFAAAAAA),
                filterIconColor: Colors.green,
              ),
              child: SfDataGrid(
                isScrollbarAlwaysShown: true,
                selectionMode: selectionMode,
                //onQueryRowHeight: (details) => 42,
                onQueryRowHeight: (RowHeightDetails details) {
                  if (details.rowIndex == 0) {
                    // Header row height
                    return 42;
                  } else {
                    return 32.0;
                  }
                },
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                source: source,
                allowFiltering: true,
                allowSorting: true,
                allowMultiColumnSorting: true,
                showColumnHeaderIconOnHover: true,
                columnWidthMode: ColumnWidthMode.fill,
                columns: columns,
                controller: controller,
                selectionManager: selectionManager,
                tableSummaryRows: [
                  if (tableSummaryColumns.isNotEmpty)
                    GridTableSummaryRow(
                      showSummaryInRow: false,
                      columns: tableSummaryColumns,
                      position: GridTableSummaryRowPosition.bottom,
                    ),
                ],
                onCellDoubleTap: ((details) {
                  final DataGridRow row =
                      source.effectiveRows[details.rowColumnIndex.rowIndex - 1];
                  int selectedRowIndex = source.rows.indexOf(row);
                  //int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                  if (onRowSelected != null) {
                    onRowSelected!(selectedRowIndex);
                  }
                }),
              ),
            ),
            Visibility(
              visible: isLoading,
              replacement: source.rows.isEmpty
                  ? const Center(child: Text('No records found!'))
                  : const SizedBox.shrink(),
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 18,
                  color: Colors.blue.shade600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
