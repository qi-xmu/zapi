import 'package:flutter/material.dart';
import 'package:zapi/components/APIGroup/data_model.dart';

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
