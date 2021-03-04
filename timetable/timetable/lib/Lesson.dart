import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Lesson {
  String name;
  String abbreviazione;
  Color color;
  bool toShow;

  Lesson(this.name, this.abbreviazione, this.color) {
    toShow = true;
  }

  toMap() {
    return <String, dynamic> {
      "name": name,
      "abbreviazione": abbreviazione,
      "color": color.value,
      "toShow": toShow,
    };
  }


}