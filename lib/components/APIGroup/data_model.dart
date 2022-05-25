import 'package:zapi/api.dart';
import 'package:zapi/components/APIWidget/mod.dart';

/// DOING APIGroup
/// api组
/// 组内采用相同的认证
class ApiGroup {
  late int id; // 组的id用于数据库的识别
  String name;
  String url;
  User? _user; // 用户
  late List<ApiWidgetInfo> apiList;
  ApiGroup(this.name, this.url, {User? user}) {
    apiList = [];
    id = DateTime.now().millisecondsSinceEpoch;
    _user = user;
  }

  /// 修改认证
  void modifyUser(User user) {
    _user = user;
  }

  /// 添加新的api接口
  void addApi(ApiWidgetInfo api) {
    // api.token = _user?.token ?? ""; // 添加认证
    apiList.add(api);
  }

  void addApis(List<ApiWidgetInfo> api) {
    apiList.addAll(api);
  }
}
