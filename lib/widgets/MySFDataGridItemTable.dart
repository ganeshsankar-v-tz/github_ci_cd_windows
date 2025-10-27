import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MySFDataGridItemTable extends StatelessWidget {
  final List<GridColumn> columns;
  final List<GridTableSummaryRow> tableSummaryRows;
  final DataGridSource source;
  final Widget? footer;
  final Function? onRowSelected;
  final Function? onRowSingleSelect;
  final Function? onLongPress;
  final Color? color;
  final ScrollPhysics scrollPhysics;
  final bool shrinkWrapRows;
  final SelectionMode selectionMode;
  final DataGridController? controller;
  final bool allowEditing;
  final EditingGestureType editingGestureType;
  final GridNavigationMode navigationMode;
  final bool areFocusable;
  final bool showCheckboxColumn;
  final SelectionManagerBase? selectionManager;
  final Function? onSelectionChanged;
  final double? rowHeight;
  final bool sorting;
  final bool filtering;
  final Color? headerColor;
  final GridLinesVisibility cellLineVisibility;
  final GridLinesVisibility headerLineVisibility;
  final Color gridLineColor;
  final bool allowColumnsResizing;
  final bool Function(ColumnResizeUpdateDetails)? onColumnResizeUpdate;

  const MySFDataGridItemTable({
    super.key,
    required this.columns,
    required this.source,
    this.footer,
    this.onRowSelected,
    this.onRowSingleSelect,
    this.onLongPress,
    this.tableSummaryRows = const [],
    this.color = const Color(0xFFF4F2FF),
    this.scrollPhysics = const NeverScrollableScrollPhysics(),
    this.shrinkWrapRows = true,
    this.selectionMode = SelectionMode.none,
    this.controller,
    this.allowEditing = false,
    this.editingGestureType = EditingGestureType.doubleTap,
    this.navigationMode = GridNavigationMode.row,
    this.areFocusable = false,
    this.showCheckboxColumn = false,
    this.selectionManager,
    this.onSelectionChanged,
    this.rowHeight,
    this.sorting = false,
    this.filtering = false,
    this.headerColor = const Color(0xFFF4F2FF),
    this.cellLineVisibility = GridLinesVisibility.both,
    this.headerLineVisibility = GridLinesVisibility.both,
    this.gridLineColor = const Color(0xADAAAAAA),
    this.allowColumnsResizing = false,
    this.onColumnResizeUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: FocusNode(descendantsAreFocusable: areFocusable),
      child: Container(
        color: color,
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            selectionColor: const Color(0xffA3D8FF),
            headerColor: headerColor,
            gridLineStrokeWidth: 0.3,
            gridLineColor: gridLineColor,
            filterIconColor: Colors.green,
          ),
          child: SfDataGrid(
            allowColumnsResizing: allowColumnsResizing,
            selectionManager: selectionManager,
            showCheckboxColumn: showCheckboxColumn,
            navigationMode: navigationMode,
            editingGestureType: editingGestureType,
            allowEditing: allowEditing,
            controller: controller,
            allowSorting: sorting,
            allowFiltering: filtering,
            onSelectionChanged:
                (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
              if (onSelectionChanged != null) {
                onSelectionChanged!(addedRows, removedRows);
              }
            },
            // onQueryRowHeight: (details) => 43,
            onQueryRowHeight: (details) {
              if (details.rowIndex == 0) {
                // Header row height
                return 42;
              } else if (rowHeight != null) {
                return rowHeight!;
              } else {
                return details.getIntrinsicRowHeight(details.rowIndex) * 0.7;
              }
            },
            verticalScrollPhysics: scrollPhysics,
            shrinkWrapRows: shrinkWrapRows,
            gridLinesVisibility: cellLineVisibility,
            headerGridLinesVisibility: headerLineVisibility,
            source: source,
            columnWidthMode: ColumnWidthMode.fill,
            columns: columns,
            tableSummaryRows: tableSummaryRows,
            selectionMode: selectionMode,
            onCellDoubleTap: ((details) {
              final DataGridRow row =
                  source.effectiveRows[details.rowColumnIndex.rowIndex - 1];
              int selectedRowIndex = source.rows.indexOf(row);
              //int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
              if (onRowSelected != null) {
                onRowSelected!(selectedRowIndex);
              }
            }),
            onCellTap: ((details) {
              final DataGridRow row =
                  source.effectiveRows[details.rowColumnIndex.rowIndex - 1];
              int selectedRowIndex = source.rows.indexOf(row);
              //int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
              if (onRowSingleSelect != null) {
                onRowSingleSelect!(selectedRowIndex);
              }
            }),
            onCellLongPress: ((details) {
              final DataGridRow row =
                  source.effectiveRows[details.rowColumnIndex.rowIndex - 1];
              int index = source.rows.indexOf(row);
              if (onLongPress != null) {
                var result = {
                  'index': index,
                  'column_name': details.column.columnName,
                };
                onLongPress!(result);
              }
            }),
            onColumnResizeUpdate: onColumnResizeUpdate,
            footer: footer,
          ),
        ),
      ),
    );
  }
}
