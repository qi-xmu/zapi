import 'package:zapi/api.dart';

enum ApiWidgetType {
  BUTTON, // 按钮
  SWITCH, // 开关
  SLIDING, // 滑动条
  INFO, // 获取信息
}

class ApiWidgetInfo {
  ApiWidgetType type;
  ApiGroup group;
  late API api;

  ApiWidgetInfo(this.group, this.type) {
    api = API(group.url);
  }
}
