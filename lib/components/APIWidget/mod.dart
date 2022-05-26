library api_widget;

import 'dart:convert';

/// 这个部分是提供对外接口
///

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zapi/components/API/data_model.dart';

import 'package:flutter/material.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/DataStorage/mod.dart';
import 'package:zapi/modals/mod.dart';
import 'package:zapi/pages/group_page.dart';
import 'package:zapi/utils/standard.dart';
import 'package:zapi/utils/ext_widgets.dart';
import 'package:zapi/utils/tools.dart';

part 'data_model.dart';
part 'widgets.dart';
part 'actions.dart';
