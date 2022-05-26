import 'package:flutter/material.dart';
import 'package:zapi/components/APIGroup/data_model.dart';

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

List<String> getNameList(List<ApiGroup> groups) {
  List<String> res = [];
  for (ApiGroup group in groups) {
    res.add(group.name);
  }
  return res;
}
