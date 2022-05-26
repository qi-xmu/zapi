/// 测试数据

import 'package:zapi/components/API/data_model.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

ApiGroup testGroup = ApiGroup(1, "测试", "http://api.xmu-maker.cn:2233");

List<ApiWidgetInfo> apiList = [
  ApiWidgetInfo(
    ApiWidgetType.INFO,
    // group,
    APIInfo(2, "信息", HttpMethod.GET, "/info"),
    control: "state",

    response: ["name", "botton", "value"],
    responseAlias: ["开关", "按键", "滑动值"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.SWITCH,
    // group,
    APIInfo(4, "开关", HttpMethod.GET, "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.SWITCH,
    // group,
    APIInfo(4, "开关3", HttpMethod.GET, "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    // group,
    APIInfo(0, "按键", HttpMethod.GET, "/0"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    // group,
    APIInfo(0, "错误请求按键", HttpMethod.GET, "/01"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    // group,
    APIInfo(1, "成功请求按键", HttpMethod.GET, "/0"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    // group,
    APIInfo(1, "测试请求按键测试请求按键", HttpMethod.GET, "/1"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.SLIDING,
    // group,
    APIInfo(3, "滑动", HttpMethod.POST, "/controll"),
    control: "action",
    options: [0.1, 100],
    response: ["action"],
  ),
];
