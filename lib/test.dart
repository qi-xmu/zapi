/// 测试数据

import 'package:zapi/components/API/data_model.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

ApiGroup testGroup = ApiGroup(name: "测试", proto: Protocol.HTTP, url: "api.xmu-maker.cn:2233");

List<ApiWidgetInfo> apiList = [
  ApiWidgetInfo(
    type: ApiWidgetType.INFO,
    apiInfo: APIInfo(name: "信息", method: HttpMethod.GET, path: "/info"),
    control: "state",
    response: ["name", "botton", "value"],
    responseAlias: ["开关", "按键", "滑动值"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.SWITCH,
    apiInfo: APIInfo(name: "开关", method: HttpMethod.GET, path: "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.SWITCH,
    apiInfo: APIInfo(name: "开关3", method: HttpMethod.GET, path: "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(name: "按键", method: HttpMethod.GET, path: "/0"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(name: "错误请求按键", method: HttpMethod.GET, path: "/01"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(name: "成功请求按键", method: HttpMethod.GET, path: "/0"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.BUTTON,
    apiInfo: APIInfo(name: "测试请求按键测试请求按键", method: HttpMethod.GET, path: "/1"),
    response: ["botton"],
  ),
  ApiWidgetInfo(
    type: ApiWidgetType.SLIDING,
    apiInfo: APIInfo(name: "滑动", method: HttpMethod.POST, path: "/controll"),
    control: "action",
    options: [0.1, 100],
    response: ["action"],
  ),
];
