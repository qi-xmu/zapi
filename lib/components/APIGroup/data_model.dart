import 'package:dio/dio.dart';
import 'package:zapi/components/API/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

/// DOING APIGroup
/// api组
/// 组内采用相同的认证
class ApiGroup {
  int id; // 组的id用于数据库的识别
  String name;
  String url;
  List<ApiWidgetInfo> widgetList = [];
  // User? _user; // 用户

  ApiGroup(this.id, this.name, this.url, {User? user}) {
    id = DateTime.now().millisecondsSinceEpoch;
  }
  // 序列化
  ApiGroup.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'] {
    widgetList = [];
    for (var info in json['widgetList']) {
      addApi(ApiWidgetInfo.fromJson(info));
    }
  }
  // users
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'widgetList': widgetList,
      };

  @override
  String toString() {
    return [id, name, url].toString();
  }

  /// 修改认证
  void modifyUser(User user) {}

  /// 添加新的api接口
  void addApi(ApiWidgetInfo api) {
    api.url = url; // 自动加入url
    widgetList.add(api);
  }

  void addApis(List<ApiWidgetInfo> apis) {
    for (var api in apis) {
      addApi(api);
    }
  }
}
