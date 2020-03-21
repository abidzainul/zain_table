import 'package:flutter/material.dart';

class TextCellFixTable extends StatelessWidget {
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

  TextCellFixTable(this.text,{
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