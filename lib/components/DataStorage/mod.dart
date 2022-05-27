library data_storage;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/pages/group_page.dart';
import 'package:zapi/utils/standard.dart';
import 'package:zapi/utils/tools.dart';

part 'actions.dart';
part 'provider_model.dart';

late SharedPreferences prefs; // 共享数据
// Global Data;
// List<ApiGroup> groupList = [];
