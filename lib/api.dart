import 'package:dio/dio.dart';

enum HttpMethod { GET, POST, PUT, DELETE, PATCH }

/// @brief 每一个API对应一个环境，包含多个接口。用于发起请求
class API {
  String url;
  late Map<String, dynamic> _header;

  // 初始化
  API(this.url, {String? token}) {
    _header = {};
    if (token != null) {
      _header["token"] = token;
    }
  }

  /// 设置token
  set token(String token) {
    _header["token"] = token;
  }

  /// 自定义头部
  set addHeader(Map<String, dynamic> headers) {
    headers.forEach((key, value) {
      _header[key] = value;
    });
  }

  /// 参数位请求方式和请求参数。
  Future<Response> send(HttpMethod method, String path, Map<String, dynamic> param) async {
    Response response;
    path = url + path;
    switch (method) {
      case HttpMethod.GET:
        response = await Dio().get(path, queryParameters: param, options: Options(headers: _header));
        break;
      case HttpMethod.POST:
        response = await Dio().post(path, queryParameters: param, options: Options(headers: _header));
        break;
      case HttpMethod.PUT:
        response = await Dio().put(path, queryParameters: param, options: Options(headers: _header));
        break;
      case HttpMethod.DELETE:
        response = await Dio().delete(path, queryParameters: param, options: Options(headers: _header));
        break;
      case HttpMethod.PATCH:
        response = await Dio().patch(path, queryParameters: param, options: Options(headers: _header));
        break;
    }
    return response;
  }
}

/// api组
/// 组内采用相同的认证
class ApiGroup {
  late int id; // 组的id用于数据库的识别
  String url;
  User? _user; // 用户
  late List<API> apiList;
  ApiGroup(this.url, {User? user}) {
    apiList = [];
    id = DateTime.now().millisecondsSinceEpoch;
    _user = user;
  }

  /// 修改认证
  void modifyUser(User user) {
    _user = user;
  }

  /// 添加新的api接口
  void addApi(API api) {
    api.token = _user?.token ?? ""; // 添加认证
  }
}

/// 可选用户认证
class User {
  late String token;
  late String _username;
  late String _passwd;
  User(String username, String passwd) {
    _username = username;
    _passwd = passwd;
  }

  get name {
    return _username;
  }

  /// 登录
  void login() {
    // TODO 登录 get token and store token;
    _username;
    _passwd;
  }

  /// 获取token
  void getToken() {
    // TODO get token and store token;
  }

  /// 注销
  void cancel() {}
}
