import 'package:flutter/material.dart';

class FixDataTable extends StatefulWidget {
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

  FixDataTable({
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
  State<StatefulWidget> createState() => FixDataTableState();
}

class FixDataTableState extends State<FixDataTable> {
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

class CellFixTable extends StatelessWidget {
  final String text;
  final Widget trailing;
  final bool widthInfinity;
  final bool border;
  final double fontSize;
  final double cellPaddingLeft;
  final double width;
  final double height;
  final MainAxisAlignment alignment;
  final FontWeight fontWeight;
  final Color color;
  final Color cellColor;
  final Color borderColor;
  final BorderSide borderBottom;
  final BorderSide borderTop;

  CellFixTable(this.text,{
    this.fontSize,
    this.cellPaddingLeft,
    this.trailing,
    this.border=false,
    this.width,
    this.height,
    this.widthInfinity=true,
    this.alignment,
    this.fontWeight,
    this.color,
    this.cellColor,
    this.borderColor,
    this.borderBottom,
    this.borderTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: cellPaddingLeft ?? 0.0),
        width: widthInfinity ? double.infinity : (width!=null ? width : null),
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: alignment ?? MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                text ?? '',
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight ?? FontWeight.normal,
                    color: color ?? Colors.grey[900]),
              ),
            ),
            trailing ?? SizedBox.shrink()
          ],),
        decoration: BoxDecoration(
            color: cellColor,
            border: border ? Border(bottom: BorderSide(color: borderColor ?? Colors.grey[300], width: 1.0)) : Border()
        )
    );
  }
}

class TableData {
  final String id;
  final String name;
  final String value;
  final String type;
  final Color color;
  final double width;

  TableData({this.id, this.name, this.value, this.type, this.color, this.width});

  TableData.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"].toString(),
        name = map["name"],
        value = map["value"].toString(),
        type = map["type"].toString(),
        width = map["width"],
        color = map["color"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['type'] = type;
    data['width'] = width;
    data['color'] = color;
    return data;
  }
}