import 'package:zapi/components/API/data_model.dart';
import 'package:zapi/components/APIWidget/mod.dart';

// 协议
enum Protocol { HTTP, HTTPS }

// ignore: constant_identifier_names
const List<String> ProtoStr = ['http://', 'https://'];

/// api组
/// 组内采用相同的认证
class ApiGroup {
  int id; // 组的id用于数据库的识别
  String url;
  String name;
  Protocol proto = Protocol.HTTP;
  List<ApiWidgetInfo> widgetList = [];
  // User? _user; // 用户

  ApiGroup({
    this.id = 0,
    this.name = '',
    this.url = '',
    this.proto = Protocol.HTTP,
    User? user,
  }) {
    id = DateTime.now().millisecondsSinceEpoch;
  }
  // 序列化
  ApiGroup.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        proto = Protocol.values[json['proto']],
        url = json['url'] {
    widgetList = [];
    for (var info in json['widgetList']) {
      addApi(ApiWidgetInfo.fromJson(info));
    }
  }
  // 定义URL;
  String get realUrl => ProtoStr[proto.index] + url;

  // users
  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'name': name,
        'proto': proto.index,
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
    widgetList.add(api);
  }

  void addApis(List<ApiWidgetInfo> apis) {
    for (var api in apis) {
      addApi(api);
    }
  }
}
