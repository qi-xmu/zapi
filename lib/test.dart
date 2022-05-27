/// 测试数据

import 'package:zapi/components/API/data_model.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

ApiGroup testGroup = ApiGroup(name: "测试", proto: Protocol.HTTP, url: "api.xmu-maker.cn:2233");

List<ApiWidgetInfo> apiList = [
  ApiWidgetInfo(
    type: ApiWidgetType.INFO,
    apiInfo: APIInfo(2, "信息", HttpMethod.GET, "/info"),
    control: "state",
    response: ["name", "botton", "value"],
    responseAlias: ["开关", "按键", "滑动值"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.SWITCH,
    apiInfo: APIInfo(4, "开关", HttpMethod.GET, "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.SWITCH,
    apiInfo: APIInfo(4, "开关3", HttpMethod.GET, "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(0, "按键", HttpMethod.GET, "/0"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(0, "错误请求按键", HttpMethod.GET, "/01"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(1, "成功请求按键", HttpMethod.GET, "/0"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(1, "测试请求按键测试请求按键", HttpMethod.GET, "/1"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.SLIDING,
    apiInfo: APIInfo(3, "滑动", HttpMethod.POST, "/controll"),
    control: "action",
    options: [0.1, 100],
    response: ["action"],
  ),
];
