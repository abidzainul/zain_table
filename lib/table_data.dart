import 'package:flutter/material.dart';

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
