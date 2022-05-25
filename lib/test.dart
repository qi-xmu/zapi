import 'package:zapi/api.dart';
import 'package:zapi/components/APIGroup/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

List<ApiGroup> groupList = [group];

ApiGroup group = ApiGroup("测试", "http://api.xmu-maker.cn:2233");

List<ApiWidgetInfo> apiList = [
  ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    group,
    APIInfo(0, "按键", HttpMethod.GET, ""),
    options: ["/01"],
    response: ["botton"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.BUTTON,
    group,
    APIInfo(1, "按键", HttpMethod.GET, ""),
    options: ["/1"],
    response: ["botton"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.INFO,
    group,
    APIInfo(2, "信息", HttpMethod.GET, "/info"),
    control: "state",
    options: ["info"],
    response: ["name", "botton", "value"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.SLIDING,
    group,
    APIInfo(3, "滑动", HttpMethod.POST, "/controll"),
    control: "action1",
    options: [0.1, 100],
    response: ["action"],
  ),
  ApiWidgetInfo(
    ApiWidgetType.SWITCH,
    group,
    APIInfo(4, "开关", HttpMethod.GET, "/"),
    control: "state",
    options: ["on", "off"],
    response: ["mgs"],
  ),
];
