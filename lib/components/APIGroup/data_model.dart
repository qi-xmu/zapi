import 'package:zapi/components/API/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

/// DOING APIGroup
/// api组
/// 组内采用相同的认证
class ApiGroup {
  late int id; // 组的id用于数据库的识别
  String name;
  String url;
  // User? _user; // 用户
  List<dynamic> widgetList = [];
  // List<ApiWidgetInfo> switchList = [];
  // List<ApiWidgetInfo> buttonList = [];
  ApiGroup(this.name, this.url, {User? user}) {
    id = DateTime.now().millisecondsSinceEpoch;
    // widgetList.add(switchList);
    // widgetList.add(buttonList);
  }
  @override
  String toString() {
    return [id, name, url].toString();
  }

  /// 修改认证
  void modifyUser(User user) {}

  /// 添加新的api接口
  void addApi(ApiWidgetInfo api) {
    widgetList.add(api);
  }

  void addApis(List<ApiWidgetInfo> apis) {
    for (var api in apis) {
      addApi(api);
    }
  }
}
