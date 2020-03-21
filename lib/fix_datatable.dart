import 'package:flutter/material.dart';
import 'table_data.dart';

class CustomDataTable extends StatefulWidget {
  final TableData cornerCell;
  final List<TableData> colCells;
  final List<TableData> titleCells;
  final List<List<TableData>> rowsCells;
  final Widget Function(TableData data, String type) cellBuilder;
  final double fixedColWidth;
  final double cellWidth;
  final double headingRowHeight;
  final double dataRowHeight;
  final double horizontalMargin;
  final double columnSpacing;

  CustomDataTable({
    this.cornerCell,
    this.colCells,
    this.titleCells,
    @required this.rowsCells,
    this.cellBuilder,
    this.fixedColWidth = 0.0,
    this.headingRowHeight = 0.0,
    this.dataRowHeight = 0.0,
    this.cellWidth = 90.0,
    this.horizontalMargin = 0.0,
    this.columnSpacing = 0.0,
  });

  @override
  State<StatefulWidget> createState() => CustomDataTableState();
}

class CustomDataTableState extends State<CustomDataTable> {
  final _columnController = ScrollController();
  final _rowController = ScrollController();
  final _subTableYController = ScrollController();
  final _subTableXController = ScrollController();

  Widget _buildChild(double width, TableData data, String type) => Container(
      width: width, child: widget.cellBuilder?.call(data, type) ??Text('${data.name}'));

  Widget _buildFixedCol() => widget.colCells == null
      ? SizedBox.shrink()
      : Material(
//    color: Colors.pink[50],
    child: Container(
        child: DataTable(
            horizontalMargin: widget.horizontalMargin,
            columnSpacing: widget.columnSpacing,
            headingRowHeight: widget.headingRowHeight,
            dataRowHeight: widget.dataRowHeight,
            columns: [
              DataColumn(
                  label: _buildChild(
                      widget.fixedColWidth, widget.colCells.first, "data"))
            ],
            rows: widget.colCells
                .sublist(widget.titleCells == null ? 1 : 0)
                .map((c) => DataRow(
                cells: [DataCell(_buildChild(widget.fixedColWidth+18, c, "data"))]))
                .toList()),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey[300], width: 1.0))
        )
    ),
  );

  Widget _buildFixedRow() => widget.titleCells == null
      ? SizedBox.shrink()
      : Material(
    color: Colors.pink,
    child: DataTable(
        horizontalMargin: widget.horizontalMargin,
        columnSpacing: widget.columnSpacing,
        headingRowHeight: widget.headingRowHeight,
        dataRowHeight: widget.dataRowHeight,
        columns: widget.titleCells
            .map((c) =>
            DataColumn(label: Container(child: _buildChild(c.width ?? widget.cellWidth, c, "title"),)))
            .toList(),
        rows: []),
  );

  Widget _buildSubTable() => Material(
//      color: Colors.lightGreenAccent,
      child: DataTable(
          horizontalMargin: widget.horizontalMargin,
          columnSpacing: widget.columnSpacing,
          headingRowHeight: widget.headingRowHeight,
          dataRowHeight: widget.dataRowHeight,
          columns: widget.rowsCells.first
              .asMap().map((i, c) => MapEntry(i, DataColumn(label: _buildChild(c.width ?? widget.cellWidth, c, "data")))).values
              .toList(),
          rows: widget.rowsCells
              .sublist(widget.titleCells == null ? 1 : 0)
              .map((row) => DataRow(
              cells: row
                  .map((c) => DataCell(_buildChild((c.width ?? widget.cellWidth)+18, c, "data"),))
                  .toList()))
              .toList()));

  Widget _buildCornerCell() =>
      widget.colCells == null || widget.titleCells == null
          ? SizedBox.shrink()
          : Material(
        color: Colors.pink,
        child: DataTable(
            horizontalMargin: widget.horizontalMargin,
            columnSpacing: widget.columnSpacing,
            headingRowHeight: widget.headingRowHeight,
            dataRowHeight: widget.dataRowHeight,
            columns: [
              DataColumn(
                  label: Container(padding: EdgeInsets.only(left: 5.0), child: _buildChild(
                      widget.fixedColWidth, widget.cornerCell, "title"),))
            ],
            rows: []),
      );

  @override
  void initState() {
    super.initState();
    _subTableXController.addListener(() {
      _rowController.jumpTo(_subTableXController.position.pixels);
    });
    _subTableYController.addListener(() {
      _columnController.jumpTo(_subTableYController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            SingleChildScrollView(
              controller: _columnController,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              child: _buildFixedCol(),
            ),
            Flexible(
              child: SingleChildScrollView(
                controller: _subTableXController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  controller: _subTableYController,
                  scrollDirection: Axis.vertical,
                  child: _buildSubTable(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildCornerCell(),
            Flexible(
              child: SingleChildScrollView(
                controller: _rowController,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: _buildFixedRow(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}